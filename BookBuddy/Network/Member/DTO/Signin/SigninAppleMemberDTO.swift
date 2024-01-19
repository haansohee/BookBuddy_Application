//
//  SigninAppleMemberDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 1/17/24.
//

import Foundation

struct SigninAppleMemberDTO: Codable {
    let nickname: String?
    let email: String?
    let appleToken: String?
}
