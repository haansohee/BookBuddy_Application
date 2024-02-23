//
//  MemberEditViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 12/28/23.
//

import Foundation
import RxSwift

final class MemberEditViewModel {
    private let service = MemberService()
    private var isProfileUpdated = PublishSubject<Bool>()
    private(set) var isProfileDeleted = PublishSubject<Bool>()
    private(set) var isNicknameUpdated = PublishSubject<Bool>()
    private(set) var isPasswordUpdated = PublishSubject<Bool>()
    private(set) var memberUpdateInformation: MemberUpdateInformation?
    let isSignouted = BehaviorSubject(value: MemberActivityStatus.Signin.rawValue)
    
    func setMemberUpdateInformation(_ memberProfileInformation: MemberUpdateInformation) {
        self.memberUpdateInformation = memberProfileInformation
    }
    
    func updateMemberInformation(_ memberProfileInformation: MemberUpdateInformation) {
        service.updateMemberProfile(with: memberProfileInformation) { [weak self] isProfileUpdated in
            self?.isProfileUpdated.onNext(isProfileUpdated)
        }
    }
    
    func updateMemberNickname(_ memberNicknameInformation: MemberNicknameUpdateInformation) {
        service.updateMemberNickname(with: memberNicknameInformation) { [weak self] isNicknameUpdated in
            self?.isNicknameUpdated.onNext(isNicknameUpdated)
            guard isNicknameUpdated else { return }
            UserDefaults.standard.set(memberNicknameInformation.newNickname, forKey: UserDefaultsForkey.nickname.rawValue)
        }
    }
    
    func updateMemberPassword(_ memberPasswordInformation: MemberPasswordUpdateInformation) {
        service.updateMemberPassword(with: memberPasswordInformation) { [weak self] isPasswordUpdated in
            self?.isPasswordUpdated.onNext(isPasswordUpdated)
            guard isPasswordUpdated else { return }
            UserDefaults.standard.set(memberPasswordInformation.newPassword, forKey: UserDefaultsForkey.password.rawValue)
        }
    }
    
    func deleteMemberProfile(_ nickname: String) {
        service.deleteMemberProfile(with: nickname) { [weak self] isProfileDeleted in
            self?.isProfileDeleted.onNext(isProfileDeleted)
        }
    }
    
    func signout() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.nickname.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.password.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.email.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.profile.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.appleToken.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.favorite.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.userID.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.recentSearch.rawValue)
        isSignouted.onNext(MemberActivityStatus.Signout.rawValue)
    }
}
