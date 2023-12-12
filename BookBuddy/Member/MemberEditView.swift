//
//  MemberEditView.swift
//  BookBuddy
//
//  Created by 한소희 on 11/24/23.
//

import UIKit

final class MemberEditView: UIView {
    let signoutButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .systemBackground
        
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
        addSubview(signoutButton)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            signoutButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signoutButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
