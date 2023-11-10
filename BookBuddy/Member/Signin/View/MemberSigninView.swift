//
//  MemberLoginView.swift
//  BookBuddy
//
//  Created by 한소희 on 10/26/23.
//

import UIKit
import AuthenticationServices

final class MemberSigninView: UIView {
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "BookBuddy! 📗"
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    let idTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "ID"
        textField.font = .systemFont(ofSize: 15, weight: .medium)
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6.0
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.font = .systemFont(ofSize: 15, weight: .medium)
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6.0
        return textField
    }()
    
    private let signinButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign in", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 6.0
        return button
    }()
    
    private let appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    let startToEmailButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign up with Email", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBackground
        button.layer.borderColor = UIColor.systemGreen.cgColor
        button.layer.borderWidth = 1
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

extension MemberSigninView {
    private func addSubviews() {
        [
            welcomeLabel,
            idTextField,
            passwordTextField,
            signinButton,
            appleLoginButton,
            firstBookBuddyLabel,
            startToEmailButton
        ].forEach {
            self.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 60.0),
            welcomeLabel.widthAnchor.constraint(equalToConstant: 180.0),

            idTextField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30.0),
            idTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            idTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            idTextField.heightAnchor.constraint(equalToConstant: 40.0),

            passwordTextField.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 12.0),
            passwordTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            passwordTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            passwordTextField.heightAnchor.constraint(equalTo: idTextField.heightAnchor),
            
            signinButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12.0),
            signinButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            signinButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            signinButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            appleLoginButton.topAnchor.constraint(equalTo: signinButton.bottomAnchor, constant: 8.0),
            appleLoginButton.leadingAnchor.constraint(equalTo: signinButton.leadingAnchor),
            appleLoginButton.trailingAnchor.constraint(equalTo: signinButton.trailingAnchor),
            appleLoginButton.heightAnchor.constraint(equalTo: signinButton.heightAnchor),

            firstBookBuddyLabel.topAnchor.constraint(equalTo: appleLoginButton.bottomAnchor, constant: 180),
            firstBookBuddyLabel.leadingAnchor.constraint(equalTo: signinButton.leadingAnchor),
            firstBookBuddyLabel.trailingAnchor.constraint(equalTo: signinButton.trailingAnchor),
            firstBookBuddyLabel.heightAnchor.constraint(equalTo: signinButton.heightAnchor),

            startToEmailButton.topAnchor.constraint(equalTo: firstBookBuddyLabel.bottomAnchor, constant: 14.0),
            startToEmailButton.leadingAnchor.constraint(equalTo: signinButton.leadingAnchor),
            startToEmailButton.trailingAnchor.constraint(equalTo: signinButton.trailingAnchor),
            startToEmailButton.heightAnchor.constraint(equalTo: signinButton.heightAnchor)
        ])
    }
}
