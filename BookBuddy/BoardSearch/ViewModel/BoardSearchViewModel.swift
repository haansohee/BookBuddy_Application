//
//  BoardSearchViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 1/10/24.
//

import Foundation
import RxSwift

final class BoardSearchViewModel {
    private let service = BoardService()
    private(set) var isLoadedBoardSearchResults = PublishSubject<Bool>()
    private(set) var boardSearchResultsInformations: [BoardSearchResultsInformation]?
    private(set) var searchWords: [String]?
    
    func getBoardSearchResultsInformation(searchWord: String) {
        service.getSearchBoards(searchWord: searchWord) { [weak self] results in
            self?.boardSearchResultsInformations = results
            self?.isLoadedBoardSearchResults.onNext(true)
        }
    }
    
    func setRecentSearchWord(_ searchWord: String) {
        if self.searchWords == nil { self.searchWords = [] }
        guard let searchWordList = UserDefaults.standard.array(forKey: "recentSearch") as? [String] else {
            self.searchWords?.append(searchWord)
            UserDefaults.standard.set(self.searchWords, forKey: "recentSearch")
            return
        }
        self.searchWords = searchWordList
        if searchWordList.count >= 20 {
            self.searchWords?.removeLast()
        }
        self.searchWords?.append(searchWord)
        self.searchWords?.reverse()
        UserDefaults.standard.set(self.searchWords, forKey: "recentSearch")
    }
    
    func deleteRecentSearchWord(_ index: Int) {
        guard let searchWordList = UserDefaults.standard.array(forKey: "recentSearch") as? [String] else { return }
        self.searchWords = searchWordList
        self.searchWords?.remove(at: index)
        UserDefaults.standard.set(self.searchWords, forKey: "recentSearch")
    }
}
