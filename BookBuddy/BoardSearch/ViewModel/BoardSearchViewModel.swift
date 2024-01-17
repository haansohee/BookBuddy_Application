//
//  BoardSearchViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 1/10/24.
//

import Foundation
import RxSwift

final class BoardSearchViewModel {
    private let boardService = BoardService()
    private let memberService = MemberService()
    private let followService = FollowService()
    private(set) var isLoadedBoardSearchResults = PublishSubject<Bool>()
    private(set) var isLoadedSearchMember = PublishSubject<Bool>()
    private(set) var isUpdatedFollow = PublishSubject<Bool>()
    private(set) var isDeletedFollow = PublishSubject<Bool>()
    private(set) var isCheckedFollowed = PublishSubject<Bool>()
    private(set) var boardSearchResultsInformations: [BoardSearchResultsInformation]?
    private(set) var searchWords: [String] = []
    private(set) var searchMemberInformation: SearchMemberInformation?
    
    func getBoardSearchResultsInformation(searchWord: String) {
        boardService.getSearchBoards(searchWord: searchWord) { [weak self] results in
            self?.boardSearchResultsInformations = results
            self?.isLoadedBoardSearchResults.onNext(true)
        }
    }
    
    func setRecentSearchWord(_ searchWord: String) {
        guard let searchWordList = UserDefaults.standard.array(forKey: "recentSearch") as? [String] else {
            searchWords.append(searchWord)
            UserDefaults.standard.set(self.searchWords, forKey: "recentSearch")
            return
        }
        searchWords = searchWordList
        if searchWords.count >= 20 {
            searchWords.removeLast()
        }
        searchWords.insert(searchWord, at: 0)
        UserDefaults.standard.set(searchWords, forKey: "recentSearch")
    }
    
    func deleteRecentSearchWord(_ index: Int) {
        guard let searchWordList = UserDefaults.standard.array(forKey: "recentSearch") as? [String] else { return }
        searchWords = searchWordList
        searchWords.remove(at: index)
        UserDefaults.standard.set(searchWords, forKey: "recentSearch")
    }
    
    func deleteAllRecentSearchWord() {
        UserDefaults.standard.removeObject(forKey: "recentSearch")
    }
    
    func getBoardSearchMemberInformation(_ nickname: String) {
        memberService.getSearchMemberInfo(nickname: nickname) { [weak self] result in
            self?.searchMemberInformation = result
            self?.isLoadedSearchMember.onNext(true)
        }
    }
    
    func following(followingInformation: FollowingInformation) {
        followService.setFollowingList(followingInformation: followingInformation) { [weak self] result in
            self?.isUpdatedFollow.onNext(result)
        }
    }
    
    func deleteFollowing(followingInformation: FollowingInformation) {
        followService.deleteFollowing(followingInformation: followingInformation) { [weak self] result in
            self?.isDeletedFollow.onNext(result)
        }
    }
    
    func checkFollowed(userID: Int, searchUserID: Int) {
        followService.getFollowingList(userID: userID) { [weak self] result in
            var isFound = false
            result.forEach {
                if searchUserID == $0.userID {
                    isFound = true
                    self?.isCheckedFollowed.onNext(isFound)
                    return
                }
            }
            if !isFound {
                self?.isCheckedFollowed.onNext(isFound)
            }
        }
    }
}
