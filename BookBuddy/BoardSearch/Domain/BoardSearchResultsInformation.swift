//
//  BoardSearchResultsInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 1/10/24.
//

import Foundation

struct BoardSearchResultsInformation {
    let postID: Int
    let nickname: String
    let writeDate: String
    let contentTitle: String
    let content: String
    let likes: Int
    let boardImage: Data
    let profileImage: Data?
    let didLike: Bool
    let postFromUser: Bool
    var comments: [CommentInformation]
}
