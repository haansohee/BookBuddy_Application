//
//  MemberSigninViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 11/17/23.
//

import Foundation
import AuthenticationServices
import RxSwift

final class MemberSigninViewModel {
    private let service = MemberService()
    private(set) var isSigned = PublishSubject<Bool>()
    
    func signin(nickname: String, password: String) {
        service.getMemberInfo(nickname: nickname, password: password) { [weak self] memberDTO in
            if (nickname == memberDTO.nickname) && (password == memberDTO.password) {
                UserDefaults.standard.set(memberDTO.nickname, forKey: "nickname")
                UserDefaults.standard.set(memberDTO.password, forKey: "password")
                UserDefaults.standard.set(memberDTO.email, forKey: "email")
                self?.isSigned.onNext(true)
            } else {
                self?.isSigned.onNext(false)
            }
        }
    }
}
