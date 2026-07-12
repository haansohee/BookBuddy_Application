//
//  MemberSignupCompleteionPopupViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 11/22/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

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
        self.view.addSubview(popupView)
        popupView.doneButton.addTarget(self, action: #selector(tapDoneButton), for: .touchUpInside)
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

    @objc private func tapDoneButton() {
        self.dismiss(animated: true)
    }
            
}

extension MemberSignupCompleteionPopupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let nickname = textField.text,
              let newRange = Range(range, in: nickname) else { return true }
        
        let inputNickname = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let newNickname = nickname.replacingCharacters(in: newRange, with: inputNickname)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if newNickname.isValidNickname {
            popupView.doneButton.isEnabled = true
            popupView.setTitlLabel("😄")
            popupView.doneButton.backgroundColor = .systemBackground
        } else {
            popupView.doneButton.isEnabled = false
            popupView.setTitlLabel("영어, 숫자, 언더바(_)만 사용 가능해요. \n 8~16자로 입력해 주세요.")
            popupView.doneButton.backgroundColor = .lightGray
        }
        return true
    }
           
}
