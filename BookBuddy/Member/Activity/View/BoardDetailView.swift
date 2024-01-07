//
//  BoardDetailView.swift
//  BookBuddy
//
//  Created by 한소희 on 12/21/23.
//

import UIKit

final class BoardDetailView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let likeButton: AnimationButton = {
        let button = AnimationButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let commentButton: AnimationButton = {
        let button = AnimationButton()
        button.setImage(UIImage(systemName: "bubble"), for: .normal)
        button.tintColor = .systemGray3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 0.5
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 11.0, weight: .light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 0.5
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 11.0, weight: .light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트닉네임"
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 0.5
        label.textColor = .label
        label.font = .systemFont(ofSize: 12.0, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트 글 제목"
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 0.5
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트 글 내용"
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 0.5
        label.textColor = .label
        label.font = .systemFont(ofSize: 13.0, weight: .light)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let writeDateLabel: UILabel = {
        let label = UILabel()
        label.text = "20213-12-21"
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 0.5
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13.0, weight: .light)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabel(_ information: BoardWrittenInformation) {
        self.nicknameLabel.text = information.nickname
        self.contentLabel.text = information.content
        self.contentTitleLabel.text = information.contentTitle
        self.writeDateLabel.text = information.writeDate
        
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = UIImage(data: information.boardImage)
        }
    }
}

extension BoardDetailView {
    private func addSubviews() {
        [
            imageView,
            likeButton,
            commentButton,
            likeCountLabel,
            commentCountLabel,
            nicknameLabel,
            contentLabel,
            contentTitleLabel,
            writeDateLabel
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            imageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 330.0),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            likeButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5.0),
            likeButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 5.0),
            likeButton.widthAnchor.constraint(equalToConstant: 30.0),
            likeButton.heightAnchor.constraint(equalToConstant: 20.0),
            
            likeCountLabel.topAnchor.constraint(equalTo: likeButton.topAnchor),
            likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 5.0),
            likeCountLabel.widthAnchor.constraint(equalToConstant: 40.0),
            likeCountLabel.heightAnchor.constraint(equalTo: likeButton.heightAnchor),

            commentButton.topAnchor.constraint(equalTo: likeButton.topAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor, constant: 12.0),
            commentButton.widthAnchor.constraint(equalTo: likeButton.widthAnchor),
            commentButton.heightAnchor.constraint(equalTo: likeButton.heightAnchor),
            
            commentCountLabel.topAnchor.constraint(equalTo: likeButton.topAnchor),
            commentCountLabel.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 5.0),
            commentCountLabel.widthAnchor.constraint(equalTo: likeCountLabel.widthAnchor),
            commentCountLabel.heightAnchor.constraint(equalTo: likeButton.heightAnchor),

            nicknameLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 8.0),
            nicknameLabel.leadingAnchor.constraint(equalTo: likeButton.leadingAnchor),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 20.0),
            nicknameLabel.widthAnchor.constraint(equalToConstant: 80.0),

            contentTitleLabel.topAnchor.constraint(equalTo: nicknameLabel.topAnchor),
            contentTitleLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: 5.0),
            contentTitleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5.0),
            contentTitleLabel.heightAnchor.constraint(equalTo: nicknameLabel.heightAnchor),

            contentLabel.topAnchor.constraint(equalTo: contentTitleLabel.bottomAnchor, constant: 5.0),
            contentLabel.leadingAnchor.constraint(equalTo: likeButton.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: contentTitleLabel.trailingAnchor),
            contentLabel.heightAnchor.constraint(equalToConstant: 240.0),

            writeDateLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 5.0),
            writeDateLabel.leadingAnchor.constraint(equalTo: likeButton.leadingAnchor),
            writeDateLabel.trailingAnchor.constraint(equalTo: contentTitleLabel.trailingAnchor),
            writeDateLabel.heightAnchor.constraint(equalTo: nicknameLabel.heightAnchor)
        ])
    }
}
