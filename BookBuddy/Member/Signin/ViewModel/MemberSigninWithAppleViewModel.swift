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
    private(set) var isChecked = PublishSubject<Bool>()
    private(set) var isCompleted = PublishSubject<Bool>()
    private(set) var appleToken: String?
    private(set) var appleEmail: String?
    private(set) var appleUserID: Int?
    
    func nicknameDuplicateCheck(nickname: String) {
        service.getNicknameCheck(nickname: nickname) { [weak self] getNickname in
            if nickname != getNickname {
                self?.isChecked.onNext(true)
            } else {
                self?.isChecked.onNext(false)
            }
        }
    }
    
    func appleSignin(appleToken: String) {
        let tokenDecoding = decodeJWT(jwtToken: appleToken)
        guard let email = tokenDecoding["email"] else { return }
        service.getAppleMemberInfo(email: email as! String) { [weak self] memberAppleTokenDTO in
            if let nickname = memberAppleTokenDTO.nickname {
                let email = memberAppleTokenDTO.email
                let appleToken = memberAppleTokenDTO.appleToken
                let userID = memberAppleTokenDTO.userID
                let profile = memberAppleTokenDTO.profile
                UserDefaults.standard.set(appleToken, forKey: UserDefaultsForkey.appleToken.rawValue)
                UserDefaults.standard.set(nickname, forKey: UserDefaultsForkey.nickname.rawValue)
                UserDefaults.standard.set(email, forKey: UserDefaultsForkey.email.rawValue)
                UserDefaults.standard.set(userID, forKey: UserDefaultsForkey.userID.rawValue)
                UserDefaults.standard.set(profile, forKey: UserDefaultsForkey.profile.rawValue)
                if memberAppleTokenDTO.favorite?.isEmpty != nil { UserDefaults.standard.set(memberAppleTokenDTO.favorite, forKey: UserDefaultsForkey.favorite.rawValue)}
                self?.isExistence.onNext(true)
            } else {
                guard let appleToken = memberAppleTokenDTO.appleToken,
                      let email = memberAppleTokenDTO.email,
                      let userID = memberAppleTokenDTO.userID else { return }
                
                self?.setAppleEmail(email)
                self?.setAppleToken(appleToken)
                self?.setUserID(userID)
                self?.isExistence.onNext(false)
            }
        }
    }
    
    private func decodeJWT(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    private func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
              let json = try? JSONSerialization.jsonObject(with: bodyData, options: []),
              let payload = json as? [String: Any] else { return nil }
        return payload
    }
    
    private func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "-", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLegnth = requiredLength - length
        
        if paddingLegnth > 0 {
            let padding = "".padding(toLength: Int(paddingLegnth), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    func setAppleToken(_ appleToken: String) {
        self.appleToken = appleToken
    }
    
    func setAppleEmail(_ email: String) {
        self.appleEmail = email
    }
    
    func setUserID(_ userID: Int) {
        self.appleUserID = userID
    }
    
    func appleSignup(with signinWithAppleInformation: SigninWithAppleInformation) {
        service.setAppleMemberInfo(with: signinWithAppleInformation) { [weak self] isCompleted in
            self?.isCompleted.onNext(isCompleted)
        }
    }
}
