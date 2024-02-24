//
//  BookDetailView.swift
//  BookBuddy
//
//  Created by 한소희 on 10/20/23.
//

import UIKit
import SkeletonView

final class BookDetailView: UIView {
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowColor = UIColor.label.cgColor
        return imageView
    }()
    
    let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private let bookAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        label.textAlignment = .left
        label.sizeToFit()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGray2
        return label
    }()
    
    private let bookCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        label.textAlignment = .left
        label.sizeToFit()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGray3
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
    private let bookDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    let likeButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    private let linkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        label.text = "책 구경하러 가기  ➡️"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let linkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "link"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    func setBookInformation(_ information: BookInformation) {
        let image = UIImage(data: information.image)
        
        DispatchQueue.main.async {
            self.bookTitleLabel.text = information.title
            self.bookAuthorLabel.text = "\(information.author) | "
            self.bookCategoryLabel.text = information.category
            self.bookDescriptionLabel.text = information.description
            self.bookImageView.image = image
        }
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

extension BookDetailView {
    private func addSubviews() {
        scrollView.addSubview(bookDescriptionLabel)
        [
            bookImageView,
            bookTitleLabel,
            bookAuthorLabel,
            bookCategoryLabel,
            scrollView,
            likeButton,
            linkLabel,
            linkButton
        ].forEach { self.addSubview($0)}
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30.0),
            bookImageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            bookImageView.widthAnchor.constraint(equalToConstant: 180.0),
            bookImageView.heightAnchor.constraint(equalToConstant: 240.0),
            
            likeButton.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 8.0),
            likeButton.bottomAnchor.constraint(equalTo: bookImageView.bottomAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 44.0),
            likeButton.heightAnchor.constraint(equalToConstant: 44.0),
            
//            linkButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 6.0),
//            linkButton.bottomAnchor.constraint(equalTo: bookImageView.bottomAnchor),
//            linkButton.widthAnchor.constraint(equalToConstant: 40.0),
//            linkButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            bookTitleLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 6.0),
            bookTitleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 14.0),
            bookTitleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -14.0),
            bookTitleLabel.heightAnchor.constraint(equalToConstant: 80.0),
            
            linkLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 6.0),
            linkLabel.leadingAnchor.constraint(equalTo: bookImageView.leadingAnchor),
            linkLabel.widthAnchor.constraint(equalToConstant: 120.0),
            linkLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            linkButton.centerYAnchor.constraint(equalTo: linkLabel.centerYAnchor),
            linkButton.trailingAnchor.constraint(equalTo: bookImageView.trailingAnchor),
            linkButton.heightAnchor.constraint(equalToConstant: 24.0),
            linkButton.widthAnchor.constraint(equalTo: linkButton.heightAnchor),
            
            bookAuthorLabel.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 6.0),
            bookAuthorLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 14.0),
            bookAuthorLabel.heightAnchor.constraint(equalToConstant: 50.0),
        
            bookCategoryLabel.topAnchor.constraint(equalTo: bookAuthorLabel.topAnchor),
            bookCategoryLabel.leadingAnchor.constraint(equalTo: bookAuthorLabel.trailingAnchor, constant: 5.0),
            bookCategoryLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -14.0),
            bookCategoryLabel.heightAnchor.constraint(equalToConstant: 50.0),
            
            scrollView.topAnchor.constraint(equalTo: bookAuthorLabel.bottomAnchor, constant: 14.0),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 14.0),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -14.0),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -14.0),
            
            bookDescriptionLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            bookDescriptionLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            bookDescriptionLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            bookDescriptionLabel.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            bookDescriptionLabel.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
    }
}
