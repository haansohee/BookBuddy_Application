//
//  CommentUploadInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 1/31/24.
//

import Foundation

struct CommentUploadInformation {
    let postID: Int
    let userID: Int
    let writeDate: String
    let commentContent: String
    let nickname: String
    let profile: Data?
}

extension CommentUploadInformation {
    func toRequestDTO() -> CommentUploadDTO {
        return .init(postID: postID, userID: userID, writeDate: writeDate, commentContent: commentContent, nickname: nickname, profile: profile)
    }
}
