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
        
        let boardWriteTab = UINavigationController(rootViewController: checkBoardWriteView())
        boardWriteTab.tabBarItem = UITabBarItem(title: "글 작성하기", image: UIImage(systemName: "square.and.pencil.circle"), tag: 3)
        
        let memberTab = UINavigationController(rootViewController: checkMemberView())
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
    
    private func checkMemberView() -> UIViewController {
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
    
    private func checkBoardWriteView() -> UIViewController {
        guard let nickname = UserDefaults.standard.string(forKey: "nickname") else { return BoardWriteViewController() }
        return BoardWriteViewController(nickname: nickname)
    }
}
