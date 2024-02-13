//
//  BoardDetailDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 2/14/24.
//

import Foundation

struct BoardDetailDTO: Codable {
    let postID: Int
    let nickname: String
    let writeDate: String
    let contentTitle: String
    let content: String
    let likes: Int
    let boardImage: Data
    let didLike: Bool
    var comments: [CommentDTO]
}

extension BoardDetailDTO {
    func toDomain() -> BoardDetailInformation {
        return .init(postID: postID, nickname: nickname, writeDate: writeDate, contentTitle: contentTitle, content: content, likes: likes, boardImage: boardImage, didLike: didLike, comments: comments.map { $0.toDomain() })
    }
}
