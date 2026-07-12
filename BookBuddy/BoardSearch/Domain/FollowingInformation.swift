//
//  FollowingInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 1/17/24.
//

import Foundation

struct FollowingInformation {
    let followingUserID: Int
    let followerUserID: Int
}

extension FollowingInformation {
    func toRequestDTO() -> FollowingDTO {
        return .init(followingUserID: followingUserID, followerUserID: followerUserID)
    }
}
