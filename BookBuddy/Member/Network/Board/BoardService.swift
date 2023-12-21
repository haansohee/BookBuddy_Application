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
                    if try JSONSerialization.jsonObject(with: data, options: .allowFragments) is BoardDTO {
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
}
