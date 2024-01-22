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
    private let networkSessionManager = NetworkSessionManager()
    
    func setFollowingList(followingInformation: FollowingInformation, completion: @escaping(Bool) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/setFollowingList/") else { return }
        let followingInformation = followingInformation.toRequestDTO()
        networkSessionManager.urlPostMethod(url: url, encodeValue: followingInformation) { result in
            completion(result)
        }
    }
    
    func deleteFollowing(followingInformation: FollowingInformation, completion: @escaping(Bool) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/deleteFollowing/") else { return }
        let followingInformation = followingInformation.toRequestDTO()
        networkSessionManager.urlPostMethod(url: url, encodeValue: followingInformation) { result in
            completion(result)
        }
    }
    
    func getFollowingList(userID: Int, completion: @escaping(([FollowingListInformation])) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getFollowingList?userID=\(userID)") else { return }
        networkSessionManager.urlGetMethod(url: url, requestDTO: [FollowingListDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let followingListInformations = responseDTO.map { $0.toDomain() }
                completion(followingListInformations)
            case .failure(let error):
                print("ERORR: \(error)")
            }
        }
    }
    
    func getFollowerList(userID: Int, completion: @escaping(([FollowerListInformation])) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getFollowerList?userID=\(userID)") else { return }
        
        networkSessionManager.urlGetMethod(url: url, requestDTO: [FollowerListDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let followerListInformation = responseDTO.map { $0.toDomain() }
                completion(followerListInformation)
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
}
