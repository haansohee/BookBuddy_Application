//
//  NotificationDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 3/21/24.
//

import Foundation

struct NotificationDTO: Codable {
    let notificaitonID: Int
    let notificationContent: String
    let profileImage: Data?
    let boardImage: Data
}

extension NotificationDTO {
    func toDomain() -> NotificationInformation {
        return .init(notificaitonID: notificaitonID, notificationContent: notificationContent, profileImage: profileImage, boardImage: boardImage)
    }
}
