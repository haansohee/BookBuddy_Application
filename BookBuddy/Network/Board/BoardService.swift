//
//  BoardService.swift
//  BookBuddy
//
//  Created by 한소희 on 12/20/23.
//

import Foundation
import RxSwift
import RxCocoa

final class BoardService {
    private let postMethod: HTTPMethod = .POST
    private let getMethod: HTTPMethod = .GET
    
    func setBoardInfo(with boardWriteInformation: BoardWriteInformation, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/setBoards/") else { return }
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        let board = boardWriteInformation.toRequestDTO()
        request.httpMethod = postMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try encoder.encode(board)
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
                    if try JSONSerialization.jsonObject(with: data, options: .allowFragments) is BoardWriteDTO {
                    }
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
    
    func getMemberBoards(nickname: String, completion: @escaping([BoardWrittenInformation])->Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getMemberBoards?nickname=\(nickname)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = getMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            print("response Code : \(response.statusCode)")
            
            switch response.statusCode {
            case 200..<300:
                guard let data = data,
                      let json = try? JSONDecoder().decode([BoardWrittenDTO].self, from: data) else {
                    completion([])
                    return }
                let boardWrittenInformaitions = json.map { $0.toDomain() }
                completion(boardWrittenInformaitions)
                return
                
            default:
                print("ERROR: \(String(describing: error?.localizedDescription))")
                return
            }
        }
        task.resume()
    }
    
    func getSearchBoards(searchWord: String, completion: @escaping([BoardSearchResultsInformation]) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getSearchBoards?searchWord=\(searchWord)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = getMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            print("response Code : \(response.statusCode)")
            
            switch response.statusCode {
            case 200..<300:
                guard let data = data,
                      let json = try? JSONDecoder().decode([BoardSearchResultsDTO].self, from: data) else {
                    print("디코딩 실패")
                    completion([])
                    return }
                let boardSearchResultsInformation = json.map { $0.toDomain() }
                print("result: \(boardSearchResultsInformation)")
                completion(boardSearchResultsInformation)
                return
                
            default:
                print("ERROR: \(String(describing: error?.localizedDescription))")
                return
            }
        }
        task.resume()
    }
}
