//
//  BoardDeleteInformation.swift
//  BookBuddy
//
//  Created by 한소희 on 2/14/24.
//

import Foundation

struct BoardDeleteInformation {
    let postID: Int
}

extension BoardDeleteInformation {
    func toRequestDTO() -> BoardDeleteDTO {
        return .init(postID: postID)
    }
}
