//
//  LikeNotificationInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 3/18/24.
//

import Foundation

struct SendNotificationInformation {
    let senderNickname: String
    let postID: Int
}

extension SendNotificationInformation {
    func toRequestDTO() -> SendNotificationDTO {
        return .init(senderNickname: senderNickname, postID: postID)
    }
}
