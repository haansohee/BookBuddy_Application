//
//  LikeNotificationDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 3/18/24.
//

import Foundation

struct SendNotificationDTO: Codable {
    let senderNickname: String
    let postID: Int
}
