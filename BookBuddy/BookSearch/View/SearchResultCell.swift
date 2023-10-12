//
//  SearchResultCell.swift
//  BookBuddy
//
//  Created by 한소희 on 10/5/23.
//

import UIKit

final class SearchResultCell: UICollectionViewCell {
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트 제목"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .label
        
        return label
    }()
    
    private let bookAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "테스트 작가"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .lightGray
        
        return label
    }()
    
    private let bookCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "테스트 장르"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .lightGray
        
        return label
    }()
    
    func setBookTitleLabel(_ title: String) {
        self.bookTitleLabel.text = title
    }
    
    func setBookAuthorLabel(_ author: String) {
        self.bookAuthorLabel.text = author
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultCell {
    private func addSubviews() {
        [
            bookImageView,
            bookTitleLabel,
            bookAuthorLabel,
            bookCategoryLabel
        ].forEach { self.addSubview($0)}
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            bookImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bookImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
            bookImageView.widthAnchor.constraint(equalToConstant: 160.0),
            bookImageView.heightAnchor.constraint(equalToConstant: 220.0),
            
            bookTitleLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 4.0),
            bookTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4.0),
            bookTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4.0),
            bookTitleLabel.heightAnchor.constraint(equalToConstant: 80.0),
            
            bookAuthorLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 2.0),
            bookAuthorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4.0),
            bookAuthorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4.0),
            
            bookCategoryLabel.topAnchor.constraint(equalTo: bookAuthorLabel.bottomAnchor, constant: 2.0),
            bookCategoryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4.0),
            bookCategoryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4.0)
        ])
        
    }
}
