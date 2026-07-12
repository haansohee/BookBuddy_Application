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
        setKeyboardNotification()
        addEditingTapGesture()
        changeEmailAddressTextField()
        bindAll()
    }
}

extension MemberSignupWithEmailViewController {
    private func configureMemberSignupWithEmailView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(memberSignupWithEmailView)
        self.navigationController?.navigationBar.tintColor = .systemGreen
        navigationItem.title = "회원가입"
        memberSignupWithEmailView.translatesAutoresizingMaskIntoConstraints = false
        [
            memberSignupWithEmailView.nickNameTextField,
            memberSignupWithEmailView.emailTextField,
            memberSignupWithEmailView.emailAddressTextField,
            memberSignupWithEmailView.authCodeTextField,
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
    
    private func setKeyboardNotification() {
        let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
        
        keyboardWillShow
            .asDriver(onErrorRecover: { _ in .never() })
            .drive(onNext: { [weak self] notification in
                self?.handleKeyboardWillShow(notification)
            })
            .disposed(by: disposeBag)
        
        keyboardWillHide
            .asDriver(onErrorRecover: { _ in .never() })
            .drive(onNext: { [weak self] notification in
                self?.handleKeyboardWillHide(notification)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInset = UIEdgeInsets(top: 0.0,
                                        left: 0.0,
                                        bottom: (keyboardFrame.size.height)
                                        , right: 0.0)
        memberSignupWithEmailView.contentInset = contentInset
        memberSignupWithEmailView.scrollIndicatorInsets = contentInset
    }
    
    private func handleKeyboardWillHide(_ notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        memberSignupWithEmailView.contentInset = contentInset
        memberSignupWithEmailView.scrollIndicatorInsets = contentInset
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
        bindDuplicatedIdCheckButton()
        bindEmailAuthenticationButton()
        bindCodeAuthenticationButton()
        bindSignupButton()
        bindIsChecked()
        bindIsAuthed()
        bindIsCompared()
        bindIsCompleted()
    }
    
    private func bindDuplicatedIdCheckButton() {
        memberSignupWithEmailView.duplicateIdCheckButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let nickname = self?.memberSignupWithEmailView.nickNameTextField.text else { return }
                if nickname == "" { return }
                self?.viewModel.nicknameDuplicateCheck(nickname: nickname)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindEmailAuthenticationButton() {
        memberSignupWithEmailView.emailAuthenticationButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let email = self?.memberSignupWithEmailView.emailTextField.text,
                      let address = self?.memberSignupWithEmailView.emailAddressTextField.text
                else { return }
                if (email == "") || (address == "") { return }
                DispatchQueue.main.async {
                    self?.memberSignupWithEmailView.checkEmailLabel.text = "메일을 보내는 중이에요."
                }
                self?.viewModel.emailDuplicateCheck(email: email, address: address)
                
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCodeAuthenticationButton() {
        memberSignupWithEmailView.codeAuthenticationButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let code = self?.memberSignupWithEmailView.authCodeTextField.text else { return }
                if code == "" { return }
                self?.viewModel.compareCode(inputCode: code)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSignupButton() {
        memberSignupWithEmailView.signupButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let nickname = self?.memberSignupWithEmailView.nickNameTextField.text,
                      let email = self?.memberSignupWithEmailView.emailTextField.text,
                      let address = self?.memberSignupWithEmailView.emailAddressTextField.text,
                      let password = self?.memberSignupWithEmailView.passwordTextField.text,
                      let rePassword = self?.memberSignupWithEmailView.passwordCheckTextField.text,
                      let isDone = self?.viewModel.isDone else { return }
                
                if (nickname == "")
                    || (email == "")
                    || (address == "")
                    || (password == "")
                    || (rePassword == "") {
                    DispatchQueue.main.async {
                        self?.memberSignupWithEmailView.passwordCheckLabel.text = "아이디, 이메일, 비밀번호를 입력하세요! "
                    }
                    return
                }
                    
                if isDone {
                    let signupMemberInformation = SignupMemberInformation(nickname: nickname, email: "\(email)@\(address)", password: password)
                    self?.viewModel.signup(with: signupMemberInformation)
                } else {
                    DispatchQueue.main.async {
                        self?.memberSignupWithEmailView.passwordCheckLabel.text = "아이디 중복 확인과 이메일 인증을 진행해 주세요."
                    }
                    return
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsChecked() {
        viewModel.isChecked
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isChecked in
                if isChecked {
                    self?.memberSignupWithEmailView.duplicateIdLabel.text = "사용 가능한 아이디입니다. 😄"
                } else {
                    self?.memberSignupWithEmailView.duplicateIdLabel.text = "중복된 아이디입니다. 😭"
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsAuthed() {
        viewModel.isAuthed
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isAuthed in
                if isAuthed {
                    self?.memberSignupWithEmailView.checkEmailLabel.text = "메일이 전송됐어요. 확인해 주세요. \n 메일이 안 왔나요? 이메일이 올바른지 확인해 보세요."
                } else {
                    self?.memberSignupWithEmailView.checkEmailLabel.text = "해당 이메일은 이미 가입되어 있어요. \n 다른 이메일을 사용해 주세요."
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsCompared() {
        viewModel.isCompared
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isCompared in
                if isCompared {
                    self?.memberSignupWithEmailView.checkEmailLabel.text = "인증이 완료되었습니다."
                } else {
                    self?.memberSignupWithEmailView.checkEmailLabel.text = "인증번호가 일치하지 않아요. \n 올바른 인증 코드를 입력하세요."
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsCompleted() {
        viewModel.isCompleted
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isCompleted in
                if isCompleted {
                    self?.present(MemberSignupCompleteionPopupViewController(), animated: true)
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    self?.memberSignupWithEmailView.passwordCheckLabel.text = "네트워크가 원활하지 않아요. \n 잠시후에 다시 시도해 주세요."
                }
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case memberSignupWithEmailView.nickNameTextField:
            guard let nickname = textField.text,
                  let newRange = Range(range, in: nickname) else { return true }
            
            let inputNickname = string.trimmingCharacters(in: .whitespacesAndNewlines)
            let newNickname = nickname.replacingCharacters(in: newRange, with: inputNickname)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if newNickname.isValidNickname {
                memberSignupWithEmailView.duplicateIdCheckButton.isEnabled = true
                memberSignupWithEmailView.duplicateIdCheckButton.backgroundColor = .systemGreen
                memberSignupWithEmailView.duplicateIdLabel.text = ""
            } else {
                memberSignupWithEmailView.duplicateIdCheckButton.isEnabled = false
                memberSignupWithEmailView.duplicateIdCheckButton.backgroundColor = .lightGray
                memberSignupWithEmailView.duplicateIdLabel.text = "영어, 숫자, 언더바(_)만 사용 가능해요. \n 8~16자로 입력해 주세요."
            }
            return true
            
        case memberSignupWithEmailView.passwordTextField:
            guard let password = textField.text,
                  let newRange = Range(range, in: password) else { return true }
            
            let inputPassword = string.trimmingCharacters(in: .whitespacesAndNewlines)
            let newPassword = password.replacingCharacters(in: newRange, with: inputPassword)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if newPassword.isValidPassword {
                memberSignupWithEmailView.passwordCheckTextField.isEnabled = true
                memberSignupWithEmailView.passwordCheckLabel.text = ""
            } else {
                memberSignupWithEmailView.passwordCheckTextField.isEnabled = false
                memberSignupWithEmailView.passwordCheckLabel.text = "영어 대소문자, 숫자, 특수문자를 조합해 주세요. \n 8~30자로 입력해 주세요."
            }
            return true
            
        case memberSignupWithEmailView.passwordCheckTextField:
            guard let rePassword = textField.text,
                  let newRange = Range(range, in: rePassword),
                  let password = memberSignupWithEmailView.passwordTextField.text else { return true }
            
            let inputPassword = string.trimmingCharacters(in: .whitespacesAndNewlines)
            let newPassword = rePassword.replacingCharacters(in: newRange, with: inputPassword)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if newPassword == password {
                self.viewModel.passwordIsValid(isDone: true)
                memberSignupWithEmailView.passwordCheckLabel.text = ""
            } else {
                self.viewModel.passwordIsValid(isDone: false)
                memberSignupWithEmailView.passwordCheckLabel.text = "비밀번호가 일치하지 않아요."
                
            }
            return true
            
        default:
            return true
        }
    }
   
}
