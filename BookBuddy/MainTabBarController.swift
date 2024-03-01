//
//  MainTabBarController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/6/23.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .systemGreen
        self.tabBar.backgroundColor = .systemBackground
        let bookSeachTab = UINavigationController(rootViewController: BookSearchViewContoller())
        bookSeachTab.tabBarItem = UITabBarItem(title: "책 검색하기", image: UIImage(systemName: "book"), tag: 0)
        
        let boardSearchTab = UINavigationController(rootViewController: BoardSearchViewController())
        boardSearchTab.tabBarItem = UITabBarItem(title: "둘러보기", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let homeTab = UINavigationController(rootViewController: HomeViewController())
        homeTab.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 2)
        
        let boardWriteTab = UINavigationController(rootViewController: BoardWriteViewController())
        boardWriteTab.tabBarItem = UITabBarItem(title: "글 작성하기", image: UIImage(systemName: "square.and.pencil.circle"), tag: 3)
        
        let memberTab = UINavigationController(rootViewController: MemberViewController())
        memberTab.tabBarItem = UITabBarItem(title: "내 계정", image: UIImage(systemName: "person"), tag: 4)
        
        viewControllers = [
            bookSeachTab,
            boardSearchTab,
            homeTab,
            boardWriteTab,
            memberTab
        ]
        tabBarController?.setViewControllers(viewControllers, animated: true)
    }
}
