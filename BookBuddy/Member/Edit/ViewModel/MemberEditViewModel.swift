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
    private(set) var memberUpdateInformation: MemberUpdateInformation?
    
    func setMemberUpdateInformation(_ memberProfileInformation: MemberUpdateInformation) {
        self.memberUpdateInformation = memberProfileInformation
    }
    
    func updateMemberInformation(_ memberProfileInformation: MemberUpdateInformation) {
        service.updateMemberProfile(with: memberProfileInformation) { [weak self] isProfileUpdated in
            self?.isProfileUpdated.onNext(isProfileUpdated)
        }
    }
    
    func udpateMemberNickname(_ memberNicknameInformation: MemberNicknameUpdateInformation) {
        service.updateMemberNickname(with: memberNicknameInformation) { [weak self] isNicknameUpdated in
            self?.isNicknameUpdated.onNext(isNicknameUpdated)
        }
    }
    
    func deleteMemberProfile(_ nickname: String) {
        service.deleteMemberProfile(with: nickname) { [weak self] isProfileDeleted in
            self?.isProfileDeleted.onNext(isProfileDeleted)
        }
    }
}
