//
//  BoardEditViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 2/13/24.
//

import Foundation
import RxSwift

final class BoardEditViewModel {
    private let boardService = BoardService()
    private(set) var boardEditInformation: BoardEditInformation?
    let isBoardInfoUpdated = PublishSubject<Bool>()
    
    func setBoardEditInformation(_ boardEditInformation: BoardEditInformation) {
        self.boardEditInformation = boardEditInformation
    }
    
    func updateBoardInformation(_ boardEditInformation: BoardEditInformation) {
        boardService.updateBoardInfo(with: boardEditInformation) { [weak self] result in
            self?.isBoardInfoUpdated.onNext(result)
            guard result else { return }
            self?.setBoardEditInformation(boardEditInformation)
        }
    }
}
