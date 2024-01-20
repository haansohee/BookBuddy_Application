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
    private let urlSessionMethod = URLSessionMethod()
    
    func getNicknameCheck(nickname: String, completion: @escaping((String)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getNicknameCheck?nickname=\(nickname)") else { return }
        urlSessionMethod.urlGetMethod(url: url, requestDTO: SigninMemberDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.nickname)

            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getEmailCheck(email: String, completion: @escaping((String)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getEmailCheck?email=\(email)") else { return }
        urlSessionMethod.urlGetMethod(url: url, requestDTO: MemberDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.email)
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getMemberInfo(nickname: String, password: String, completion: @escaping((MemberDTO)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getMemberInfo?nickname=\(nickname)&password=\(password)") else { return }
        urlSessionMethod.urlGetMethod(url: url, requestDTO: MemberDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO)
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getAppleMemberInfo(email: String, completion: @escaping((MemberAppleTokenDTO)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getAppleMemberInfo?email=\(email)") else { return }
        urlSessionMethod.urlGetMethod(url: url, requestDTO: MemberAppleTokenDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO)
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getSearchMemberInfo(nickname: String, completion: @escaping((SearchMemberInformation)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getSearchMemberInfo?nickname=\(nickname)") else { return }
        urlSessionMethod.urlGetMethod(url: url, requestDTO: SearchMemberDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.toDomain())
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func setAppleMemberInfo(with signinWithAppleInformation: SigninWithAppleInformation, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/setAppleMemberInfo/") else { return }
        let member = signinWithAppleInformation.toRequestDTO()
        urlSessionMethod.urlPostMethod(url: url, encodeValue: member) { result in
            completion(result)
        }
    }
    
    func setMemberInfo(with signupMemberInformation: SignupMemberInformation, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/setMemberInfo/") else { return }
        let member = signupMemberInformation.toRequestDTO()
        urlSessionMethod.urlPostMethod(url: url, encodeValue: member) { result in
            completion(result)
        }
    }
    
    func updateFavoriteBook(with favotireBookInformation: FavoriteBookInformation, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/updateFavoriteBook/") else { return }
        let favorite = favotireBookInformation.toRequestDTO()
        urlSessionMethod.urlPostMethod(url: url, encodeValue: favorite) { result in
            completion(result)
        }
    }
    
    func updateMemberProfile(with memberProfileInformation: MemberUpdateInformation, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/updateMemberProfile/") else { return }
        let memberProfile = memberProfileInformation.toRequestDTO()
        urlSessionMethod.urlPostMethod(url: url, encodeValue: memberProfile) { result in
            completion(result)
        }
    }
    
    func updateMemberNickname(with memberNicknameInformation: MemberNicknameUpdateInformation, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/updateMemberNickname/") else { return }
        let memberNickname = memberNicknameInformation.toRequestDTO()
        urlSessionMethod.urlPostMethod(url: url, encodeValue: memberNickname) { result in
            completion(result)
        }
    }
    
    func deleteMemberProfile(with nickname: String, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/deleteMemberProfile/") else { return }
        urlSessionMethod.urlPostMethod(url: url, encodeValue: nickname) { result in
            completion(result)
        }
    }
}
