//
//  BoardDetailInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 2/14/24.
//

import Foundation

struct BoardDetailInformation {
    let postID: Int
    let nickname: String
    let writeDate: String
    let contentTitle: String
    let content: String
    let likes: Int
    let boardImage: Data
    let didLike: Bool
    let postFromUser: Bool
    var comments: [CommentInformation]
}
