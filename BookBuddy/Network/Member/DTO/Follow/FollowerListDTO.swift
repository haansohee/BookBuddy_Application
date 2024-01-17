//
//  FollowerListDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 1/17/24.
//

import Foundation

struct FollowerListDTO: Codable {
    let userID: Int
    let nickname: String
    let profile: Data
}

extension FollowerListDTO {
    func toDomain() -> FollowerListInformation {
        return .init(userID: userID, nickname: nickname, profile: profile)
    }
}
