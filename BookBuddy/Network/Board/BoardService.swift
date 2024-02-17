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
    private let networkSessionManager = NetworkSessionManager()
    
    func setBoardInfo(with boardWriteInformation: BoardWriteInformation, completion: @escaping((Bool)) -> Void) {
        let path = "/BookBuddyInfo/setBoards/"
        let board = boardWriteInformation.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: board) { result in
            completion(result)
        }
    }
    
    func setBoardLike(with boardLikeInformation: BoardLikeInformation, completion: @escaping(Bool)->Void) {
        let path = "/BookBuddyInfo/setBoardLike/"
        let boardLikeDTO = boardLikeInformation.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: boardLikeDTO) { result in
            completion(result)
        }
    }
    
    func deleteBoardLike(with boardLikeInformation: BoardLikeInformation, completion: @escaping(Bool) -> Void) {
        let path = "/BookBuddyInfo/deleteBoardLike/"
        let boardLikeDTO = boardLikeInformation.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: boardLikeDTO) { result in
            completion(result)
        }
    }
    
    func deleteBoard(with boardDeleteInformation: BoardDeleteInformation, completion: @escaping(Bool)->Void) {
        let path = "/BookBuddyInfo/deleteBoard/"
        let boardDeleteDTO = boardDeleteInformation.toRequestDTO()
        networkSessionManager.urlDeleteMethod(path: path, encodeValue: boardDeleteDTO) { result in
            completion(result)
        }
    }
    
    func updateBoardInfo(with boardEditInformation: BoardEditInformation, completion: @escaping(Bool)->Void) {
        let path = "/BookBuddyInfo/updateBoard/"
        let boardEditDTO = boardEditInformation.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: boardEditDTO) { result in
            completion(result)
        }
    }
    
    func getMemberBoards(nickname: String, completion: @escaping([BoardWrittenInformation])->Void) {
        let path = "/BookBuddyInfo/getMemberBoards?nickname=\(nickname)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [BoardWrittenDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let boardWrittenInformaitions = responseDTO.map { $0.toDomain() }
                completion(boardWrittenInformaitions)
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getDetailBoardInfo(postID: Int, userID: Int, completion: @escaping(BoardDetailInformation)->Void) {
        let path = "/BookBuddyInfo/getDetailBoardInfo?postID=\(postID)&userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: BoardDetailDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.toDomain())
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getSearchBoards(searchWord: String, userID: Int, completion: @escaping([BoardSearchResultsInformation]) -> Void) {
        let path = "/BookBuddyInfo/getSearchBoards?searchWord=\(searchWord)&userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [BoardSearchResultsDTO].self) { result in
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
        let path = "/BookBuddyInfo/getFollowingBoards?userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [FollowingBoardDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let followingBoardInformation = responseDTO.map { $0.toDomain() }
                completion(followingBoardInformation)
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getBoardLikedPostID(userID: Int, completion: @escaping([Int]) -> Void) {
        let path = "/BookBuddyInfo/getBoardLikedPostID?userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [Int].self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO)
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
}
