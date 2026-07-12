//
//  SearchMemberDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 1/16/24.
//

import Foundation

struct SearchMemberDTO: Codable {
    let userID: Int
    let nickname: String
    let profile: Data?
    let favorite: String?
}

extension SearchMemberDTO {
    func toDomain() -> SearchMemberInformation {
        return .init(userID: userID, nickname: nickname, profile: profile, favorite: favorite)
    }
}
