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
        let path = "/BookBuddyInfo/setFollowingList/"
        let followingInformation = followingInformation.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: followingInformation) { result in
            completion(result)
        }
    }
    
    func deleteFollowing(followingInformation: FollowingInformation, completion: @escaping(Bool) -> Void) {
        let path = "/BookBuddyInfo/deleteFollowing/"
        let followingInformation = followingInformation.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: followingInformation) { result in
            completion(result)
        }
    }
    
    func getFollowingList(userID: Int, completion: @escaping(([FollowingListInformation])) -> Void) {
        let path = "/BookBuddyInfo/getFollowingList?userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [FollowingListDTO].self) { result in
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
        let path = "/BookBuddyInfo/getFollowerList?userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [FollowerListDTO].self) { result in
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
