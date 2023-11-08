//
//  MemberSignupWithEmailViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 11/1/23.
//

import Foundation
import UIKit

final class MemberSignupWithEmailViewController: UIViewController {
    private let memberSignupWithEmailView = MemberSignupWithEmailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMemberSignupWithEmailView()
        setLayoutConstraintsMemberSignupWithEmailView()
    }
}

extension MemberSignupWithEmailViewController {
    private func configureMemberSignupWithEmailView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(memberSignupWithEmailView)
        memberSignupWithEmailView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setLayoutConstraintsMemberSignupWithEmailView() {
        NSLayoutConstraint.activate([
            memberSignupWithEmailView.topAnchor.constraint(equalTo: self.view.topAnchor),
            memberSignupWithEmailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            memberSignupWithEmailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            memberSignupWithEmailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
