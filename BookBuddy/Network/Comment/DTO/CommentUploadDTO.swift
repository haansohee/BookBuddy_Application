//
//  CommentUploadDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 1/31/24.
//

import Foundation

struct CommentUploadDTO: Codable {
    let postID: Int
    let userID: Int
    let writeDate: String
    let commentContent: String
    let nickname: String
    let profile: Data?
}
