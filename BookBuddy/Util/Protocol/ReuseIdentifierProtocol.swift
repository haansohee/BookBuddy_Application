//
//  ReuseIdentifierProtocol.swift
//  BookBuddy
//
//  Created by 한소희 on 2/21/24.
//

import Foundation

protocol ReuseIdentifierProtocol {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifierProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
