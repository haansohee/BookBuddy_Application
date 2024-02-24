//
//  SceneDelegate.swift
//  BookBuddy
//
//  Created by 한소희 on 2023/09/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.backgroundColor = .systemBackground
        self.window?.makeKeyAndVisible()
        guard UserDefaults.standard.string(forKey: UserDefaultsForkey.userID.rawValue) != nil else {
            self.window?.rootViewController = MemberSigninViewController()
            return
        }
        self.window?.rootViewController = MainTabBarController()
    }

    func changeRootViewController(_ viewController: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        window.rootViewController = viewController
        UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
}

