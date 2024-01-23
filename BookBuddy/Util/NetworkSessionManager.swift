//
//  URLSessionMethod.swift
//  BookBuddy
//
//  Created by 한소희 on 1/20/24.
//

import Foundation

final class NetworkSessionManager {
    private let postMethod: HTTPMethod = .POST
    private let getMethod: HTTPMethod = .GET
    
    func urlGetMethod<T: Codable>(url: URL, requestDTO: T.Type, completion: @escaping(Result<T, Error>)->Void) {
        var request = URLRequest(url: url)
        request.httpMethod = getMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            print(response.statusCode)
            
            switch response.statusCode {
            case 200..<300:
                guard let data = data,
                      let json = try? JSONDecoder().decode(requestDTO.self, from: data) else { return }
                completion(.success(json))
                return
                
            default:
                print("ERROR: \(String(describing: error?.localizedDescription))")
                return
            }
        }
        task.resume()
    }
    
    func urlPostMethod<T: Codable>(url: URL, encodeValue: T, completion: @escaping(Bool)->Void) {
        
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        request.httpMethod = postMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(encodeValue)
        } catch {
            print("ERROR: Encoding Reuqest Data: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("ERROR: \(error)")
                return
            }
            if let data = data {
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    completion(true)
                    return
                    
                } catch {
                    print("ERROR Decoding Response Data: \(error)")
                    completion(false)
                    return
                }
            }
        }
        task.resume()
    }
}
