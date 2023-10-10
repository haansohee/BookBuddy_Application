//
//  BookSearchDTO.swift
//  BookBuddy
//
//  Created by 한소희 on 10/9/23.
//

import Foundation

struct BookSearch: Decodable {
    let items: [BookSearchContents]
}

struct BookSearchContents: Decodable {
    let title: String
    let link: String
    let image: String
    let author: String
}
