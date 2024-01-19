//
//  MemberEditView.swift
//  BookBuddy
//
//  Created by 한소희 on 11/24/23.
//

import UIKit

final class MemberEditView: UIView {
    let imagePickerView: UIImagePickerController = {
        let imagePickerView = UIImagePickerController()
        return imagePickerView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let profileUpdateButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("프로필 사진 수정", for: .normal)
        button.backgroundColor = .systemGreen
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        return button
    }()
    
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 13.0, weight: .light)
        textField.keyboardType = .asciiCapable
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6.0
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "테스트"
        textField.font = .systemFont(ofSize: 13.0, weight: .light)
        textField.keyboardType = .asciiCapable
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6.0
        return textField
    }()
    
    let nicknameDuplicateButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("중복확인하기", for: .normal)
        button.isEnabled = false
        button.backgroundColor = .lightGray
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        return button
    }()
    
    let nicknameEditButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("아이디 변경하기", for: .normal)
        button.isEnabled = false
        button.backgroundColor = .lightGray
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        return button
    }()
    
    let nicknameDuplicateIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "영어, 숫자, 언더바(_)만 사용 가능해요. \n 8~16자로 입력해 주세요."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let passwordEditButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("비밀번호 변경하기", for: .normal)
        button.backgroundColor = .systemGreen
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        return button
    }()
    
    let passwordCheckLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = ""
        label.textAlignment = .center
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let withdrawalButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("탈퇴하기", for: .normal)
        button.backgroundColor = .systemBackground
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
        return button
    }()
    
    let signoutButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그아웃", for: .normal)
        button.backgroundColor = .systemBackground
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MemberEditView {
    private func addSubviews() {
        [
            profileImageView,
            profileUpdateButton,
            nicknameTextField,
            nicknameDuplicateButton,
            nicknameEditButton,
            nicknameDuplicateIdLabel,
            passwordTextField,
            passwordEditButton,
            passwordCheckLabel,
            withdrawalButton,
            signoutButton
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            profileImageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100.0),
            profileImageView.heightAnchor.constraint(equalToConstant: 100.0),
            
            profileUpdateButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 14.0),
            profileUpdateButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            profileUpdateButton.widthAnchor.constraint(equalToConstant: 120.0),
            profileUpdateButton.heightAnchor.constraint(equalToConstant: 25.0),
            
            nicknameTextField.topAnchor.constraint(equalTo: profileUpdateButton.bottomAnchor, constant: 40.0),
            nicknameTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            nicknameTextField.widthAnchor.constraint(equalToConstant: 200),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 30.0),
            
            nicknameDuplicateButton.topAnchor.constraint(equalTo: nicknameTextField.topAnchor),
            nicknameDuplicateButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            nicknameDuplicateButton.widthAnchor.constraint(equalTo: profileUpdateButton.widthAnchor),
            nicknameDuplicateButton.heightAnchor.constraint(equalTo: profileUpdateButton.heightAnchor),
            
            nicknameEditButton.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 5.0),
            nicknameEditButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            nicknameEditButton.widthAnchor.constraint(equalTo: profileUpdateButton.widthAnchor),
            nicknameEditButton.heightAnchor.constraint(equalTo: profileUpdateButton.heightAnchor),
            
            nicknameDuplicateIdLabel.topAnchor.constraint(equalTo: nicknameEditButton.bottomAnchor, constant: 8.0),
            nicknameDuplicateIdLabel.leadingAnchor.constraint(equalTo: nicknameTextField.leadingAnchor),
            nicknameDuplicateIdLabel.trailingAnchor.constraint(equalTo: nicknameDuplicateButton.trailingAnchor),
            nicknameDuplicateIdLabel.heightAnchor.constraint(equalToConstant: 60.0),
            
            passwordTextField.topAnchor.constraint(equalTo: nicknameDuplicateIdLabel.bottomAnchor, constant: 10.0),
            passwordTextField.leadingAnchor.constraint(equalTo: nicknameTextField.leadingAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: nicknameTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: nicknameTextField.heightAnchor),
            
            passwordEditButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor),
            passwordEditButton.trailingAnchor.constraint(equalTo: nicknameEditButton.trailingAnchor),
            passwordEditButton.widthAnchor.constraint(equalTo: profileUpdateButton.widthAnchor),
            passwordEditButton.heightAnchor.constraint(equalTo: profileUpdateButton.heightAnchor),
            
            passwordCheckLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12.0),
            passwordCheckLabel.leadingAnchor.constraint(equalTo: nicknameTextField.leadingAnchor),
            passwordCheckLabel.trailingAnchor.constraint(equalTo: nicknameEditButton.trailingAnchor),
            passwordCheckLabel.heightAnchor.constraint(equalTo: nicknameDuplicateIdLabel.heightAnchor),
            
            withdrawalButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -120),
            withdrawalButton.leadingAnchor.constraint(equalTo: nicknameTextField.leadingAnchor),
            withdrawalButton.widthAnchor.constraint(equalTo: profileUpdateButton.widthAnchor),
            withdrawalButton.heightAnchor.constraint(equalTo: profileUpdateButton.heightAnchor),
            
            signoutButton.bottomAnchor.constraint(equalTo: withdrawalButton.bottomAnchor),
            signoutButton.trailingAnchor.constraint(equalTo: nicknameDuplicateButton.trailingAnchor),
            signoutButton.widthAnchor.constraint(equalTo: profileUpdateButton.widthAnchor),
            signoutButton.heightAnchor.constraint(equalTo: profileUpdateButton.heightAnchor)
        ])
    }
}
