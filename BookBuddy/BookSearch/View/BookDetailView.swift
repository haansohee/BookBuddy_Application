//
//  BookDetailView.swift
//  BookBuddy
//
//  Created by 한소희 on 10/20/23.
//

import UIKit

final class BookDetailView: UIView {
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        
        return imageView
    }()
    
    let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        label.text = "로딩 중..."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .label
        
        return label
    }()
    
    private let bookAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        label.text = "로딩 중..."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .lightGray
        
        return label
    }()
    
    private let bookCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        label.text = "로딩 중..."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .lightGray
        
        return label
    }()
    
    private let bookDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        label.text = "로딩 중..."
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .light)
        
        return label
    }()
    
    let likeButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        
        return button
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "cart.fill"), for: .normal)
        button.tintColor = .systemBlue
        
        return button
    }()
    func setBookInformation(_ information: BookInformation) {
        let image = UIImage(data: information.image)
        
        DispatchQueue.main.async {
            self.bookTitleLabel.text = information.title
            self.bookAuthorLabel.text = information.author
            self.bookCategoryLabel.text = information.category
            self.bookDescriptionLabel.text = information.description
            self.bookImageView.image = image
        }
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

extension BookDetailView {
    private func addSubviews() {
        [
            bookImageView,
            bookTitleLabel,
            bookAuthorLabel,
            bookCategoryLabel,
            bookDescriptionLabel,
            likeButton,
            buyButton
        ].forEach { self.addSubview($0)}
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60.0),
            bookImageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            bookImageView.widthAnchor.constraint(equalToConstant: 180.0),
            bookImageView.heightAnchor.constraint(equalToConstant: 240.0),
            
            likeButton.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 8.0),
            likeButton.bottomAnchor.constraint(equalTo: bookImageView.bottomAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40.0),
            likeButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            buyButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 6.0),
            buyButton.bottomAnchor.constraint(equalTo: bookImageView.bottomAnchor),
            buyButton.widthAnchor.constraint(equalToConstant: 40.0),
            buyButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            bookTitleLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 6.0),
            bookTitleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 14.0),
            bookTitleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -14.0),
            bookTitleLabel.heightAnchor.constraint(equalToConstant: 80.0),
            
            bookAuthorLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 6.0),
            bookAuthorLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 14.0),
            bookAuthorLabel.widthAnchor.constraint(equalToConstant: 200.0),
            bookAuthorLabel.heightAnchor.constraint(equalToConstant: 50.0),
            bookAuthorLabel.bottomAnchor.constraint(equalTo: bookCategoryLabel.bottomAnchor),
        
            bookCategoryLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 6.0),
            bookCategoryLabel.leadingAnchor.constraint(equalTo: bookAuthorLabel.trailingAnchor, constant: 10.0),
            bookCategoryLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -14.0),
            bookCategoryLabel.heightAnchor.constraint(equalToConstant: 50.0),
            
            bookDescriptionLabel.topAnchor.constraint(equalTo: bookAuthorLabel.bottomAnchor, constant: 14.0),
            bookDescriptionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            bookDescriptionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            bookDescriptionLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -24.0)
        ])
        
    }
}
