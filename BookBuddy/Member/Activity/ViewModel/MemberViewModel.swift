//
//  MemberViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 12/14/23.
//

import Foundation
import RxSwift

final class MemberViewModel {
    private let boardService = BoardService()
    private let memberService = MemberService()
    private let followService = FollowService()
    private(set) var boardWrittenInformations: [BoardWrittenInformation]?
    private(set) var followingListInformations: [FollowingListInformation]?
    private(set) var followerListInformations: [FollowerListInformation]?
    private(set) var isLoadedBoardWrittenInfo = PublishSubject<Bool>()
    private(set) var isLoadedFollowingListInfo = PublishSubject<Bool>()
    private(set) var isLoadedFollowerListInfo = PublishSubject<Bool>()
    private(set) var memberInformation: MemberInformation?
    
    func loadMemberInformation() {
        let userID = UserDefaults.standard.integer(forKey: UserDefaultsForkey.userID.rawValue)
        let profile = UserDefaults.standard.data(forKey: UserDefaultsForkey.profile.rawValue)
        let favorite = UserDefaults.standard.string(forKey: UserDefaultsForkey.favorite.rawValue)
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaultsForkey.nickname.rawValue),
              let email = UserDefaults.standard.string(forKey: UserDefaultsForkey.email.rawValue) else { return }
        if let appleToken = UserDefaults.standard.string(forKey: UserDefaultsForkey.appleToken.rawValue) {
            memberInformation = MemberInformation(userID: userID, email: email, appleToken: appleToken, nickname: nickname, favorite: favorite, profile: profile)
        } else {
            guard let password = UserDefaults.standard.string(forKey: UserDefaultsForkey.password.rawValue) else { return }
            memberInformation = MemberInformation(userID: userID, email: email, password: password, nickname: nickname, favorite: favorite, profile: profile)
        }
    }
    
    func getMemberBoardInformaion(nickname: String) {
        boardService.getMemberBoards(nickname: nickname) { [weak self] result in
            self?.boardWrittenInformations = result
            self?.isLoadedBoardWrittenInfo.onNext(true)
        }
    }  
    
    func getFollowingListInformation(userID: Int) {
        followService.getFollowingList(userID: userID) { [weak self] results in
            self?.followingListInformations = results
            self?.isLoadedFollowingListInfo.onNext(true)
        }
    }
    
    func getFollowerListInformation(userID: Int) {
        followService.getFollowerList(userID: userID) { [weak self] results in
            self?.followerListInformations = results
            self?.isLoadedFollowerListInfo.onNext(true)
        }
    }
}
