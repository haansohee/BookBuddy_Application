//
//  SearchBoardResultsDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 1/10/24.
//

import Foundation

struct BoardSearchResultsDTO: Codable {
    let postID: Int
    let nickname: String
    let writeDate: String
    let contentTitle: String
    let content: String
    let likes: Int
    let boardImage: Data
    let profileImage: Data?
}

extension BoardSearchResultsDTO {
    func toDomain() -> BoardSearchResultsInformation {
        return .init(postID: postID, nickname: nickname, writeDate: writeDate, contentTitle: contentTitle, content: content, likes: likes, boardImage: boardImage, profileImage: profileImage)
    }
}
