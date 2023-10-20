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
    private(set) var isParsed = PublishSubject<Bool>()
    private(set) var bookSearchResults: [BookSearchContents] = []
    private var httpMethod: HTTPMethod = .GET
    private(set) var imageData: Data?
    
    func parsing(bookTitle: String) {
        guard let baseURL = Bundle.main.infoDictionary?["API_URL"] as? String else { return }
        let urlString = baseURL + "&query=\(bookTitle)"
        
        guard let url = URL(string: urlString),
              let clientID = Bundle.main.infoDictionary?["Client_Id"] as? String,
              let clientSecret = Bundle.main.infoDictionary?["Client_Secret"] as? String else { return }
        
        startParsing(url: url, clientID: clientID, clientSecret: clientSecret) { [weak self] bookSearchResults in
            self?.bookSearchResults = bookSearchResults
            self?.isParsed.onNext(true)
        }
    }
    
    func startParsing(url: URL, clientID: String, clientSecret: String, completion: @escaping(([BookSearchContents]) -> Void)) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
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
    
    func crawling(with urlAddress: String, completion: @escaping((()) -> Void)) {
        guard let url = URL(string: urlAddress) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            
            guard let data = data,
                  let html = String(data: data, encoding: .utf8) else { return }
            
            do {
                let doc = try SwiftSoup.parse(html)
                let elements = try doc.select("#book_section-info > div.bookBasicInfo_basic_info__HCWyr > ul > li:nth-child(1) > div > div.bookBasicInfo_info_detail__I0Fx5")
                print(try elements.text())
            } catch let error {
                print("ERROR: \(error.localizedDescription)")
            }
            
            completion(())
        }
        task.resume()
    }
}
