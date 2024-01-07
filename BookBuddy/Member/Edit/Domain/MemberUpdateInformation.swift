//
//  MemberProfileInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 12/28/23.
//

import Foundation

struct MemberUpdateInformation: Codable {
    let nickname: String?
    let profile: Data?
}

extension MemberUpdateInformation {
    func toRequestDTO() -> MemberUpdateDTO {
        return .init(nickname: nickname, profile: profile)
    }
}
