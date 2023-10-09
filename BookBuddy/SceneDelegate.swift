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
        self.window?.rootViewController = MainTabBarController()
        self.window?.backgroundColor = .systemBackground
        self.window?.makeKeyAndVisible()
    }

}

