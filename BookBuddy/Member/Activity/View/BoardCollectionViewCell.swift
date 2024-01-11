//
//  BoardCollectionViewCell.swift
//  BookBuddy
//
//  Created by 한소희 on 10/28/23.
//

import UIKit

final class BoardCollectionViewCell: UICollectionViewCell {
    let boardImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.addSubview(boardImage)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension BoardCollectionViewCell {
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            boardImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            boardImage.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            boardImage.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            boardImage.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
