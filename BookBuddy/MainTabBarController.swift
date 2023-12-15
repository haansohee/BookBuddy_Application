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
        
        let memberTab = UINavigationController(rootViewController: checkMember())
        memberTab.tabBarItem = UITabBarItem(title: "Member", image: UIImage(systemName: "person"), tag: 2)
        
        viewControllers = [
            homeTab,
            bookSeachTab,
            memberTab
        ]
        tabBarController?.setViewControllers(viewControllers, animated: true)
    }
    
    private func checkMember() -> UIViewController {
        guard let nickname = UserDefaults.standard.string(forKey: "nickname"),
              let email = UserDefaults.standard.string(forKey: "email") else { return MemberViewController() }
        
        if let password = UserDefaults.standard.string(forKey: "password") {
            let memberInformation = SignupMemberInformation(nickname: nickname, email: email, password: password)
            return MemberViewController(memberInformation: memberInformation)
        } else if let appleToken = UserDefaults.standard.string(forKey: "appleToken") {
            let appleMemberInformation = SigninWithAppleInformation(nickname: nickname, email: email, appleToken: appleToken)
            return MemberViewController(appleMemberInformation: appleMemberInformation)
        }
        
        return MemberViewController()
    }
}
