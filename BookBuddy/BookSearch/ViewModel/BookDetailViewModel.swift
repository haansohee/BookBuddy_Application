//
//  BookDetailViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 12/15/23.
//

import Foundation
import RxSwift

final class BookDetailViewModel {
    let isSetFavorite = PublishSubject<Bool>()
    let isUnsetFavorite = PublishSubject<Bool>()
    private let service = MemberService()
    private let nickname = UserDefaults.standard.string(forKey: UserDefaultsForkey.nickname.rawValue)
    
    func checkIsSetFavorite(bookTitle: String) -> Bool {
        guard let favoriteBook = UserDefaults.standard.string(forKey: UserDefaultsForkey.favorite.rawValue) else { return false }
        guard favoriteBook == bookTitle else { return false }
        return true
    }
    
    func settingFavoriteBook(bookTitle: String) {
        guard let nickname = nickname else { return }
        let favoriteBookInformation = FavoriteBookInformation(nickname: nickname, favorite: bookTitle)
        service.updateFavoriteBook(with: favoriteBookInformation) { [weak self] isSetFavorite in
            guard isSetFavorite else { return }
            UserDefaults.standard.set(favoriteBookInformation.favorite, forKey: UserDefaultsForkey.favorite.rawValue)
            self?.isSetFavorite.onNext(isSetFavorite)
        }
    }
    
    func unsetFavoriteBook() {
        guard let nickname = nickname else { return }
        let favoriteBookInformation = FavoriteBookInformation(nickname: nickname, favorite: nil)
        service.updateFavoriteBook(with: favoriteBookInformation) { [weak self] isUnsetFavorite in
            guard isUnsetFavorite else { return }
            UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.favorite.rawValue)
            self?.isUnsetFavorite.onNext(isUnsetFavorite)
        }
    }
}
