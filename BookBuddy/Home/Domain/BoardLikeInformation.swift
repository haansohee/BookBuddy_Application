//
//  BoardLikeInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 1/23/24.
//

import Foundation

struct BoardLikeInformation {
    let likedUserID: Int
    let postUserNickname: String
    let postID: Int
}

extension BoardLikeInformation {
    func toRequestDTO() -> BoardLikeDTO {
        return .init(likedUserID: likedUserID, postUserNickname: postUserNickname, postID: postID)
    }
}
