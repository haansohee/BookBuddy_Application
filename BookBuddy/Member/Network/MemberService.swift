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
                      let json = try? JSONDecoder().decode(MemberDTO.self, from: data) else { return}
                completion(json.nickname)

                return
            default:
                print("ERROR: \(String(describing: error?.localizedDescription))")
                return
            }
        }
        task.resume()
    }
    
    func getEmailCheck(email: String, completion: @escaping((String)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getEmailCheck?email=\(email)") else { return }
        
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
                      let json = try? JSONDecoder().decode(MemberDTO.self, from: data) else { return}
                completion(json.email)
                
                return
            default:
                print("ERROR: \(String(describing: error?.localizedDescription))")
                return
            }
        }
        task.resume()
    }
    
    func getMemberInfo(nickname: String, password: String, completion: @escaping((MemberDTO)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getMemberInfo?nickname=\(nickname)?password=\(password)") else { return }
        
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
                      let json = try? JSONDecoder().decode(MemberDTO.self, from: data) else { return }
                completion(json)
                return
                
            default:
                print("ERROR: \(String(describing: error?.localizedDescription))")
                return
            }
        }
        task.resume()
    }
    
    func getAppleMemberInfo(email: String, completion: @escaping((MemberAppleTokenDTO)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getAppleMemberInfo?email=\(email)") else { return }
        
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
                      let json = try? JSONDecoder().decode(MemberAppleTokenDTO.self, from: data) else { return }
                completion(json)
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
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        let member = MemberAppleTokenDTO(nickname: signinWithAppleInformation.nickname,
                                         email: signinWithAppleInformation.email,
                                         appleToken: signinWithAppleInformation.appleToken)
        
        request.httpMethod = postMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(member)
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
                    if try JSONSerialization.jsonObject(with: data, options: .allowFragments) is MemberAppleTokenDTO {
                    }
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
    
    func setMemberInfo(with signupMemberInformation: SignupMemberInformation, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/setMemberInfo/") else { return }
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        let member = MemberDTO(nickname: signupMemberInformation.nickname, email: signupMemberInformation.email, password: signupMemberInformation.password)
        request.httpMethod = postMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(member)
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
                    if try JSONSerialization.jsonObject(with: data, options: .allowFragments) is MemberDTO {
                    }
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
    
    func updateFavoriteBook(with favotireBookInformation: FavoriteBookInformation, completion: @escaping((Bool)) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/updateFavoriteBook/") else { return }
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        let favorite = FavoriteBookDTO(favorite: favotireBookInformation.favorite, nickname: favotireBookInformation.nickname)
        
        request.httpMethod = postMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(favorite)
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
                    if try JSONSerialization.jsonObject(with: data, options: .allowFragments) is FavoriteBookDTO {
                    }
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
