//
//  NotificationViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 3/21/24.
//

import Foundation
import RxSwift

final class NotificationViewModel {
    private let notificationService = NotificationService()
    private let userID = UserDefaults.standard.integer(forKey: UserDefaultsForkey.userID.rawValue)
    private(set) var notificationInformation: [NotificationInformation] = []
    let isLoadedNotificationInfo = PublishSubject<Bool>()
    
    func getNotificationInformation() {
        notificationService.getNotifications(with: userID) { [weak self] notificationInfo in
            self?.notificationInformation = notificationInfo
            self?.isLoadedNotificationInfo.onNext(true)
        }
    }
}
