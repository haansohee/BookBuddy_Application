//
//  MemberViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/26/23.
//

import Foundation
import UIKit

final class MemberLoginViewController: UIViewController {
    private let memberLoginView = MemberLoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureMemberLoginView()
        setLayoutConstraintsMemberLoginView()
    }
}

extension MemberLoginViewController {
    private func configureMemberLoginView() {
        self.view.addSubview(memberLoginView)
        memberLoginView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setLayoutConstraintsMemberLoginView() {
        NSLayoutConstraint.activate([
            memberLoginView.topAnchor.constraint(equalTo: self.view.topAnchor),
            memberLoginView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            memberLoginView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            memberLoginView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
