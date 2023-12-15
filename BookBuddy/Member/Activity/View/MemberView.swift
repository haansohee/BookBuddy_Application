//
//  MemberView.swift
//  BookBuddy
//
//  Created by 한소희 on 10/28/23.
//

import UIKit

final class MemberView: UIView {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray6.cgColor
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemPink
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "name test"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .bold)
        
        return label
    }()
    
    let favoriteBook: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "가장 좋아하는 책을 설정해 보세요."
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    
    private let boardCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "123"
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        
        
        return label
    }()
    
    private let followersCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "123"
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        
        return label
    }()
    
    private let followingCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "123"
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        
        return label
    }()
    
    private let boardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "게시물"
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "팔로워"
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "팔로잉"
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        
        return label
    }()
    
    let editButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("정보 수정하기", for: .normal)
        button.isHidden = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .light)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 5.0
        
        return button
    }()
    
    let boardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = 5.0

        layout.scrollDirection = .vertical
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BoardCollectionViewCell.self, forCellWithReuseIdentifier: "BoardCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.backgroundColor = .systemBackground
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .brown
        
        return collectionView
    }()
    
    func setNameLabel(_ text: String) {
        DispatchQueue.main.async {
            self.nameLabel.text = text
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

extension MemberView {
    private func addSubviews() {
        [
            profileImageView,
            nameLabel,
            favoriteBook,
            boardCountLabel,
            followersCountLabel,
            followingCountLabel,
            boardLabel,
            followersLabel,
            followingLabel,
            editButton,
            boardCollectionView
        ].forEach {
            self.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            profileImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 40.0),
            profileImageView.heightAnchor.constraint(equalToConstant: 100.0),
            profileImageView.widthAnchor.constraint(equalToConstant: 100.0),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12.0),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            
            favoriteBook.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4.0),
            favoriteBook.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            favoriteBook.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            favoriteBook.heightAnchor.constraint(equalToConstant: 40.0),
            
            boardCountLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40.0),
            boardCountLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 24.0),
            boardCountLabel.heightAnchor.constraint(equalToConstant: 30.0),
            boardCountLabel.widthAnchor.constraint(equalToConstant: 60.0),
            
            followersCountLabel.topAnchor.constraint(equalTo: boardCountLabel.topAnchor),
            followersCountLabel.leadingAnchor.constraint(equalTo: boardCountLabel.trailingAnchor, constant: 8.0),
            followersCountLabel.heightAnchor.constraint(equalTo: boardCountLabel.heightAnchor),
            followersCountLabel.widthAnchor.constraint(equalTo: boardCountLabel.widthAnchor),
            
            followingCountLabel.topAnchor.constraint(equalTo: boardCountLabel.topAnchor),
            followingCountLabel.leadingAnchor.constraint(equalTo: followersCountLabel.trailingAnchor, constant: 8.0),
            followingCountLabel.heightAnchor.constraint(equalTo: boardCountLabel.heightAnchor),
            followingCountLabel.widthAnchor.constraint(equalTo: boardCountLabel.widthAnchor),
            
            boardLabel.topAnchor.constraint(equalTo: boardCountLabel.bottomAnchor, constant: 5.0),
            boardLabel.centerXAnchor.constraint(equalTo: boardCountLabel.centerXAnchor),
            boardLabel.heightAnchor.constraint(equalToConstant: 20.0),
            boardLabel.widthAnchor.constraint(equalToConstant: 40.0),
            
            followersLabel.topAnchor.constraint(equalTo: followersCountLabel.bottomAnchor, constant: 5.0),
            followersLabel.centerXAnchor.constraint(equalTo: followersCountLabel.centerXAnchor),
            followersLabel.heightAnchor.constraint(equalTo: boardLabel.heightAnchor),
            followersLabel.widthAnchor.constraint(equalTo: boardLabel.widthAnchor),
            
            followingLabel.topAnchor.constraint(equalTo: followingCountLabel.bottomAnchor, constant: 5.0),
            followingLabel.centerXAnchor.constraint(equalTo: followingCountLabel.centerXAnchor),
            followingLabel.heightAnchor.constraint(equalTo: boardLabel.heightAnchor),
            followingLabel.widthAnchor.constraint(equalTo: boardLabel.widthAnchor),
            
            editButton.topAnchor.constraint(equalTo: followingLabel.bottomAnchor, constant: 8.0),
            editButton.leadingAnchor.constraint(equalTo: boardCountLabel.leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: followingCountLabel.trailingAnchor),
            editButton.heightAnchor.constraint(equalToConstant: 30.0),
            
            boardCollectionView.topAnchor.constraint(equalTo: favoriteBook.bottomAnchor, constant: 12.0),
            boardCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            boardCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            boardCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
}
