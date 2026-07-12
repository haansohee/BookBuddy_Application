//
//  BoardWriteViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 12/20/23.
//

import Foundation
import RxSwift

final class BoardWriteViewModel {
    private let service = BoardService()
    private(set) var isBoardUploaded = PublishSubject<Bool>()
    
    func uploadBoard(boardWriteInformation: BoardWriteInformation) {
        service.setBoardInfo(with: boardWriteInformation) { [weak self] isUpload in
            self?.isBoardUploaded.onNext(isUpload)
        }
    }
}
