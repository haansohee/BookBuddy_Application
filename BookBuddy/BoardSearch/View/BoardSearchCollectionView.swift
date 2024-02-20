//
//  BoardSearchCollectionView.swift
//  BookBuddy
//
//  Created by 한소희 on 1/9/24.
//

import UIKit

final class BoardSearchCollectionView: UICollectionView {
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5.0
        layout.scrollDirection = .vertical
        return layout
    }()

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        self.register(BoardSearchViewCell.self, forCellWithReuseIdentifier: BoardSearchViewCell.reuseIdentifier)
        self.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.backgroundColor = .systemBackground
        self.isPagingEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
