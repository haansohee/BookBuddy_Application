//
//  HomeViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/6/23.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    private let homeView = HomeView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setLayoutConstraints()
        configureHomeView()
    }
}

extension HomeViewController {
    private func configureHomeView() {
        view.backgroundColor = .systemBackground
        homeView.translatesAutoresizingMaskIntoConstraints = false
        homeView.mainBoardCollectionView.dataSource = self
        homeView.mainBoardCollectionView.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(homeView)
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

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainBoardCollectionViewCell", for: indexPath) as? MainBoardCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20
        let height = collectionView.bounds.height - 60
        
        return CGSize(width: width, height: height)
    }
}
