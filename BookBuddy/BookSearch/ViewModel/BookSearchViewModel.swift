//
//  BookSearchViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 10/9/23.
//

import Foundation
import RxSwift
import SwiftSoup

final class BookSearchViewModel {
    let isParsed = PublishSubject<Bool>()
    var bookSearchResults: [BookSearchContents] = []
    private(set) var imageData: Data?
    private(set) var category: [String] = []
    private(set) var bookInformations: BookInformation?
    var isSearched = false
    
    func parsing(bookTitle: String) {
        guard let baseURL = Bundle.main.infoDictionary?["API_URL"] as? String else { return }
        let urlString = baseURL + "&query=\(bookTitle)"
        
        guard let url = URL(string: urlString),
              let clientID = Bundle.main.infoDictionary?["Client_Id"] as? String,
              let clientSecret = Bundle.main.infoDictionary?["Client_Secret"] as? String else { return }
        
        startParsing(url: url, clientID: clientID, clientSecret: clientSecret) { [weak self] bookSearchResults in
            self?.bookSearchResults = bookSearchResults
            let urls = bookSearchResults.map({ $0.link })
            
            self?.crawling(with: urls) { [weak self] in
                self?.isParsed.onNext(true)
            }
        }
    }
    
    private func startParsing(url: URL, clientID: String, clientSecret: String, completion: @escaping(([BookSearchContents]) -> Void)) {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("ERROR \(String(describing: error?.localizedDescription))")
                return
            }
            
            switch response.statusCode {
            case 200..<300:
                guard let data = data,
                      let results = try? JSONDecoder().decode(BookSearchRequestDTO.self, from: data) else { return }
                completion(results.items)
                
            default:
                print("ERROR \(String(describing: error?.localizedDescription))")
                return
            }
        }
        task.resume()
    }
    
    
    
    func loadImageData(imageURL: URL, completion: @escaping((Data)) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageURL) {
                completion(data)
            }
        }
    }
    
    func crawling(with urlAddress: [String], completion: @escaping(()) -> Void) {
        
        let urlCount = urlAddress.count
        var currentCount = 0
        
        urlAddress.forEach {
            guard let url = URL(string: $0) else { return }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data,
                      let html = String(data: data, encoding: .utf8) else { return }
                
                do {
                    let doc = try SwiftSoup.parse(html)
                    let elements = try doc.select("#book_section-info > div.bookBasicInfo_basic_info__HCWyr > ul > li:nth-child(1) > div > div.bookBasicInfo_info_detail__I0Fx5")
                    
                    self?.category.append(try elements.text())
                    currentCount += 1
        
                    if urlCount == currentCount {
                        completion(())
                    }
                    
                } catch let error {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
    }
    
    func setBookInformationData(title: String, author: String, category: String, description: String, image: Data, link: String) {
        let bookInformationData = BookInformation(image: image,
                                                  title: title,
                                                  author: author,
                                                  category: category,
                                                  description: description,
                                                  link: link)
        bookInformations = bookInformationData
     }
}

