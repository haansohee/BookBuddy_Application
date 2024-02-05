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
    private(set) var memberInformation: SignupMemberInformation?
    private(set) var appleMemberInformation: SigninWithAppleInformation?
    private(set) var boardWrittenInformations: [BoardWrittenInformation]?
    private(set) var followingListInformations: [FollowingListInformation]?
    private(set) var followerListInformations: [FollowerListInformation]?
    private(set) var isLoadedBoardWrittenInfo = PublishSubject<Bool>()
    private(set) var isLoadedFollowingListInfo = PublishSubject<Bool>()
    private(set) var isLoadedFollowerListInfo = PublishSubject<Bool>()
    private(set) var switchSkeleton = false
    
    func setMemberInformation(_ memberInformation: SignupMemberInformation) {
        self.memberInformation = memberInformation
    }
    
    func setAppleMemberInformation(_ appleMemberInformation: SigninWithAppleInformation) {
        self.appleMemberInformation = appleMemberInformation
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
