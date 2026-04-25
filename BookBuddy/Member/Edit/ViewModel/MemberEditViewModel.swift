//
//  MemberEditViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 12/28/23.
//

import Foundation
import RxSwift
import UserNotifications

final class MemberEditViewModel {
    private let service = MemberService()
    let isProfileUpdated = PublishSubject<Bool>()
    let isProfileDeleted = PublishSubject<Bool>()
    let isNicknameUpdated = PublishSubject<Bool>()
    let isPasswordUpdated = PublishSubject<Bool>()
    let isSignouted = BehaviorSubject(value: MemberActivityStatus.Signin.rawValue)
    
    func updateMemberInformation(_ memberProfileInformation: MemberUpdateInformation) {
        service.updateMemberProfile(with: memberProfileInformation) { [weak self] isProfileUpdated in
            guard isProfileUpdated else { return }
            UserDefaults.standard.set(memberProfileInformation.profile, forKey: UserDefaultsForkey.profile.rawValue)
            self?.isProfileUpdated.onNext(isProfileUpdated)
        }
    }
    
    func updateMemberNickname(_ memberNicknameInformation: MemberNicknameUpdateInformation) {
        service.updateMemberNickname(with: memberNicknameInformation) { [weak self] isNicknameUpdated in
            guard isNicknameUpdated else { return }
            self?.isNicknameUpdated.onNext(isNicknameUpdated)
            UserDefaults.standard.set(memberNicknameInformation.newNickname, forKey: UserDefaultsForkey.nickname.rawValue)
        }
    }
    
    func updateMemberPassword(_ memberPasswordInformation: MemberPasswordUpdateInformation) {
        service.updateMemberPassword(with: memberPasswordInformation) { [weak self] isPasswordUpdated in
            guard isPasswordUpdated else { return }
            self?.isPasswordUpdated.onNext(isPasswordUpdated)
            UserDefaults.standard.set(memberPasswordInformation.newPassword, forKey: UserDefaultsForkey.password.rawValue)
        }
    }
    
    func deleteMemberProfile(_ nickname: String) {
        service.deleteMemberProfile(with: nickname) { [weak self] isProfileDeleted in
            guard isProfileDeleted else { return }
            UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.profile.rawValue)
            self?.isProfileDeleted.onNext(isProfileDeleted)
        }
    }
    
    func signout() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .authorized:
                guard let fcmToken = UserDefaults.standard.string(forKey: UserDefaultsForkey.fcmToken.rawValue) else { return }
                let userID = UserDefaults.standard.integer(forKey: UserDefaultsForkey.userID.rawValue)
                let fcmTokenInformation = FcmTokenInformation(userID: userID, fcmToken: fcmToken)
                self?.service.deleteMemberFcmToken(with: fcmTokenInformation) { result in
                    guard result else { return }
                    UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.nickname.rawValue)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.password.rawValue)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.email.rawValue)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.profile.rawValue)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.appleToken.rawValue)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.favorite.rawValue)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.userID.rawValue)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.recentSearch.rawValue)
                    UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.fcmToken.rawValue)
                    self?.isSignouted.onNext(MemberActivityStatus.Signout.rawValue)
                }
            default:
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.nickname.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.password.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.email.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.profile.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.appleToken.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.favorite.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.userID.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.recentSearch.rawValue)
                self?.isSignouted.onNext(MemberActivityStatus.Signout.rawValue)
            }
        }
    }
}
