//
//  MemberNicknameUpdateInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 1/13/24.
//

import Foundation

struct MemberNicknameUpdateInformation {
    let newNickname: String
    let nickname: String
}

extension MemberNicknameUpdateInformation {
    func toRequestDTO() -> MemberNicknameUpdateDTO {
        return .init(newNickname: newNickname, nickname: nickname)
    }
}
