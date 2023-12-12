//
//  MemberSigninWithAppleViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 11/24/23.
//

import Foundation
import RxSwift

final class MemberSigninWithAppleViewModel {
    private let service = MemberService()
    private(set) var isExistence = PublishSubject<Bool>()
    private(set) var signupAppleToken: String?
    private(set) var signupAppleEmail: String?
    private(set) var isCompleted = PublishSubject<Bool>()
    private(set) var appleToken: String?
    private(set) var appleEmail: String?
    
    func appleSignin(appleToken: String) {
        service.getMemberAppleToken(appleToken: appleToken) { [weak self] memberAppleTokenDTO in
            if let nickname = memberAppleTokenDTO.nickname {
                let email = memberAppleTokenDTO.email
                let appleToken = memberAppleTokenDTO.appleToken
                UserDefaults.standard.set(appleToken, forKey: "appleToken")
                UserDefaults.standard.set(nickname, forKey: "nickname")
                UserDefaults.standard.set(email, forKey: "email")
                self?.isExistence.onNext(true)
            } else {
                guard let appleToken = memberAppleTokenDTO.appleToken,
                      let email = memberAppleTokenDTO.email else { return }
                
                self?.setAppleEmail(email)
                self?.setAppleToken(appleToken)
                self?.isExistence.onNext(false)  // 닉네임이 없을 경우 첫 로그인 할 당시에 닉네임 설정까지 안한거겠지
            }
        }
    }
    
    func setAppleToken(_ appleToken: String) {
        self.appleToken = appleToken
    }
    
    func setAppleEmail(_ email: String) {
        self.appleEmail = email
    }
    
    func appleSignup(with signinWithAppleInformation: SigninWithAppleInformation) {
        service.setAppleMemberInfo(with: signinWithAppleInformation) { [weak self] isCompleted in
            if isCompleted {
                self?.isCompleted.onNext(true)
            } else {
                self?.isCompleted.onNext(false)
            }
        }
    }
}
