//
//  BoardDetailViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 12/22/23.
//

import Foundation
import RxSwift

final class BoardDetailViewModel {
    private let boardService = BoardService()
    private(set) var postID: Int?
    private(set) var boardDetailInformation: BoardDetailInformation?
    private(set) var isBoardDetailInfoLoaded = BehaviorSubject(value: "noValue")
    private(set) var isBoardDeleted = PublishSubject<Bool>()
    
    func getDetailBoardInformation(_ postID: Int) {
        self.postID = postID
        let userID = UserDefaults.standard.integer(forKey: UserDefaultsForkey.userID.rawValue)
        boardService.getDetailBoardInfo(postID: postID, userID: userID) { [weak self] result in
            self?.boardDetailInformation = result
            self?.isBoardDetailInfoLoaded.onNext("setValue")
        }
    }
    
    func deleteBoard() {
        guard let boardDetailInformation = boardDetailInformation else { return }
        let postID = BoardDeleteInformation(postID: boardDetailInformation.postID)
        boardService.deleteBoard(with: postID) { [weak self] result in
            self?.isBoardDeleted.onNext(result)
        }
    }
}
