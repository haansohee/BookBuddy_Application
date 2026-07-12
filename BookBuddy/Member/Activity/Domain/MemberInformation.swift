//
//  MemberInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 2/23/24.
//

import Foundation

struct MemberInformation {
    let userID: Int
    let email: String
    var appleToken: String?
    var password: String?
    var nickname: String?
    var favorite: String?
    var profile: Data?
}
