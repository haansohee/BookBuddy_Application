//
//  FollowingBoardInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 1/21/24.
//

import Foundation

struct FollowingBoardInformation {
    let postID: Int
    let nickname: String
    let writeDate: String
    let contentTitle: String
    let content: String
    let likes: Int
    let boardImage: Data
    let profileImage: Data?
    let didLike: Bool
    var comments: [CommentInformation]
}
