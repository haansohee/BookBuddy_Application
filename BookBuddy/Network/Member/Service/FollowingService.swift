//
//  FollowService.swift
//  BookBuddy
//
//  Created by 한소희 on 1/17/24.
//

import Foundation

final class FollowService {
    private let postMethod: HTTPMethod = .POST
    private let getMethod: HTTPMethod = .GET
    
    func setFollowingList(followingInformation: FollowingInformation, completion: @escaping(Bool) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/setFollowingList/") else { return }
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        let followingInformation = followingInformation.toRequestDTO()
        
        request.httpMethod = postMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(followingInformation)
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
                    if try JSONSerialization.jsonObject(with: data, options: .allowFragments) is FollowingDTO {
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
    
    func deleteFollowing(followingInformation: FollowingInformation, completion: @escaping(Bool) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/deleteFollowing/") else { return }
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        let followingInformation = followingInformation.toRequestDTO()
        
        request.httpMethod = postMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(followingInformation)
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
                    if try JSONSerialization.jsonObject(with: data, options: .allowFragments) is FollowingDTO {
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
    
    func getFollowingList(userID: Int, completion: @escaping(([FollowingListInformation])) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getFollowingList?userID=\(userID)") else { return }
        
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
                      let json = try? JSONDecoder().decode([FollowingListDTO].self, from: data) else { return }
                let followingListInformations = json.map { $0.toDomain() }
                completion(followingListInformations)
                return
                
            default:
                print("ERROR: \(String(describing: error?.localizedDescription))")
                return
            }
        }
        task.resume()
    }
    
    func getFollowerList(userID: Int, completion: @escaping(([FollowerListInformation])) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getFollowerList?userID=\(userID)") else { return }
        
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
                      let json = try? JSONDecoder().decode([FollowerListDTO].self, from: data) else { return }
                let followerListInformations = json.map { $0.toDomain() }
                completion(followerListInformations)
                return
                
            default:
                print("ERROR: \(String(describing: error?.localizedDescription))")
                return
            }
        }
        task.resume()
    }
}
