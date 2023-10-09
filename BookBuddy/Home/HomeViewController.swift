//
//  HomeViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/6/23.
//

import UIKit

final class HomeViewController: UIViewController {
    private let homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setLayoutConstraints()
    }
}

extension HomeViewController {
    private func addSubviews() {
        view.addSubview(homeView)
        view.backgroundColor = .systemBackground
        homeView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: self.view.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            homeView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            homeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
