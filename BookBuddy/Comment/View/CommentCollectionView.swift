//
//  CommentView.swift
//  BookBuddy
//
//  Created by 한소희 on 1/25/24.
//

import UIKit

final class CommentCollectionView: UICollectionView {
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.0
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width) - 10, height: 120.0)
        return layout
    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        self.register(CommentCollectionViewCell.self, forCellWithReuseIdentifier: CommentCollectionViewCell.reuseIdentifier)
        self.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.backgroundColor = .systemBackground
        self.isPagingEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
