//
//  BoardSearchViewCell.swift
//  BookBuddy
//
//  Created by 한소희 on 1/9/24.
//

import UIKit
import RxSwift

final class BoardSearchViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
    let touchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5.0
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray4
        return imageView
    }()
    
    private let titleNicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "테스트닉네임"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()
    
    private let boardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray4
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
        label.text = "0"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 11.0, weight: .light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 11.0, weight: .light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "테스트닉네임"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private let contentTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "테스트제목"
        label.textAlignment = .left
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "테스트내용"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    private let writeDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "테스트날짜"
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.3
        self.layer.cornerRadius = 3.0
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBoardSearchViewCell(boardSearchResultsInfo: BoardSearchResultsInformation) {
        titleNicknameLabel.text = boardSearchResultsInfo.nickname
        boardImageView.image = UIImage(data: boardSearchResultsInfo.boardImage)
        nicknameLabel.text = boardSearchResultsInfo.nickname
        contentTitleLabel.text = boardSearchResultsInfo.contentTitle
        contentLabel.text = boardSearchResultsInfo.content
        likeCountLabel.text = String(boardSearchResultsInfo.likes)
        writeDateLabel.text = boardSearchResultsInfo.writeDate
    }
    
    func setFollowingBoardViewCell(followingBoardInfo: FollowingBoardInformation) {
        titleNicknameLabel.text = followingBoardInfo.nickname
        boardImageView.image = UIImage(data: followingBoardInfo.boardImage)
        nicknameLabel.text = followingBoardInfo.nickname
        contentTitleLabel.text = followingBoardInfo.contentTitle
        contentLabel.text = followingBoardInfo.content
        likeCountLabel.text = String(followingBoardInfo.likes)
        writeDateLabel.text = followingBoardInfo.writeDate
    }
}

extension BoardSearchViewCell {
    private func addSubviews() {
        [
            profileImageView,
            titleNicknameLabel
        ].forEach { touchStackView.addSubview($0) }
        [
            touchStackView,
            boardImageView,
            likeButton,
            likeCountLabel,
            commentButton,
            commentCountLabel,
            nicknameLabel,
            contentTitleLabel,
            contentLabel,
            writeDateLabel
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            touchStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            touchStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            touchStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            touchStackView.heightAnchor.constraint(equalToConstant: 30.0),
            
            profileImageView.topAnchor.constraint(equalTo: touchStackView.safeAreaLayoutGuide.topAnchor, constant: 3.0),
            profileImageView.leadingAnchor.constraint(equalTo: touchStackView.safeAreaLayoutGuide.leadingAnchor, constant: 3.0),
            profileImageView.widthAnchor.constraint(equalTo: touchStackView.heightAnchor),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            
            titleNicknameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            titleNicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 3.0),
            titleNicknameLabel.trailingAnchor.constraint(equalTo: touchStackView.safeAreaLayoutGuide.trailingAnchor, constant: -3.0),
            titleNicknameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor),
            
            boardImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 3.0),
            boardImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            boardImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            boardImageView.heightAnchor.constraint(equalTo: boardImageView.widthAnchor),
            
            likeButton.topAnchor.constraint(equalTo: boardImageView.bottomAnchor, constant: 3.0),
            likeButton.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
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
            
            nicknameLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 5.0),
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 20.0),
            nicknameLabel.widthAnchor.constraint(equalToConstant: 100.0),
            
            contentTitleLabel.topAnchor.constraint(equalTo: nicknameLabel.topAnchor),
            contentTitleLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: 5.0),
            contentTitleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -3.0),
            contentTitleLabel.heightAnchor.constraint(equalTo: nicknameLabel.heightAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: contentTitleLabel.bottomAnchor, constant: 3.0),
            contentLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: contentTitleLabel.trailingAnchor),
            contentLabel.heightAnchor.constraint(equalToConstant: 130.0),

            writeDateLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 3.0),
            writeDateLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            writeDateLabel.trailingAnchor.constraint(equalTo: contentTitleLabel.trailingAnchor),
            writeDateLabel.heightAnchor.constraint(equalTo: nicknameLabel.heightAnchor)
        ])
    }
}

