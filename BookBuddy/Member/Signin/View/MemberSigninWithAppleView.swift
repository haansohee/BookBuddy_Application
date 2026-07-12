//
//  MemberSigninWithAppleView.swift
//  BookBuddy
//
//  Created by 한소희 on 11/24/23.
//

import UIKit

final class MemberSigninWithAppleView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "BookBuddy에서 사용할 아이디를 \n 입력해 주세요!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let inputNicknameTextField: UITextField = {
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
    
    let nicknameDuplicateCheckButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("중복확인", for: .normal)
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .light)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    let doneButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("확인", for: .normal)
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .light)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5.0
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

extension MemberSigninWithAppleView {
    private func addSubviews() {
        [
            titleLabel,
            inputNicknameTextField,
            nicknameDuplicateCheckButton,
            doneButton
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50.0),
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 150.0),
            
            inputNicknameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.0),
            inputNicknameTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            inputNicknameTextField.trailingAnchor.constraint(equalTo: nicknameDuplicateCheckButton.leadingAnchor, constant: -10.0),
            inputNicknameTextField.heightAnchor.constraint(equalToConstant: 40.0),
            
            nicknameDuplicateCheckButton.topAnchor.constraint(equalTo: inputNicknameTextField.topAnchor),
            nicknameDuplicateCheckButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            nicknameDuplicateCheckButton.widthAnchor.constraint(equalToConstant: 70.0),
            nicknameDuplicateCheckButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            doneButton.topAnchor.constraint(equalTo: inputNicknameTextField.bottomAnchor, constant: 70.0),
            doneButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 100.0),
            doneButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }
}
