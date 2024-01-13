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
    private(set) var searchWords: [String] = []
    
    func getBoardSearchResultsInformation(searchWord: String) {
        service.getSearchBoards(searchWord: searchWord) { [weak self] results in
            self?.boardSearchResultsInformations = results
            self?.isLoadedBoardSearchResults.onNext(true)
        }
    }
    
    func setRecentSearchWord(_ searchWord: String) {
        if searchWords.isEmpty { return }
        guard let searchWordList = UserDefaults.standard.array(forKey: "recentSearch") as? [String] else {
            searchWords.append(searchWord)
            UserDefaults.standard.set(self.searchWords, forKey: "recentSearch")
            return
        }
        searchWords = searchWordList
        if searchWordList.count >= 20 {
            searchWords.removeLast()
        }
        searchWords.append(searchWord)
        searchWords.reverse()
        UserDefaults.standard.set(searchWords, forKey: "recentSearch")
    }
    
    func deleteRecentSearchWord(_ index: Int) {
        guard let searchWordList = UserDefaults.standard.array(forKey: "recentSearch") as? [String] else { return }
        searchWords = searchWordList
        searchWords.remove(at: index)
        UserDefaults.standard.set(searchWords, forKey: "recentSearch")
    }
}
