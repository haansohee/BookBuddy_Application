//
//  MemberAppleTokenDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 11/24/23.
//

import Foundation

struct MemberAppleTokenDTO: Codable {
    let userID: Int?
    let nickname: String?
    let email: String?
    let appleToken: String?
    let profile: Data?
    let favorite: String?
}
