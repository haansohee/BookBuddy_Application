//
//  MemberSignupWithEmailViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 11/1/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class MemberSignupWithEmailViewController: UIViewController {
    private let memberSignupWithEmailView = MemberSignupWithEmailView()
    private let viewModel = MemberSignupWithEmailViewModel()
    private let disposeBag = DisposeBag()
    private var endEditingGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMemberSignupWithEmailView()
        setLayoutConstraintsMemberSignupWithEmailView()
        addEditingTapGesture()
        changeEmailAddressTextField()
        bindAll()
    }
}

extension MemberSignupWithEmailViewController {
    private func configureMemberSignupWithEmailView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(memberSignupWithEmailView)
        memberSignupWithEmailView.translatesAutoresizingMaskIntoConstraints = false
        [
            memberSignupWithEmailView.idTextField,
            memberSignupWithEmailView.emailTextField,
            memberSignupWithEmailView.emailAddressTextField,
            memberSignupWithEmailView.passwordTextField,
            memberSignupWithEmailView.passwordCheckTextField
        ].forEach { $0.delegate = self }
    }
    
    private func setLayoutConstraintsMemberSignupWithEmailView() {
        NSLayoutConstraint.activate([
            memberSignupWithEmailView.topAnchor.constraint(equalTo: self.view.topAnchor),
            memberSignupWithEmailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            memberSignupWithEmailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            memberSignupWithEmailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func addEditingTapGesture() {
        endEditingGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.endEditingGesture?.isEnabled = false
        guard let endEditingGesture = endEditingGesture else { return }
        self.view.addGestureRecognizer(endEditingGesture)
    }
    
    @objc private func endEditing() {
        self.view.endEditing(true)
    }
    
    private func changeEmailAddressTextField() {
        [
            memberSignupWithEmailView.naverEmailButton,
            memberSignupWithEmailView.googleEmailButton,
            memberSignupWithEmailView.icloudEmailButton,
            memberSignupWithEmailView.directInputButton,
            memberSignupWithEmailView.isSecureTextEntryButton
        ].forEach { $0.addTarget(self, action: #selector(emailButtonTap(_ :)), for: .touchUpInside)}
    }
    
    @objc private func emailButtonTap(_ sender: AnimationButton) {
        switch sender {
        case memberSignupWithEmailView.naverEmailButton:
            memberSignupWithEmailView.emailAddressTextField.text = MailAddress.naver.rawValue
        case memberSignupWithEmailView.googleEmailButton:
            memberSignupWithEmailView.emailAddressTextField.text = MailAddress.google.rawValue
            
        case memberSignupWithEmailView.icloudEmailButton:
            memberSignupWithEmailView.emailAddressTextField.text = MailAddress.icloud.rawValue
            
        case memberSignupWithEmailView.directInputButton:
            memberSignupWithEmailView.emailAddressTextField.placeholder = "직접 입력"
            memberSignupWithEmailView.emailAddressTextField.isEnabled = true
            
        case memberSignupWithEmailView.isSecureTextEntryButton:
            if memberSignupWithEmailView.passwordTextField.isSecureTextEntry {
                memberSignupWithEmailView.passwordTextField.isSecureTextEntry = false
                memberSignupWithEmailView.passwordCheckTextField.isSecureTextEntry = false
            } else {
                memberSignupWithEmailView.passwordTextField.isSecureTextEntry = true
                memberSignupWithEmailView.passwordCheckTextField.isSecureTextEntry = true
            }
            
        default:
            memberSignupWithEmailView.emailAddressTextField.placeholder = "직접 입력"
        }
    }
    
    private func bindAll() {
        bindSignupButton()
        bindIsAuthed()
    }
    
    
    private func bindSignupButton() {
        memberSignupWithEmailView.emailAuthenticationButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let email = self?.memberSignupWithEmailView.emailTextField.text,
                      let address = self?.memberSignupWithEmailView.emailAddressTextField.text
                else { return }
                self?.viewModel.emailAuthentication(email: email, address: address)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsAuthed() {
        viewModel.isAuthed
            .subscribe(onNext: { [weak self ] isAuthed in
                guard isAuthed else { return }
                self?.memberSignupWithEmailView.checkEmailLabel.text = "메일이 전송됐어요. 확인해 주세요. \n 메일이 안 왔나요? 이메일이 올바른지 확인해 보세요."
            })
            .disposed(by: disposeBag)
    }
}

extension MemberSignupWithEmailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.endEditingGesture?.isEnabled = true
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.endEditingGesture?.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
