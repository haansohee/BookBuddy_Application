//
//  RecentSearchViewCell.swift
//  BookBuddy
//
//  Created by 한소희 on 1/11/24.
//

import UIKit

final class RecentSearchViewCell: UICollectionViewCell {
    private let searchWordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    let deleteButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        self.layer.cornerRadius = 2.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.3
        setLayoutContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSearchWordLabel(_ text: String) {
        searchWordLabel.text = text
    }
}

extension RecentSearchViewCell {
    private func addSubviews() {
        [
            searchWordLabel,
            deleteButton
        ].forEach { self.addSubview($0) }
    }
    private func setLayoutContraints() {
        NSLayoutConstraint.activate([
            searchWordLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            searchWordLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            searchWordLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: searchWordLabel.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            deleteButton.bottomAnchor.constraint(equalTo: searchWordLabel.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor)
        ])
    }
}
