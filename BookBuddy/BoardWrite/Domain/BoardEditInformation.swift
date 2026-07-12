//
//  BoardEditInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 2/13/24.
//

import Foundation

struct BoardEditInformation {
    let postID: Int
    let nickname: String
    let contentTitle: String
    let content: String
    let boardImage: Data
}

extension BoardEditInformation {
    func toRequestDTO() -> BoardEditDTO {
        return .init(postID: postID, nickname: nickname, contentTitle: contentTitle, content: content, boardImage: boardImage)
    }
}
