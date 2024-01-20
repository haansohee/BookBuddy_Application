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
    private let urlSessionMethod = URLSessionMethod()
    
    func setBoardInfo(with boardWriteInformation: BoardWriteInformation, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/setBoards/") else { return }
        let board = boardWriteInformation.toRequestDTO()
        urlSessionMethod.urlPostMethod(url: url, encodeValue: board) { result in
            completion(result)
        }
    }
    
    func getMemberBoards(nickname: String, completion: @escaping([BoardWrittenInformation])->Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getMemberBoards?nickname=\(nickname)") else { return }
        urlSessionMethod.urlGetMethod(url: url, requestDTO: [BoardWrittenDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let boardWrittenInformaitions = responseDTO.map { $0.toDomain() }
                completion(boardWrittenInformaitions)
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getSearchBoards(searchWord: String, completion: @escaping([BoardSearchResultsInformation]) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getSearchBoards?searchWord=\(searchWord)") else { return }
        urlSessionMethod.urlGetMethod(url: url, requestDTO: [BoardSearchResultsDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let boardSearchResultsInformation = responseDTO.map { $0.toDomain() }
                completion(boardSearchResultsInformation)
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getFollowingBoards(userID: Int, completion: @escaping([FollowingBoardInformation]) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getFollowingBoards?userID=\(userID)") else { return }
        urlSessionMethod.urlGetMethod(url: url, requestDTO: [FollowingBoardDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let followingBoardInformation = responseDTO.map { $0.toDomain() }
                completion(followingBoardInformation)
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
}
