//
//  MemberPasswordUpdateInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 2/1/24.
//

import Foundation

struct MemberPasswordUpdateInformation {
    let newPassword: String
    let nickname: String
}

extension MemberPasswordUpdateInformation {
    func toRequestDTO() -> MemberPasswordUpdateDTO {
        return .init(newPassword: newPassword, nickname: nickname)
    }
}
