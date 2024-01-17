//
//  FollowingListDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 1/17/24.
//

import Foundation

struct FollowingListDTO: Codable {
    let userID: Int
    let nickname: String
    let profile: Data
}

extension FollowingListDTO {
    func toDomain() -> FollowingListInformation {
        return .init(userID: userID, nickcname: nickname, profile: profile)
    }
}
