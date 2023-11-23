//
//  MemberSignupCompleteionPopupView.swift
//  BookBuddy
//
//  Created by 한소희 on 11/22/23.
//

import UIKit

final class MemberSignupCompleteionPopupView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "BookBuddy 📗"
        label.textAlignment = .center
        label.font  = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "환영해요! 😀 \n 이제 로그인하러 가볼까요?"
        label.textAlignment = .center
        label.font  = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .label
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MemberSignupCompleteionPopupView {
    private func addSubviews() {
        [
            titleLabel,
            messageLabel,
            doneButton
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            titleLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 140.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0),
            messageLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10.0),
            messageLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10.0),
            messageLabel.heightAnchor.constraint(equalToConstant: 60.0),
            
            doneButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 18.0),
            doneButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 100.0),
            doneButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }
}
