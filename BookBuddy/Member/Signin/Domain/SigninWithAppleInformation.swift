//
//  SigninWithAppleInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 11/24/23.
//

import Foundation

struct SigninWithAppleInformation {
    let nickname: String
    let email: String
    let appleToken: String
}

extension SigninWithAppleInformation {
    func toRequestDTO() -> MemberAppleTokenDTO {
        return .init(nickname: nickname, email: email, appleToken: appleToken)
    }
}
