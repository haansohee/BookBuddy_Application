//
//  MemberSignupWithEmailViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 11/8/23.
//

import Foundation
import RxSwift
import SwiftSMTP

final class MemberSignupWithEmailViewModel {
    private(set) var isChecked = PublishSubject<Bool>()
    private(set) var isCompleted = PublishSubject<Bool>()
    private(set) var isAuthed = PublishSubject<Bool>()
    private(set) var isCompared = PublishSubject<Bool>()
    private(set) var isDone: Bool = false
    private let service = MemberService()
    private var code = ""
    
    func nicknameDuplicateCheck(nickname: String) {
        service.getNicknameCheck(nickname: nickname) { [weak self] getNickname in
            print("nickname: \(nickname)")
            if nickname != getNickname {
                self?.isDone = true
                self?.isChecked.onNext(true)
            } else {
                self?.isDone = false
                self?.isChecked.onNext(false)
            }
        }
    }
    
    func emailDuplicateCheck(email: String, address: String) {
        let memberEmail = "\(email)@\(address)"
        service.getEmailCheck(email: memberEmail) { [weak self] getEmail in
            if memberEmail != getEmail {
                self?.emailAuthentication(email: memberEmail)
            } else {
                self?.isDone = false
                self?.isAuthed.onNext(false)
            }
        }
    }
    
    private func emailAuthentication(email: String) {
        createAuthCode()
        guard let bookbuddyEmail = Bundle.main.infoDictionary?["BookBuddy_Email"] as? String,
              let bookbuddyPassword = Bundle.main.infoDictionary?["BookBuddy_Password"] as? String else { return }
        let smtp = SMTP(hostname: "smtp.gmail.com",
                        email: bookbuddyEmail,
                        password: bookbuddyPassword)
        let mail_from = Mail.User(name: "BookBuddy", email: bookbuddyEmail)
        let mail_to = Mail.User(name: email, email: email)
        let content = "안녕하세요! BookBuddy입니다. \n 인증코드: \(self.code) \n 회원가입을 이어서 진행해 주세요."
        
        let mail = Mail(from: mail_from, to: [mail_to], subject: "BookBuddy 인증코드입니다.", text: content)
        
        DispatchQueue.global().async {
            smtp.send(mail) { [weak self] error in
                if let error = error {
                    print("ERROR: \(error)")
                } else {
                    self?.isDone = true
                    self?.isAuthed.onNext(true)
                }
            }
        }
    }
    
    private func createAuthCode() {
        var code = ""
        for _ in 0...5 {
            let random = Int.random(in: 0...9)
            code += String(random)
        }
        self.code = code
    }
    
    func compareCode(inputCode: String) {
        if self.code == inputCode {
            self.isCompared.onNext(true)
            self.isDone = true
        } else {
            self.isCompared.onNext(false)
            self.isDone = false
        }
    }
    
    func passwordIsValid(isDone: Bool) {
        self.isDone = isDone
    }
    
    func signup(with signupMemberInformation: SignupMemberInformation) {
        service.setMemberInfo(with: signupMemberInformation) { [weak self] isCompleted in
            if isCompleted {
                self?.isCompleted.onNext(true)
            } else {
                self?.isCompleted.onNext(false)
            }
        }
    }
}
