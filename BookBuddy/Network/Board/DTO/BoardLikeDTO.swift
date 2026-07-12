//
//  BoardLikeDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 1/23/24.
//

import Foundation

struct BoardLikeDTO: Codable {
    let likedUserID: Int
    let postUserNickname: String
    let postID: Int
}

extension BoardLikeDTO {
    func toDomain() -> BoardLikeInformation {
        return .init(likedUserID: likedUserID, postUserNickname: postUserNickname, postID: postID)
    }
}
