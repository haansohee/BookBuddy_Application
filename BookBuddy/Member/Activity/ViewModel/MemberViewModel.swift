//
//  MemberViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 12/14/23.
//

import Foundation
import RxSwift

final class MemberViewModel {
    private let boardService = BoardService()
    private let memberService = MemberService()
    private(set) var memberInformation: SignupMemberInformation?
    private(set) var appleMemberInformation: SigninWithAppleInformation?
    private(set) var boardWrittenInformations: [BoardWrittenInformation]?
    
    func setMemberInformation(_ memberInformation: SignupMemberInformation) {
        self.memberInformation = memberInformation
    }
    
    func setAppleMemberInformation(_ appleMemberInformation: SigninWithAppleInformation) {
        self.appleMemberInformation = appleMemberInformation
    }
    
    func getMemberBoardInformaion(nickname: String) {
        boardService.getMemberBoards(nickname: nickname) { [weak self] result in
            self?.boardWrittenInformations = result
        }
    }   
}
