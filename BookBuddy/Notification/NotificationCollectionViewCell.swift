//
//  NotificationCollectionViewCell.swift
//  BookBuddy
//
//  Created by 한소희 on 3/19/24.
//

import UIKit
import SkeletonView

final class NotificationCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person")
        imageView.layer.cornerRadius = 25.0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.tintColor = .label
        imageView.backgroundColor = .systemBackground
        imageView.isHidden = false
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private let boardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person")
        imageView.layer.cornerRadius = 5.0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.tintColor = .label
        imageView.backgroundColor = .systemBackground
        imageView.isHidden = false
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private let notificationContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 12.0)
        label.numberOfLines = 0
        label.isHidden = false
        label.isSkeletonable = true
        return label
    }()
    
    private let notificationBlackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        label.text = "알림이 없습니다. 🥲"
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.isHidden = true
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
    
    func setIsHiddenOption(_ isExistedInfo: Bool) {
        [
            profileImageView,
            boardImageView,
            notificationContentLabel
        ].forEach { $0.isHidden = !isExistedInfo }
        notificationBlackLabel.isHidden = isExistedInfo
    }
    
    func setNotificationInfo(_ information: NotificationInformation) {
        boardImageView.image = UIImage(data: information.boardImage)
        notificationContentLabel.text = information.notificationContent
        guard let profileImage = information.profileImage else { return }
        profileImageView.image = UIImage(data: profileImage)
    }
}

extension NotificationCollectionViewCell {
    private func addSubviews() {
        [
            profileImageView,
            boardImageView,
            notificationContentLabel,
            notificationBlackLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
            profileImageView.widthAnchor.constraint(equalToConstant: 50.0),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            
            notificationContentLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15.0),
            notificationContentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8.0),
            notificationContentLabel.trailingAnchor.constraint(equalTo: boardImageView.leadingAnchor, constant: -8.0),
            notificationContentLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -15.0),
            
            boardImageView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            boardImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            boardImageView.widthAnchor.constraint(equalToConstant: 60.0),
            boardImageView.heightAnchor.constraint(equalTo: boardImageView.widthAnchor),
            
            notificationBlackLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            notificationBlackLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            notificationBlackLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            notificationBlackLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8.0),
        ])
    }
}
