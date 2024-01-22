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
    private let userID = UserDefaults.standard.integer(forKey: UserDefaultsForkey.userID.rawValue)
    private(set) var isUploadedFollowingBoardInfo = BehaviorSubject(value: "noValue")
    
    func getFollowingBoards() {
        boardService.getFollowingBoards(userID: userID) { [weak self] followingBoardInformation in
            self?.followingBoardInformations = followingBoardInformation
            self?.isUploadedFollowingBoardInfo.onNext("setValue")
        }
    }
}
