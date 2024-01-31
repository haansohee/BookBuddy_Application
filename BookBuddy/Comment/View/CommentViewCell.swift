//
//  CommentViewCell.swift
//  BookBuddy
//
//  Created by 한소희 on 1/25/24.
//

import UIKit

final class CommentViewCell: UICollectionViewCell {
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person")
        imageView.layer.cornerRadius = 15
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray4
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "테스트닉네임"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()
    
    private let writeDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2024/1/31"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 11.0, weight: .light)
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.sizeToFit()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
        self.backgroundColor = .systemGray5
        self.layer.cornerRadius = 6.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCommentViewCell(_ commentInformation: CommentInformation) {
        nicknameLabel.text = commentInformation.nickname
        writeDateLabel.text = commentInformation.writeDate
        commentLabel.text = commentInformation.commentContent
    }
}

extension CommentViewCell {
    private func addSubviews() {
        [
            profileImage,
            nicknameLabel,
            writeDateLabel,
            commentLabel
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            profileImage.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            profileImage.widthAnchor.constraint(equalToConstant: 30.0),
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor),
            
            nicknameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 5.0),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            writeDateLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            writeDateLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: 12.0),
            writeDateLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            writeDateLabel.widthAnchor.constraint(equalToConstant: 100.0),
            writeDateLabel.heightAnchor.constraint(equalTo: nicknameLabel.heightAnchor),
            
            commentLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8.0),
            commentLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            commentLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            commentLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8.0)
        ])
    }
}
