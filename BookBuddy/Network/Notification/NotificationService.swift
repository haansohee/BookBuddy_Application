//
//  NotificationService.swift
//  BookBuddy
//
//  Created by 한소희 on 3/18/24.
//

import Foundation

final class NotificationService {
    private let networkSessionManager = NetworkSessionManager()
    
    func sendLikeNofitication(with sendNotification: SendNotificationInformation, completion: @escaping(Bool)->Void) {
        let path = "/BookBuddyInfo/sendLikeNofitication/"
        let likeNotification = sendNotification.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: likeNotification) { result in
            completion(result)
        }
    }
    
    func sendCommentNotification(with sendNotification: SendNotificationInformation, completion: @escaping(Bool)->Void) {
        let path = "/BookBuddyInfo/sendCommentNofitication/"
        let commentNotification = sendNotification.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: commentNotification) { result in
            completion(result)
        }
    }
    
    func getNotifications(with userID: Int, completion: @escaping([NotificationInformation])->Void) {
        let path = "/BookBuddyInfo/getNotifications?userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [NotificationDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let notificationInformation = responseDTO.map { $0.toDomain() }
                completion(notificationInformation)
            case .failure(let error):
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
}
