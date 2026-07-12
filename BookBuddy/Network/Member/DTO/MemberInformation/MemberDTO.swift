//
//  MemberDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 11/13/23.
//

import Foundation

struct MemberDTO: Codable {
    let userID: Int
    let nickname: String
    let email: String
    let password: String
    let profile: Data?
    let favorite: String?
}
