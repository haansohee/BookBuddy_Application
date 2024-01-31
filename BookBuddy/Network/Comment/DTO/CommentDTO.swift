//
//  CommentDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 1/31/24.
//

import Foundation

struct CommentDTO: Codable {
    let commentID: Int
    let postID: Int
    let userID: Int
    let writeDate: String
    let commentContent: String
    let nickname: String
    let profile: Data?
}

extension CommentDTO {
    func toDomain() -> CommentInformation {
        return .init(commentID: commentID, postID: postID, userID: userID, writeDate: writeDate, commentContent: commentContent, nickname: nickname, profile: profile)
    }
}
