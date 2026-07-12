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
    private(set) var bookSearchResults: [BookSearchContents] = []
    private(set) var imageData: Data?
    private(set) var category: [String] = []
    private(set) var bookInformations: BookInformation?
    
    func parsing(bookTitle: String) {
        guard let baseURL = Bundle.main.infoDictionary?["API_URL"] as? String else {
            isParsed.onNext(false)
            return }
        let urlString = baseURL + "&query=\(bookTitle)"
        
        guard let url = URL(string: urlString),
              let clientID = Bundle.main.infoDictionary?["Client_Id"] as? String,
              let clientSecret = Bundle.main.infoDictionary?["Client_Secret"] as? String else { return }
        
        startParsing(url: url, clientID: clientID, clientSecret: clientSecret) { [weak self] bookSearchResults in
            guard !bookSearchResults.isEmpty else {
                self?.isParsed.onNext(false)
                return }
            self?.bookSearchResults = bookSearchResults
            let urls = bookSearchResults.map({ $0.link })
            
            self?.crawling(with: urls) { [weak self] result in
                guard result else { return }
                self?.isParsed.onNext(result)
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
                completion([])
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("ERROR \(String(describing: error?.localizedDescription))")
                completion([])
                return
            }
            
            switch response.statusCode {
            case 200..<300:
                guard let data = data,
                      let results = try? JSONDecoder().decode(BookSearchRequestDTO.self, from: data) else { return }
                completion(results.items)
                
            default:
                print("ERROR \(String(describing: error?.localizedDescription))")
                completion([])
                return
            }
        }
        task.resume()
    }
    
    
    
    func loadImageData(imageURL: URL, completion: @escaping((Data)) -> Void) {
        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("ERROR: Load Image Data, \(error.localizedDescription)")
                completion(Data())
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(Data())
                return }
            
            switch httpResponse.statusCode {
            case 200..<300:
                guard let data = data else {
                    completion(Data())
                    return }
                completion(data)
            default:
                completion(Data())
                return
            }
        }
        task.resume()
    }
    
    func crawling(with urlAddress: [String], completion: @escaping(Bool) -> Void) {
        
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
                        completion(true)
                    }
                    
                } catch let error {
                    print("ERROR: \(error.localizedDescription)")
                    completion(false)
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
    
    func canceledSearch() {
        bookSearchResults = []
    }
    
}

