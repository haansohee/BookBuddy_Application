//
//  String+.swift
//  BookBuddy
//
//  Created by 한소희 on 12/8/23.
//

import Foundation

extension String {
    func matchRegularExpression(_ pattern: String) -> Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    var isValidNickname: Bool {
        return self.matchRegularExpression("^[a-zA-Z0-9_]{8,16}$")
    }
    
    var isValidPassword: Bool {
        return self.matchRegularExpression("^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}")
    }
}
