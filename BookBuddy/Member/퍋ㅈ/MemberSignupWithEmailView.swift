//
//  MemberSignupWithEmailView.swift
//  BookBuddy
//
//  Created by 한소희 on 10/31/23.
//

import UIKit

final class MemberSignupWithEmailView: UIView {
    private let idTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "아이디를 입력하세요."
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6.0
        return textField
    }()
    
    private let duplicateIdCheckButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("중복확인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 6.0
        return button
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "이메일을 입력하세요."
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6.0
        return textField
    }()
    
    private let emailAuthenticationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("이메일 인증하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 6.0
        return button
    }()
    
    private let checkEmailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이메일 인증을 진행해 주세요."
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "비밀번호를 입력하세요."
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6.0
        return textField
    }()
    
    private let passwordCheckTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "비밀번호를 재입력하세요."
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 6.0
        return textField
    }()
    
    private let passwordCheckLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "비밀번호가 일치하지 않아요."
        label.textAlignment = .center
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
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
        [
            idTextField,
            duplicateIdCheckButton,
            emailTextField,
            emailAuthenticationButton,
            checkEmailLabel,
            passwordTextField,
            passwordCheckTextField,
            passwordCheckLabel,
            doneButton
        ].forEach {
            self.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            idTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 54.0),
            idTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            idTextField.widthAnchor.constraint(equalToConstant: 240.0),
            idTextField.heightAnchor.constraint(equalToConstant: 40.0),
            
            duplicateIdCheckButton.topAnchor.constraint(equalTo: idTextField.topAnchor),
            duplicateIdCheckButton.leadingAnchor.constraint(equalTo: idTextField.trailingAnchor, constant: 14.0),
            duplicateIdCheckButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            duplicateIdCheckButton.heightAnchor.constraint(equalTo: idTextField.heightAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 24.0),
            emailTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            emailTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            emailTextField.heightAnchor.constraint(equalTo: idTextField.heightAnchor),
            
            emailAuthenticationButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 14.0),
            emailAuthenticationButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            emailAuthenticationButton.heightAnchor.constraint(equalTo: idTextField.heightAnchor),
            emailAuthenticationButton.widthAnchor.constraint(equalToConstant: 120.0),
            
            checkEmailLabel.topAnchor.constraint(equalTo: emailAuthenticationButton.bottomAnchor, constant: 12.0),
            checkEmailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            checkEmailLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            checkEmailLabel.heightAnchor.constraint(equalTo: idTextField.heightAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: checkEmailLabel.bottomAnchor, constant: 24.0),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: idTextField.heightAnchor),
            
            passwordCheckTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12.0),
            passwordCheckTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordCheckTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordCheckTextField.heightAnchor.constraint(equalTo: idTextField.heightAnchor),
            
            passwordCheckLabel.topAnchor.constraint(equalTo: passwordCheckTextField.bottomAnchor, constant: 10.0),
            passwordCheckLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordCheckLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordCheckLabel.heightAnchor.constraint(equalTo: idTextField.heightAnchor),
            
            doneButton.topAnchor.constraint(equalTo: passwordCheckLabel.bottomAnchor, constant: 24.0),
            doneButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            doneButton.heightAnchor.constraint(equalTo: idTextField.heightAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 80.0)
        ])
    }
}
