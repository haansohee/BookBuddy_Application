//
//  MemberSigninViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 11/17/23.
//

import Foundation
import AuthenticationServices
import RxSwift
import Firebase

final class MemberSigninViewModel {
    private let service = MemberService()
    private(set) var isSigned = PublishSubject<Bool>()
    
    func signin(nickname: String, password: String) {
        service.getMemberSignin(nickname: nickname, password: password) { [weak self] result in
            guard result else {
                self?.isSigned.onNext(result)
                return
            }
            self?.getMemberInfo(nickname: nickname, password: password) { complete in
                self?.isSigned.onNext(complete)
            }
        }
    }
    
    private func getMemberInfo(nickname: String, password: String, completion: @escaping(Bool)->Void) {
        service.getMemberInfo(nickname: nickname, password: password) { memberDTO in
            if (nickname == memberDTO.nickname) && (password == memberDTO.password) {
                UserDefaults.standard.set(memberDTO.nickname, forKey: UserDefaultsForkey.nickname.rawValue)
                UserDefaults.standard.set(memberDTO.password, forKey: UserDefaultsForkey.password.rawValue)
                UserDefaults.standard.set(memberDTO.email, forKey: UserDefaultsForkey.email.rawValue)
                UserDefaults.standard.set(memberDTO.userID, forKey: UserDefaultsForkey.userID.rawValue)
                UserDefaults.standard.set(memberDTO.profile, forKey: UserDefaultsForkey.profile.rawValue)
                if (memberDTO.favorite?.isEmpty) != nil { UserDefaults.standard.set(memberDTO.favorite, forKey: UserDefaultsForkey.favorite.rawValue) }
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func updateMemberFcmToken(_ fcmToken: String? = nil) {
        UNUserNotificationCenter.current().getNotificationSettings {[weak self] settings in
            switch settings.authorizationStatus {
            case .authorized:
                let userID = UserDefaults.standard.integer(forKey: UserDefaultsForkey.userID.rawValue)
                if let fcmToken = fcmToken {
                    UserDefaults.standard.set(fcmToken, forKey: UserDefaultsForkey.fcmToken.rawValue)
                    let fcmTokenInformation = FcmTokenInformation(userID: userID, fcmToken: fcmToken)
                    self?.service.updateMemberFcmToken(with: fcmTokenInformation) { _ in }
                } else {
                    Messaging.messaging().token { messagingFcmToken, _ in
                        guard let fcmToken = messagingFcmToken else { return }
                        let fcmTokenInformation = FcmTokenInformation(userID: userID, fcmToken: fcmToken)
                        self?.service.updateMemberFcmToken(with: fcmTokenInformation) { result in
                            guard result else { return }
                            UserDefaults.standard.set(fcmToken, forKey: UserDefaultsForkey.fcmToken.rawValue)
                        }
                    }
                }
            default: return
            }
        }
    }
}
