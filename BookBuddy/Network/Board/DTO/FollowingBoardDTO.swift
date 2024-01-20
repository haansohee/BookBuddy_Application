//
//  FollowingBoardDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 1/21/24.
//

import Foundation

struct FollowingBoardDTO: Codable {
    let postID: Int
    let nickname: String
    let writeDate: String
    let contentTitle: String
    let content: String
    let likes: Int
    let boardImage: Data
    let profileImage: Data?
}

extension FollowingBoardDTO {
    func toDomain() -> FollowingBoardInformation {
        return .init(postID: postID, nickname: nickname, writeDate: writeDate, contentTitle: contentTitle, content: content, likes: likes, boardImage: boardImage, profileImage: profileImage)
    }
}
