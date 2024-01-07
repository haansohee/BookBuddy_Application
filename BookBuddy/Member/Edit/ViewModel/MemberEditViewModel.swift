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
    private(set) var memberUpdateInformation: MemberUpdateInformation?
    
    func setMemberUpdateInformation(_ memberProfileInformation: MemberUpdateInformation) {
        self.memberUpdateInformation = memberProfileInformation
    }
    
    func updateMemberInformation(_ memberProfileInformation: MemberUpdateInformation) {
        service.updateMemberProfile(with: memberProfileInformation) { [weak self] isProfileUpdated in
            self?.isProfileUpdated.onNext(isProfileUpdated)
        }
    }
}
