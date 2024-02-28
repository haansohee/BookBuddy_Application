//
//  HomeViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 1/21/24.
//

import Foundation
import RxSwift

final class HomeViewModel {
    private let boardService = BoardService()
    private(set) var followingBoardInformations: [FollowingBoardInformation]?
    private(set) var userID = UserDefaults.standard.integer(forKey: UserDefaultsForkey.userID.rawValue)
    private(set) var isUploadedFollowingBoardInfo = BehaviorSubject(value: "noValue")
    private(set) var isUploadedBoardLikedInfo = BehaviorSubject(value: "noValue")
    private(set) var boardLikedPostIDList: [BoardLikeInformation]?
    
    func getFollowingBoards() {
        userID = UserDefaults.standard.integer(forKey: UserDefaultsForkey.userID.rawValue)
        boardService.getFollowingBoards(userID: userID) { [weak self] followingBoardInformation in
            self?.followingBoardInformations = followingBoardInformation
            self?.isUploadedFollowingBoardInfo.onNext("setValue")
        }
    }
    
    func setBoardLikeInformation(_ boardLikeInformation: BoardLikeInformation, completion: @escaping(Bool)->Void) {
        boardService.setBoardLike(with: boardLikeInformation) { result in
            completion(result)
        }
    }
    
    func deleteBoardLikeInformation(_ boardLikeInformation: BoardLikeInformation, completion: @escaping(Bool)->Void) {
        boardService.deleteBoardLike(with: boardLikeInformation) { result in
            completion(result)
        }
    }
    
    func IsHiddenReadMore(_ content: String) -> Bool {
        if content.contains("\n") || content.contains("\n\n") {
            return false
        } else {
            return content.count < 15 ? true : false
        }
    }
}
