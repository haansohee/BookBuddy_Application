//
//  FavoriteBookInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 12/15/23.
//

import Foundation

struct FavoriteBookInformation {
    let nickname: String
    let favorite: String
}

extension FavoriteBookInformation {
    func toRequestDTO() -> FavoriteBookDTO {
        return .init(favorite: favorite, nickname: nickname)
    }
}
