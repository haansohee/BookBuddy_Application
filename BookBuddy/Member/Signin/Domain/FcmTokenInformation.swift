//
//  FcmTokenInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 3/11/24.
//

import Foundation

struct FcmTokenInformation {
    let userID: Int
    let fcmToken: String
}

extension FcmTokenInformation {
    func toRequestDTO() -> FcmTokenDTO {
        return .init(userID: userID, fcmToken: fcmToken)
    }
}
