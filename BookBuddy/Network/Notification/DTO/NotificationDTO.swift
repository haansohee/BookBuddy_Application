//
//  NotificationDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 3/21/24.
//

import Foundation

struct NotificationDTO: Codable {
    let notificationID: Int
    let notificationContent: String
    let profileImage: Data?
    let boardImage: Data?

    enum CodingKeys: String, CodingKey {
        case notificationID
        case notificationContent
        case profileImage
        case boardImage
    }
}

extension NotificationDTO {
    func toDomain() -> NotificationInformation {
        return .init(notificationID: notificationID, notificationContent: notificationContent, profileImage: profileImage, boardImage: boardImage)
    }
}
