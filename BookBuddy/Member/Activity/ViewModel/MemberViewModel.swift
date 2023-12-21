//
//  MemberViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 12/14/23.
//

import Foundation

final class MemberViewModel {
    private(set) var memberInformation: SignupMemberInformation?
    private(set) var appleMemberInformation: SigninWithAppleInformation?
    
    func setMemberInformation(_ memberInformation: SignupMemberInformation) {
        self.memberInformation = memberInformation
    }
    
    func setAppleMemberInformation(_ appleMemberInformation: SigninWithAppleInformation) {
        self.appleMemberInformation = appleMemberInformation
    }
}
