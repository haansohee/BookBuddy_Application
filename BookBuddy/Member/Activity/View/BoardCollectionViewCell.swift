//
//  BoardCollectionViewCell.swift
//  BookBuddy
//
//  Created by 한소희 on 10/28/23.
//

import UIKit

final class BoardCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
