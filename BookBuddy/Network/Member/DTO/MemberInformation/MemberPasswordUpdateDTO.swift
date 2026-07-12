//
//  MemberPasswordUpdateDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 2/1/24.
//

import Foundation

struct MemberPasswordUpdateDTO: Codable {
    let newPassword: String
    let nickname: String
}
