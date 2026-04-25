//
//  MemberSignupWithEmailView.swift
//  BookBuddy
//
//  Created by 한소희 on 10/31/23.
//

import UIKit

final class MemberSignupWithEmailView: UIScrollView {    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "아이디 (영문, 숫자, _ 8~16자)"
        textField.keyboardType = .asciiCapable
        textField.font = .systemFont(ofSize: 15, weight: .medium)
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6.0
        return textField
    }()
    
    let duplicateIdCheckButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("중복확인", for: .normal)
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 6.0
        return button
    }()
    
    let duplicateIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .asciiCapable
        textField.placeholder = "이메일을 입력하세요."
        textField.font = .systemFont(ofSize: 15, weight: .medium)
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6.0
        return textField
    }()
    
    private let atSignLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let emailAddressTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .emailAddress
        textField.placeholder = "example.com"
        textField.isEnabled = false
        textField.font = .systemFont(ofSize: 15, weight: .medium)
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6.0
        return textField
    }()
    
    let naverEmailButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("NAVER", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 6.0
        return button
    }()
    
    let googleEmailButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Google", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 6.0
        return button
    }()
    
    let icloudEmailButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("iCloud", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.backgroundColor = .systemBackground
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 6.0
        return button
    }()
    
    let directInputButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("직접 입력", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 6.0
        return button
    }()
    
    let emailAuthenticationButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("이메일 인증하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 6.0
        return button
    }()
    
    let checkEmailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이메일 인증을 진행해 주세요."
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let authCodeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.placeholder = "인증번호를 입력하세요."
        textField.font = .systemFont(ofSize: 15, weight: .medium)
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6.0
        return textField
    }()
    
    let codeAuthenticationButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("인증하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 6.0
        return button
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .asciiCapable
        textField.placeholder = "비밀번호를 입력하세요."
        textField.font = .systemFont(ofSize: 15, weight: .medium)
        textField.isSecureTextEntry = true
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6.0
        return textField
    }()
    
    let passwordCheckTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .asciiCapable
        textField.placeholder = "비밀번호를 재입력하세요."
        textField.font = .systemFont(ofSize: 15, weight: .medium)
        textField.isSecureTextEntry = true
        textField.isEnabled = false
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6.0
        return textField
    }()
    
    let isSecureTextEntryButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("👀", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 6.0
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
    
    let signupButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("가입하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 6.0
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

extension MemberSignupWithEmailView {
    private func addSubviews() {
        self.addSubview(containerView)
        [
            nickNameTextField,
            duplicateIdCheckButton,
            duplicateIdLabel,
            emailTextField,
            atSignLabel,
            emailAddressTextField,
            naverEmailButton,
            googleEmailButton,
            icloudEmailButton,
            directInputButton,
            emailAuthenticationButton,
            checkEmailLabel,
            authCodeTextField,
            codeAuthenticationButton,
            passwordTextField,
            passwordCheckTextField,
            isSecureTextEntryButton,
            passwordCheckLabel,
            signupButton
        ].forEach {
            containerView.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.contentLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.contentLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: self.frameLayoutGuide.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            nickNameTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 54.0),
            nickNameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24.0),
            nickNameTextField.widthAnchor.constraint(equalToConstant: 250.0),
            nickNameTextField.heightAnchor.constraint(equalToConstant: 40.0),
            
            duplicateIdCheckButton.topAnchor.constraint(equalTo: nickNameTextField.topAnchor),
            duplicateIdCheckButton.leadingAnchor.constraint(equalTo: nickNameTextField.trailingAnchor, constant: 14.0),
            duplicateIdCheckButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24.0),
            duplicateIdCheckButton.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            
            duplicateIdLabel.topAnchor.constraint(equalTo: duplicateIdCheckButton.bottomAnchor, constant: 10.0),
            duplicateIdLabel.leadingAnchor.constraint(equalTo: nickNameTextField.leadingAnchor),
            duplicateIdLabel.trailingAnchor.constraint(equalTo: duplicateIdCheckButton.trailingAnchor),
            duplicateIdLabel.heightAnchor.constraint(equalToConstant: 60.0),
            
            emailTextField.topAnchor.constraint(equalTo: duplicateIdLabel.bottomAnchor, constant: 24.0),
            emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24.0),
            emailTextField.widthAnchor.constraint(equalToConstant: 140.0),
            emailTextField.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            
            atSignLabel.topAnchor.constraint(equalTo: emailTextField.topAnchor),
            atSignLabel.leadingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            atSignLabel.widthAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            atSignLabel.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            
            emailAddressTextField.topAnchor.constraint(equalTo: emailTextField.topAnchor),
            emailAddressTextField.leadingAnchor.constraint(equalTo: atSignLabel.trailingAnchor),
            emailAddressTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24.0),
            emailAddressTextField.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            
            naverEmailButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 14.0),
            naverEmailButton.leadingAnchor.constraint(equalTo: nickNameTextField.leadingAnchor),
            naverEmailButton.widthAnchor.constraint(equalToConstant: 75.0),
            naverEmailButton.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            
            googleEmailButton.topAnchor.constraint(equalTo: naverEmailButton.topAnchor),
            googleEmailButton.leadingAnchor.constraint(equalTo: naverEmailButton.trailingAnchor, constant: 14.0),
            googleEmailButton.widthAnchor.constraint(equalTo: naverEmailButton.widthAnchor),
            googleEmailButton.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            
            icloudEmailButton.topAnchor.constraint(equalTo: naverEmailButton.topAnchor),
            icloudEmailButton.leadingAnchor.constraint(equalTo: googleEmailButton.trailingAnchor, constant: 14.0),
            icloudEmailButton.widthAnchor.constraint(equalTo: naverEmailButton.widthAnchor),
            icloudEmailButton.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            
            directInputButton.topAnchor.constraint(equalTo: naverEmailButton.topAnchor),
            directInputButton.leadingAnchor.constraint(equalTo: icloudEmailButton.trailingAnchor, constant: 14.0),
            directInputButton.trailingAnchor.constraint(equalTo: emailAddressTextField.trailingAnchor),
            directInputButton.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            
            emailAuthenticationButton.topAnchor.constraint(equalTo: naverEmailButton.bottomAnchor, constant: 14.0),
            emailAuthenticationButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emailAuthenticationButton.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            emailAuthenticationButton.widthAnchor.constraint(equalToConstant: 120.0),
            
            checkEmailLabel.topAnchor.constraint(equalTo: emailAuthenticationButton.bottomAnchor, constant: 12.0),
            checkEmailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            checkEmailLabel.trailingAnchor.constraint(equalTo: emailAddressTextField.trailingAnchor),
            checkEmailLabel.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            
            authCodeTextField.topAnchor.constraint(equalTo: checkEmailLabel.bottomAnchor, constant: 12.0),
            authCodeTextField.leadingAnchor.constraint(equalTo: nickNameTextField.leadingAnchor),
            authCodeTextField.widthAnchor.constraint(equalTo:nickNameTextField.widthAnchor),
            authCodeTextField.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            
            codeAuthenticationButton.topAnchor.constraint(equalTo: authCodeTextField.topAnchor),
            codeAuthenticationButton.leadingAnchor.constraint(equalTo: nickNameTextField.trailingAnchor, constant: 14.0),
            codeAuthenticationButton.trailingAnchor.constraint(equalTo: duplicateIdCheckButton.trailingAnchor),
            codeAuthenticationButton.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: authCodeTextField.bottomAnchor, constant: 24.0),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: nickNameTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            
            isSecureTextEntryButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor),
            isSecureTextEntryButton.leadingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 12.0),
            isSecureTextEntryButton.trailingAnchor.constraint(equalTo: emailAddressTextField.trailingAnchor),
            isSecureTextEntryButton.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            
            passwordCheckTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12.0),
            passwordCheckTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordCheckTextField.trailingAnchor.constraint(equalTo: isSecureTextEntryButton.trailingAnchor),
            passwordCheckTextField.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),

            passwordCheckLabel.topAnchor.constraint(equalTo: passwordCheckTextField.bottomAnchor, constant: 10.0),
            passwordCheckLabel.leadingAnchor.constraint(equalTo: passwordCheckTextField.leadingAnchor),
            passwordCheckLabel.trailingAnchor.constraint(equalTo: passwordCheckTextField.trailingAnchor),
            passwordCheckLabel.heightAnchor.constraint(equalTo: duplicateIdLabel.heightAnchor),
            
            signupButton.topAnchor.constraint(equalTo: passwordCheckLabel.bottomAnchor, constant: 24.0),
            signupButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            signupButton.heightAnchor.constraint(equalTo: nickNameTextField.heightAnchor),
            signupButton.widthAnchor.constraint(equalToConstant: 80.0),
        ])
    }
}
