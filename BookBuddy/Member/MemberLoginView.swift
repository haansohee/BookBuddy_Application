//
//  MemberLoginView.swift
//  BookBuddy
//
//  Created by 한소희 on 10/26/23.
//

import UIKit

final class MemberLoginView: UIView {
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "BookBuddy! 📗"
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .bold)
        
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "이메일을 입력하세요."
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "비밀번호를 입력하세요."
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apple 로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private let firstBookBuddyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "BookBuddy가 처음이신가요?"
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        
        return label
    }()
    
    private let startToEmailButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("이메일로 시작하기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.borderColor = UIColor.systemGreen.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private let startToAppleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apple로 시작하기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        
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

extension MemberLoginView {
    private func addSubviews() {
        [
            welcomeLabel,
            emailTextField,
            passwordTextField,
            loginButton,
            appleLoginButton,
            firstBookBuddyLabel,
            startToEmailButton,
            startToAppleButton
        ].forEach {
            self.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 120.0),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 60.0),
            welcomeLabel.widthAnchor.constraint(equalToConstant: 180.0),

            emailTextField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30.0),
            emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),
            emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            emailTextField.heightAnchor.constraint(equalToConstant: 40.0),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12.0),
            passwordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),
            passwordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40.0),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12.0),
            loginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),
            loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            loginButton.heightAnchor.constraint(equalToConstant: 40.0),
            

            appleLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8.0),
            appleLoginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),
            appleLoginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 40.0),

            firstBookBuddyLabel.topAnchor.constraint(equalTo: appleLoginButton.bottomAnchor, constant: 120),
            firstBookBuddyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),
            firstBookBuddyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            firstBookBuddyLabel.heightAnchor.constraint(equalToConstant: 40.0),

            startToEmailButton.topAnchor.constraint(equalTo: firstBookBuddyLabel.bottomAnchor, constant: 14.0),
            startToEmailButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),
            startToEmailButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            startToEmailButton.heightAnchor.constraint(equalToConstant: 40.0),

            startToAppleButton.topAnchor.constraint(equalTo: startToEmailButton.bottomAnchor, constant: 14.0),
            startToAppleButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24.0),
            startToAppleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24.0),
            startToEmailButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }
}
