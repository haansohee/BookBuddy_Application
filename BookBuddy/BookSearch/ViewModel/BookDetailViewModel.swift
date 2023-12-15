//
//  BookDetailViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 12/15/23.
//

import Foundation
import RxSwift

final class BookDetailViewModel {
    private(set) var isSet = PublishSubject<Bool>()
    private let service = MemberService()
    
    func settingFavoriteBook(bookTitle: String) {
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            let favorite = FavoriteBookInformation(nickname: nickname, favorite: bookTitle)
            service.updateFavoriteBook(with: favorite) { [weak self] isSet in
                if isSet {
                    self?.isSet.onNext(true)
                    UserDefaults.standard.set(bookTitle, forKey: "favorite")
                } else {
                    self?.isSet.onNext(false)
                }
            }
        } else {
            isSet.onNext(false)
        }
    }
}
