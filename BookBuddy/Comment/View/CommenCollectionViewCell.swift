//
//  CommenCollectiontViewCell.swift
//  BookBuddy
//
//  Created by 한소희 on 1/25/24.
//

import UIKit
import RxSwift
import SwipeCellKit

final class CommenCollectionViewCell: SwipeCollectionViewCell {
    var disposeBag = DisposeBag()
    
    private let isEmptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "아직 댓글이 없어요. 댓글을 작성해 보세요."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person")
        imageView.layer.cornerRadius = 18
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemBackground
        imageView.tintColor = .label
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 12.0, weight: .bold)
        return label
    }()
    
    private let writeDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 10.0, weight: .light)
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.sizeToFit()
        label.textColor = .label
        label.font = .systemFont(ofSize: 11.0)
    
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
//        self.backgroundColor = .systemGray6
//        self.layer.cornerRadius = 3.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCommentViewCell(_ commentInformation: CommentInformation) {
        nicknameLabel.text = commentInformation.nickname
        writeDateLabel.text = commentInformation.writeDate
        commentLabel.text = commentInformation.commentContent
    }
    
    func isHiddenOption(_ checkIsEmpty: Bool) {
        if checkIsEmpty {
            isEmptyLabel.isHidden = false
            [
                profileImage,
                nicknameLabel,
                writeDateLabel,
                commentLabel
            ].forEach { $0.isHidden = true}
        } else {
            isEmptyLabel.isHidden = true
            [
                profileImage,
                nicknameLabel,
                writeDateLabel,
                commentLabel
            ].forEach { $0.isHidden = false}
        }
    }
}

extension CommenCollectionViewCell {
    private func addSubviews() {
        [
            isEmptyLabel,
            profileImage,
            nicknameLabel,
            writeDateLabel,
            commentLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            isEmptyLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            isEmptyLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            isEmptyLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 8.0),
            isEmptyLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 8.0),
            
            profileImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            profileImage.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            profileImage.widthAnchor.constraint(equalToConstant: 36.0),
            profileImage.heightAnchor.constraint(equalToConstant: 36.0),
            
            nicknameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 3.0),
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8.0),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 10.0),
            
            commentLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            commentLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            
            writeDateLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor),
            writeDateLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            writeDateLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8.0),
            writeDateLabel.widthAnchor.constraint(equalToConstant: 100.0),
            writeDateLabel.heightAnchor.constraint(equalTo: nicknameLabel.heightAnchor),
        ])
    }
}
