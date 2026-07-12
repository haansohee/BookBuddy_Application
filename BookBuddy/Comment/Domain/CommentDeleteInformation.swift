//
//  CommentDeleteInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 2/16/24.
//

import Foundation

struct CommentDeleteInformation {
    let commentID: Int
    let commentUserID: Int
}

extension CommentDeleteInformation {
    func toRequestDTO() -> CommentDeleteDTO {
        return .init(commentID: commentID, commentUserID: commentUserID)
    }
}
