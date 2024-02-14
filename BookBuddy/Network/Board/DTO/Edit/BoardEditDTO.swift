//
//  BoardEditDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 2/13/24.
//

import Foundation

struct BoardEditDTO: Codable {
    let postID: Int
    let nickname: String
    let contentTitle: String
    let content: String
    let boardImage: Data
}
