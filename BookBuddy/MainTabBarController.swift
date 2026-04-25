//
//  MainTabBarController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/6/23.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private let memberSigninViewModel = MemberSigninViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setFcmToken()
        updateFcmToken()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setFcmToken() {
        NotificationCenter.default.addObserver(forName: Notification.Name("FCMToken"), object: nil, queue: nil) { [weak self] fcmToken in
            guard let fcmToken = fcmToken.userInfo?.values.first as? String else { return }
            self?.memberSigninViewModel.updateMemberFcmToken(fcmToken)
        }
    }
    
    private func updateFcmToken() {
        memberSigninViewModel.updateMemberFcmToken()
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
