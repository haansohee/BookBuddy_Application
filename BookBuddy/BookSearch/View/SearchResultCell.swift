//
//  SearchResultCell.swift
//  BookBuddy
//
//  Created by 한소희 on 10/5/23.
//

import UIKit
import SkeletonView

final class SearchResultCell: UICollectionViewCell, ReuseIdentifierProtocol { 
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = false
        imageView.image = UIImage(systemName: "books.vertical")
        imageView.backgroundColor = .systemBackground
        imageView.tintColor = .systemGreen
        return imageView
    }()
    
    private let thumbnailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = false
        label.text = "궁금한 책을 검색해 보세요!"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.isSkeletonable = true
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private let bookAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.isSkeletonable = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .lightGray
        
        return label
    }()
    
    private let bookCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.isSkeletonable = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .lightGray
        
        return label
    }() 
    
    func setBookInformation(_ information: BookInformation) {
        let image = UIImage(data: information.image)
        
        DispatchQueue.main.async {
            self.bookTitleLabel.text = information.title
            self.bookAuthorLabel.text = information.author
            self.bookCategoryLabel.text = information.category
            self.bookImageView.image = image
        }
    }
    
    func setIsHiddenOption(_ isSearch: Bool) {
        [
            thumbnailLabel,
            thumbnailImageView
        ].forEach { $0.isHidden = !isSearch}
        
        [
            bookImageView,
            bookTitleLabel,
            bookAuthorLabel,
            bookCategoryLabel
        ].forEach { $0.isHidden = isSearch}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isSkeletonable = true
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
            thumbnailImageView,
            thumbnailLabel,
            bookImageView,
            bookTitleLabel,
            bookAuthorLabel,
            bookCategoryLabel
        ].forEach { self.addSubview($0)}
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            thumbnailLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            thumbnailLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            thumbnailLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            thumbnailLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            thumbnailImageView.topAnchor.constraint(equalTo: thumbnailLabel.bottomAnchor, constant: 24.0),
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            thumbnailImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            thumbnailImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -24.0),
            
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
