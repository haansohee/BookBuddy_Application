//
//  BoardWrittenDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 12/22/23.
//

import Foundation

struct BoardWrittenDTO: Codable {
    let postID: Int
    let nickname: String
    let writeDate: String
    let contentTitle: String
    let content: String
    let likes: Int
}

extension BoardWrittenDTO {
    func toDomain() -> BoardWrittenInformation {
        return .init(postID: postID, nickname: nickname,  writeDate: writeDate, contentTitle: contentTitle, content: content, likes: likes)
    }
}
