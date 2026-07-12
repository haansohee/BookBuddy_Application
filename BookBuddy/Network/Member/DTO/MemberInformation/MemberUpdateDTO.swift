//
//  MemberProfileDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 12/28/23.
//

import Foundation

struct MemberUpdateDTO: Codable {
    let nickname: String?
    let profile: Data?
}

extension MemberUpdateDTO {
    func toDomain() -> MemberUpdateInformation {
        return .init(nickname: nickname, profile: profile)
    }
}
