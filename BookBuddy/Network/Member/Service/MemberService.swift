//
//  MemberService.swift
//  BookBuddy
//
//  Created by 한소희 on 11/13/23.
//

import Foundation
import RxCocoa
import RxSwift

final class MemberService {
    private let networkSessionManager = NetworkSessionManager()
    
    func getNicknameCheck(nickname: String, completion: @escaping((String)) -> Void) {
        let path = "/BookBuddyInfo/getNicknameCheck?nickname=\(nickname)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: SigninMemberDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.nickname)

            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getEmailCheck(email: String, completion: @escaping((String)) -> Void) {
        let path = "/BookBuddyInfo/getEmailCheck?email=\(email)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: SigninMemberDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.email)
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getMemberSignin(nickname: String, password: String, completion: @escaping(Bool)->Void) {
        let path = "/BookBuddyInfo/getMemberSignin?nickname=\(nickname)&password=\(password)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: Bool.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO)
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getMemberInfo(nickname: String, password: String, completion: @escaping((MemberDTO)) -> Void) {
        let path = "/BookBuddyInfo/getMemberInfo?nickname=\(nickname)&password=\(password)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: MemberDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO)
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getAppleMemberInfo(email: String, completion: @escaping((MemberAppleTokenDTO)) -> Void) {
        let path = "/BookBuddyInfo/getAppleMemberInfo?email=\(email)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: MemberAppleTokenDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO)
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getSearchMemberInfo(nickname: String, completion: @escaping((SearchMemberInformation)) -> Void) {
        let path = "/BookBuddyInfo/getSearchMemberInfo?nickname=\(nickname)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: SearchMemberDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.toDomain())
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func setAppleMemberInfo(with signinWithAppleInformation: SigninWithAppleInformation, completion: @escaping((Bool)) -> Void) {
        let path = "/BookBuddyInfo/setAppleMemberInfo/"
        let member = signinWithAppleInformation.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: member) { result in
            completion(result)
        }
    }
    
    func setMemberInfo(with signupMemberInformation: SignupMemberInformation, completion: @escaping((Bool)) -> Void) {
        let path = "/BookBuddyInfo/setMemberInfo/"
        let member = signupMemberInformation.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: member) { result in
            completion(result)
        }
    }
    
    func updateFavoriteBook(with favotireBookInformation: FavoriteBookInformation, completion: @escaping((Bool)) -> Void) {
        let path = "/BookBuddyInfo/updateFavoriteBook/"
        let favorite = favotireBookInformation.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: favorite) { result in
            completion(result)
        }
    }
    
    func updateMemberProfile(with memberProfileInformation: MemberUpdateInformation, completion: @escaping((Bool)) -> Void) {
        let path = "/BookBuddyInfo/updateMemberProfile/"
        let memberProfile = memberProfileInformation.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: memberProfile) { result in
            completion(result)
        }
    }
    
    func updateMemberNickname(with memberNicknameInformation: MemberNicknameUpdateInformation, completion: @escaping((Bool)) -> Void) {
        let path = "/BookBuddyInfo/updateMemberNickname/"
        let memberNickname = memberNicknameInformation.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: memberNickname) { result in
            completion(result)
        }
    }
    
    func updateMemberPassword(with memberPasswordInformation: MemberPasswordUpdateInformation, completion: @escaping(Bool)->Void) {
        let path = "/BookBuddyInfo/updateMemberPassword/"
        let memberPassword = memberPasswordInformation.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: memberPassword) { result in
            completion(result)
        }
    }
    
    func deleteMemberProfile(with nickname: String, completion: @escaping((Bool)) -> Void) {
        let path = "/BookBuddyInfo/deleteMemberProfile/"
        networkSessionManager.urlPostMethod(path: path, encodeValue: nickname) { result in
            completion(result)
        }
    }
}
