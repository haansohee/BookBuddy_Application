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
                UserDefaults.standard.set(memberDTO.nickname, forKey: UserDefaultsForkey.nickname.rawValue)
                UserDefaults.standard.set(memberDTO.password, forKey: UserDefaultsForkey.password.rawValue)
                UserDefaults.standard.set(memberDTO.email, forKey: UserDefaultsForkey.email.rawValue)
                UserDefaults.standard.set(memberDTO.userID, forKey: UserDefaultsForkey.userID.rawValue)
                UserDefaults.standard.set(memberDTO.profile, forKey: UserDefaultsForkey.profile.rawValue)
                if (memberDTO.favorite?.isEmpty) != nil { UserDefaults.standard.set(memberDTO.favorite, forKey: UserDefaultsForkey.favorite.rawValue) }
                self?.isSigned.onNext(true)
            } else {
                self?.isSigned.onNext(false)
            }
        }
    }
}
