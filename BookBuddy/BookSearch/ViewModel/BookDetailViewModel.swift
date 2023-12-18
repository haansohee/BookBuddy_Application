//
//  BookDetailViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 12/15/23.
//

import Foundation
import RxSwift

final class BookDetailViewModel {
    private(set) var isSetFavorite = PublishSubject<Bool>()
    private let service = MemberService()
    
    func settingFavoriteBook(bookTitle: String) {
        guard let nickname = UserDefaults.standard.string(forKey: "nickname") else {
            isSetFavorite.onNext(false)
            return
        }
        let favoriteBookInformation = FavoriteBookInformation(nickname: nickname, favorite: bookTitle)
        service.updateFavoriteBook(with: favoriteBookInformation) { [weak self] isSetFavorite in
            guard isSetFavorite else {
                self?.isSetFavorite.onNext(false)
                return
            }
            UserDefaults.standard.set(bookTitle, forKey: "favorite")
            self?.isSetFavorite.onNext(true)
        }
    }
}
