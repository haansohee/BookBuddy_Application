//
//  MemberSigninWithAppleViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 11/24/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class MemberSigninWithAppleViewController: UIViewController {
    private let memberSigninWithAppleView =  MemberSigninWithAppleView()
    private let viewModel = MemberSigninWithAppleViewModel()
    private let disposeBag = DisposeBag()
    private var endEditingGesture: UITapGestureRecognizer?
    
    init(email: String, appleToken: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.setAppleEmail(email)
        viewModel.setAppleToken(appleToken)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMemberSigninWithAppleView()
        setLayoutConstraintsMemberSigninWithAppleView()
        addEditingTapGesture()
        bindAll()
    }
}

extension MemberSigninWithAppleViewController {
    private func configureMemberSigninWithAppleView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(memberSigninWithAppleView)
        
        memberSigninWithAppleView.translatesAutoresizingMaskIntoConstraints = false
        memberSigninWithAppleView.inputNicknameTextField.delegate = self
    }
    
    private func setLayoutConstraintsMemberSigninWithAppleView() {
        NSLayoutConstraint.activate([
            memberSigninWithAppleView.topAnchor.constraint(equalTo: self.view.topAnchor),
            memberSigninWithAppleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            memberSigninWithAppleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            memberSigninWithAppleView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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
    
    private func bindAll() {
        bindDoneButton()
        bindNicknameDuplicateCheckButton()
        bindIsCompleted()
        bindIsChecked()
    }
    
    private func bindDoneButton() {
        memberSigninWithAppleView.doneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let nickname = self?.memberSigninWithAppleView.inputNicknameTextField.text,
                      let email = self?.viewModel.appleEmail,
                      let appleToken = self?.viewModel.appleToken else { return }
                if nickname == "" { return }

                self?.viewModel.appleSignup(with: SigninWithAppleInformation(nickname: nickname, email: email, appleToken: appleToken))
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNicknameDuplicateCheckButton() {
        memberSigninWithAppleView.nicknameDuplicateCheckButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let nickname = self?.memberSigninWithAppleView.inputNicknameTextField.text else { return }
                if nickname == "" { return }
                self?.viewModel.nicknameDuplicateCheck(nickname: nickname)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsCompleted() {
        viewModel.isCompleted
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isCompleted in
                if isCompleted {
                    guard let nickname = self?.memberSigninWithAppleView.inputNicknameTextField.text,
                          let email = self?.viewModel.appleEmail,
                          let appleToken = self?.viewModel.appleToken,
                          let userID = self?.viewModel.appleUserID else { return }
                    
                    UserDefaults.standard.setValue(nickname, forKey: UserDefaultsForkey.nickname.rawValue)
                    UserDefaults.standard.setValue(email, forKey: UserDefaultsForkey.email.rawValue)
                    UserDefaults.standard.setValue(appleToken, forKey: UserDefaultsForkey.appleToken.rawValue)
                    UserDefaults.standard.setValue(userID, forKey: UserDefaultsForkey.userID.rawValue)
                    
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsChecked() {
        viewModel.isChecked
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isChecked in
                if isChecked {
                    self?.memberSigninWithAppleView.titleLabel.text = "사용 가능한 아이디입니다."
                    self?.memberSigninWithAppleView.doneButton.isEnabled = true
                    self?.memberSigninWithAppleView.doneButton.backgroundColor = .systemGreen
                } else {
                    self?.memberSigninWithAppleView.titleLabel.text = "중복된 아이디입니다."
                    self?.memberSigninWithAppleView.doneButton.isEnabled = false
                    self?.memberSigninWithAppleView.doneButton.backgroundColor = .lightGray
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MemberSigninWithAppleViewController: UITextFieldDelegate {
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
        guard let nickname = textField.text,
              let newRange = Range(range, in: nickname) else { return true }
        let inputNickname = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let newNickname = nickname.replacingCharacters(in: newRange, with: inputNickname)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if newNickname.isValidNickname {
            memberSigninWithAppleView.nicknameDuplicateCheckButton.isEnabled = true
            memberSigninWithAppleView.nicknameDuplicateCheckButton.backgroundColor = .systemGreen
            memberSigninWithAppleView.titleLabel.text = "😀"
        } else {
            memberSigninWithAppleView.nicknameDuplicateCheckButton.isEnabled = false
            memberSigninWithAppleView.nicknameDuplicateCheckButton.backgroundColor = .lightGray
            memberSigninWithAppleView.titleLabel.text = "영어, 숫자, 언더바(_)만 사용 가능해요. \n 8~16자로 입력해 주세요."
        }
        return true
    }
}
