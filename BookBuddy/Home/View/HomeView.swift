//
//  HomeView.swift
//  BookBuddy
//
//  Created by 한소희 on 10/6/23.
//

import UIKit

final class HomeView: UIView {
    let mainBoardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        layout.minimumLineSpacing = 5.0
        layout.scrollDirection = .vertical
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MainBoardCollectionViewCell.self, forCellWithReuseIdentifier: "MainBoardCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.backgroundColor = .yellow
        collectionView.isPagingEnabled = false
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView {
    private func addSubviews() {
        [
            mainBoardCollectionView
        ].forEach{ self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            mainBoardCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mainBoardCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            mainBoardCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            mainBoardCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
