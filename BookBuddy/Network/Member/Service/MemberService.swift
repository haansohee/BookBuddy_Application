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
    private let postMethod: HTTPMethod = .POST
    private let getMethod: HTTPMethod = .GET
    
    func getNicknameCheck(nickname: String, completion: @escaping((String)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getNicknameCheck?nickname=\(nickname)") else { return }
        urlGetMethod(url: url, requestDTO: SigninMemberDTO.self) { result in
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
        urlGetMethod(url: url, requestDTO: MemberDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.email)
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getMemberInfo(nickname: String, password: String, completion: @escaping((MemberDTO)) -> Void) {
        print("nickname: \(nickname), password: \(password)")
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getMemberInfo?nickname=\(nickname)&password=\(password)") else { return }
        urlGetMethod(url: url, requestDTO: MemberDTO.self) { result in
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
        urlGetMethod(url: url, requestDTO: MemberAppleTokenDTO.self) { result in
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
        urlGetMethod(url: url, requestDTO: SearchMemberDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.toDomain())
                
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    private func urlGetMethod<T: Codable>(url: URL, requestDTO: T.Type, completion: @escaping(Result<T, Error>)->Void) {
        var request = URLRequest(url: url)
        request.httpMethod = getMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            switch response.statusCode {
            case 200..<300:
                guard let data = data,
                      let json = try? JSONDecoder().decode(requestDTO.self, from: data) else { return }
                completion(.success(json))
                return
                
            default:
                print("ERROR: \(String(describing: error?.localizedDescription))")
                return
            }
        }
        task.resume()
    }
    
    func setAppleMemberInfo(with signinWithAppleInformation: SigninWithAppleInformation, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/setAppleMemberInfo/") else { return }
        let member = signinWithAppleInformation.toRequestDTO()
        urlPostMethod(url: url, encodeValue: member) { result in
            completion(result)
        }
    }
    
    func setMemberInfo(with signupMemberInformation: SignupMemberInformation, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/setMemberInfo/") else { return }
        let member = signupMemberInformation.toRequestDTO()
        urlPostMethod(url: url, encodeValue: member) { result in
            completion(result)
        }
    }
    
    func updateFavoriteBook(with favotireBookInformation: FavoriteBookInformation, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/updateFavoriteBook/") else { return }
        let favorite = favotireBookInformation.toRequestDTO()
        urlPostMethod(url: url, encodeValue: favorite) { result in
            completion(result)
        }
    }
    
    func updateMemberProfile(with memberProfileInformation: MemberUpdateInformation, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/updateMemberProfile/") else { return }
        let memberProfile = memberProfileInformation.toRequestDTO()
        urlPostMethod(url: url, encodeValue: memberProfile) { result in
            completion(result)
        }
    }
    
    func updateMemberNickname(with memberNicknameInformation: MemberNicknameUpdateInformation, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/updateMemberNickname/") else { return }
        let memberNickname = memberNicknameInformation.toRequestDTO()
        urlPostMethod(url: url, encodeValue: memberNickname) { result in
            completion(result)
        }
    }
    
    func deleteMemberProfile(with nickname: String, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/deleteMemberProfile/") else { return }
        urlPostMethod(url: url, encodeValue: nickname) { result in
            completion(result)
        }
    }
    
    private func urlPostMethod<T: Codable>(url: URL, encodeValue: T, completion: @escaping(Bool)->Void) {
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        request.httpMethod = postMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(encodeValue)
        } catch {
            print("ERROR: Encoding Reuqest Data: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("ERROR: \(error)")
                return
            }
            if let data = data {
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    completion(true)
                    return
                    
                } catch {
                    print("ERROR Decoding Response Data: \(error)")
                    completion(false)
                    return
                }
            }
        }
        task.resume()
    }
}
