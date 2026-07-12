//
//  BoardDetailView.swift
//  BookBuddy
//
//  Created by 한소희 on 12/21/23.
//

import UIKit
import SkeletonView

final class BoardDetailView: UIScrollView {
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isSkeletonable = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let likeButton: AnimationButton = {
        let button = AnimationButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let commentButton: AnimationButton = {
        let button = AnimationButton()
        button.setImage(UIImage(systemName: "bubble"), for: .normal)
        button.tintColor = .systemGray3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 11.0, weight: .light)
        label.textAlignment = .left
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 11.0, weight: .light)
        label.textAlignment = .left
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12.0, weight: .bold)
        label.textAlignment = .left
        label.sizeToFit()
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 13.0)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let writeDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13.0, weight: .light)
        label.textAlignment = .left
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isSkeletonable = true
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEditedInfoLabel(_ information: BoardEditInformation) {
        contentTitleLabel.text = information.contentTitle
        contentLabel.text = information.content
        imageView.image = UIImage(data: information.boardImage)
    }
    
    func setBoardDetailView(_ information: BoardDetailInformation) {
        nicknameLabel.text = information.nickname
        contentLabel.text = information.content
        contentTitleLabel.text = information.contentTitle
        writeDateLabel.text = information.writeDate
        likeCountLabel.text = String(information.likes)
        commentCountLabel.text = String(information.comments.count)
        imageView.image = UIImage(data: information.boardImage)
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
        ].forEach { containerView.addSubview($0) }
        self.addSubview(containerView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.contentLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.contentLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: self.frameLayoutGuide.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8.0),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            likeButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5.0),
            likeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 14.0),
            likeButton.widthAnchor.constraint(equalToConstant: 24.0),
            likeButton.heightAnchor.constraint(equalToConstant: 24.0),
            
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
            nicknameLabel.heightAnchor.constraint(equalToConstant: 15.0),

            contentTitleLabel.topAnchor.constraint(equalTo: nicknameLabel.topAnchor),
            contentTitleLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: 8.0),
            contentTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -14.0),
            contentTitleLabel.heightAnchor.constraint(equalTo: nicknameLabel.heightAnchor),

            contentLabel.topAnchor.constraint(equalTo: contentTitleLabel.bottomAnchor, constant: 5.0),
            contentLabel.leadingAnchor.constraint(equalTo: likeButton.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: contentTitleLabel.trailingAnchor),

            writeDateLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 5.0),
            writeDateLabel.leadingAnchor.constraint(equalTo: likeButton.leadingAnchor),
            writeDateLabel.trailingAnchor.constraint(equalTo: contentTitleLabel.trailingAnchor),
            writeDateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5.0),
            writeDateLabel.heightAnchor.constraint(equalToConstant: 15.0)
        ])
    }
}
