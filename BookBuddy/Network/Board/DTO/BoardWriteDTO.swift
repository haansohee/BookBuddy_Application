//
//  BoardDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 12/20/23.
//

import Foundation

struct BoardWriteDTO: Codable {
    let nickname: String
    let writeDate: String
    let contentTitle: String
    let content: String
    let boardImage: Data
    let profileImage: Data?
}

extension BoardWriteDTO {
    func toDomain() -> BoardWriteInformation {
        return .init(nickname: nickname, writeDate: writeDate, contentTitle: contentTitle, content: content, boardImage: boardImage, profileImage: profileImage)
    }
}
