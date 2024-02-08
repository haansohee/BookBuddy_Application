//
//  SearchViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 1/8/24.
//

import Foundation
import UIKit

final class SearchController: UISearchController {
    func setupSearchController() {
        self.searchBar.placeholder = "검색어를 입력하세요."
        self.searchBar.returnKeyType = .done
        self.searchBar.tintColor = .systemGreen
        self.searchBar.setValue("취소", forKey: "cancelButtonText")
        self.hidesNavigationBarDuringPresentation = false
    }
}
