//
//  BoardDetailVieWModel.swift
//  BookBuddy
//
//  Created by 한소희 on 12/22/23.
//

import Foundation

final class BoardDetailVieWModel {
    private(set) var boardWrittenInformation: BoardWrittenInformation?
    
    func setBoardWrittenInformation(_ boardWrittenInformation: BoardWrittenInformation) {
        self.boardWrittenInformation = boardWrittenInformation
    }
}
