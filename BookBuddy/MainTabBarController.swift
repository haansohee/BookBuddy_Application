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
        let homeTab = UINavigationController(rootViewController: HomeViewController())
        homeTab.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house"), tag: 0)
        
        let bookSeachTab = UINavigationController(rootViewController: BookSearchViewContoller())
        bookSeachTab.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let memberTab = UINavigationController(rootViewController: MemberLoginViewController())
        memberTab.tabBarItem = UITabBarItem(title: "Member", image: UIImage(systemName: "person"), tag: 2)
        
        viewControllers = [
            homeTab,
            bookSeachTab,
            memberTab
        ]
        
        tabBarController?.setViewControllers(viewControllers, animated: true)
    }
}
