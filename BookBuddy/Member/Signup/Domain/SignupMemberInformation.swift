//
//  SignupMemberInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 11/20/23.
//

import Foundation

struct SignupMemberInformation {
    let nickname: String
    let email: String
    let password: String
}

extension SignupMemberInformation {
    func toRequestDTO() -> MemberDTO {
        return .init(nickname: nickname, email: email, password: password)
    }
}
