//
//  RecentSearchView.swift
//  BookBuddy
//
//  Created by 한소희 on 1/11/24.
//

import UIKit

final class RecentSearchView: UIView {
    let recentSearchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "최근 검색 기록"
        label.textColor = .systemGray
        label.backgroundColor = .systemBackground
        label.font = .systemFont(ofSize: 13.0, weight: .light)
        label.textAlignment = .left
        return label
    }()
    
    let recentSearchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 3.0
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RecentSearchViewCell.self, forCellWithReuseIdentifier: RecentSearchViewCell.reuseIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        collectionView.backgroundColor = .systemBackground
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

extension RecentSearchView {
    private func addSubviews() {
        [
            recentSearchLabel,
            recentSearchCollectionView
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            recentSearchLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            recentSearchLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            recentSearchLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            recentSearchLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            recentSearchCollectionView.topAnchor.constraint(equalTo: recentSearchLabel.bottomAnchor, constant: 3.0),
            recentSearchCollectionView.leadingAnchor.constraint(equalTo: recentSearchLabel.leadingAnchor),
            recentSearchCollectionView.trailingAnchor.constraint(equalTo: recentSearchLabel.trailingAnchor),
            recentSearchCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
