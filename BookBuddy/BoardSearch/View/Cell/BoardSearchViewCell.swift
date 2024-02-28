//
//  BoardSearchViewCell.swift
//  BookBuddy
//
//  Created by 한소희 on 1/9/24.
//

import UIKit
import RxSwift

final class BoardSearchViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    var disposeBag = DisposeBag()
    private var contentLabelConstraints: NSLayoutConstraint?
    private var contentLabelConstraintsIsTapped: NSLayoutConstraint?
    
    let readMoreButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("...더 보기", for: .normal)
        button.setTitleColor(.systemGray2, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.titleLabel?.textAlignment = .left
        return button
    }()
    
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
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.clipsToBounds = true
        imageView.tintColor = .systemGray3
        return imageView
    }()
    
    private let titleNicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()
    
    let ellipsisButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .lightGray
        button.backgroundColor = .systemBackground
        return button
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
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 11.0, weight: .light)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 11.0, weight: .light)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private let contentTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 13.0)
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    private let writeDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        readMoreIsTapped(false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentLabelConstraints = contentLabel.trailingAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -200.0)
        contentLabelConstraintsIsTapped = contentLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12.0)
        addSubviews()
        setLayoutConstraints()
        readMoreIsTapped(false)
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
    
    func readMoreIsTapped(_ isTapped: Bool) {
        if isTapped {
            contentLabelConstraints?.isActive = !isTapped
            contentLabelConstraintsIsTapped?.isActive = isTapped
            readMoreButton.setTitle("", for: .normal)
            contentLabel.numberOfLines = 0
        } else {
            contentLabelConstraintsIsTapped?.isActive = isTapped
            contentLabelConstraints?.isActive = !isTapped
            readMoreButton.setTitle("...더 보기", for: .normal)
            contentLabel.numberOfLines = 1
        }
    }
}

extension BoardSearchViewCell {
    private func addSubviews() {
        [
            profileImageView,
            titleNicknameLabel,
            ellipsisButton
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
            readMoreButton,
            writeDateLabel
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            touchStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            touchStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            touchStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            touchStackView.heightAnchor.constraint(equalToConstant: 50.0),
            
            profileImageView.topAnchor.constraint(equalTo: touchStackView.topAnchor, constant: 5.0),
            profileImageView.leadingAnchor.constraint(equalTo: touchStackView.leadingAnchor, constant: 5.0),
            profileImageView.bottomAnchor.constraint(equalTo: touchStackView.bottomAnchor, constant: -5.0),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
            
            titleNicknameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            titleNicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5.0),
            titleNicknameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor),
            
            ellipsisButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            ellipsisButton.leadingAnchor.constraint(equalTo: titleNicknameLabel.trailingAnchor, constant: 5.0),
            ellipsisButton.trailingAnchor.constraint(equalTo: touchStackView.trailingAnchor, constant: -5.0),
            ellipsisButton.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
            ellipsisButton.heightAnchor.constraint(equalTo: profileImageView.heightAnchor),
            
            
            boardImageView.topAnchor.constraint(equalTo: touchStackView.bottomAnchor),
            boardImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            boardImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            boardImageView.heightAnchor.constraint(equalTo: boardImageView.widthAnchor),
            
            likeButton.topAnchor.constraint(equalTo: boardImageView.bottomAnchor, constant: 3.0),
            likeButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
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
            
            nicknameLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 5.0),
            nicknameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            contentTitleLabel.topAnchor.constraint(equalTo: nicknameLabel.topAnchor),
            contentTitleLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: 8.0),
            contentTitleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            contentTitleLabel.heightAnchor.constraint(equalTo: nicknameLabel.heightAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: contentTitleLabel.bottomAnchor, constant: 3.0),
            contentLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),

            readMoreButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 1.0),
            readMoreButton.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            readMoreButton.widthAnchor.constraint(equalToConstant: 60.0),
            readMoreButton.heightAnchor.constraint(equalToConstant: 24.0),

            writeDateLabel.topAnchor.constraint(equalTo: readMoreButton.bottomAnchor, constant: 3.0),
            writeDateLabel.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            writeDateLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -12.0),
            writeDateLabel.trailingAnchor.constraint(equalTo: contentTitleLabel.trailingAnchor),
            writeDateLabel.heightAnchor.constraint(equalToConstant: 10.0)
        ])
    }
}

