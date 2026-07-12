//
//  FcmTokenDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 3/11/24.
//

import Foundation

struct FcmTokenDTO: Codable {
    let userID: Int
    let fcmToken: String
}
