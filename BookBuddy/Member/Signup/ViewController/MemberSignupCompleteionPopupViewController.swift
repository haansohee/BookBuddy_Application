//
//  MemberSignupCompleteionPopupViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 11/22/23.
//

import Foundation
import UIKit

final class MemberSignupCompleteionPopupViewController: UIViewController {
    private let popupView = MemberSignupCompleteionPopupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMemberSignupCompleteionPopupView()
        setLayoutConstraintsMemberSignupWithEmailView()
    }
}

extension MemberSignupCompleteionPopupViewController {
    private func configureMemberSignupCompleteionPopupView() {
        self.view.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        self.view.isOpaque = false
        self.view.addSubview(popupView)
        popupView.doneButton.addTarget(self, action: #selector(doneButtonTap), for: .touchUpInside)
        popupView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setLayoutConstraintsMemberSignupWithEmailView() {
        NSLayoutConstraint.activate([
            popupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            popupView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            popupView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            popupView.heightAnchor.constraint(equalToConstant: 200.0)
        ])
        
        popupView.layer.cornerRadius = 5.0
    }
    
    @objc private func doneButtonTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
