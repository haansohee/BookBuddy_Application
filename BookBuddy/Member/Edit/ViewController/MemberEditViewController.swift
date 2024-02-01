//
//  MemberEditViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 11/24/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Photos

final class MemberEditViewController: UIViewController {
    private let memberEditView = MemberEditView()
    private let disposeBag = DisposeBag()
    private let signupVieWModel = MemberSignupWithEmailViewModel()
    private let viewModel = MemberEditViewModel()
    private let keyboardNotification = KeyboardNotification()
    private var endEditingGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        configureMemberEditView()
        setLayoutConstraints()
        addEditingTapGesture()
        keyboardNotification.scrollViewSetKeyboardNotification(memberEditView)
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurePasswordTextField()
        configureNicknameTextField()
        settingMemberProfileImage()
    }
}

extension MemberEditViewController {
    private func addSubview() {
        self.view.addSubview(memberEditView)
    }
    
    private func configureMemberEditView() {
        self.view.backgroundColor = .systemBackground
        memberEditView.translatesAutoresizingMaskIntoConstraints = false
        memberEditView.nicknameTextField.delegate = self
        memberEditView.passwordTextField.delegate = self
        memberEditView.imagePickerView.delegate = self
        memberEditView.imagePickerView.sourceType = .photoLibrary
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            memberEditView.topAnchor.constraint(equalTo: self.view.topAnchor),
            memberEditView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            memberEditView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            memberEditView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func settingMemberProfileImage() {
        guard let profileData = UserDefaults.standard.data(forKey: UserDefaultsForkey.profile.rawValue) else {
            DispatchQueue.main.async { [weak self] in
                self?.memberEditView.profileImageView.image = UIImage(systemName: "person")
            }
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.memberEditView.profileImageView.image = UIImage(data: profileData)
        }
    }
    
    private func profileUpdateActionSheet() {
        let actionSheetController = UIAlertController(title: "프로필 사진 변경하기", message: "사진을 변경할 건가요?", preferredStyle: .actionSheet)
        
        let updateAction = UIAlertAction(title: "앨범에서 선택하기", style: .default) { [weak self] _ in
            guard let imagePickerViewController = self?.memberEditView.imagePickerView else { return }
            imagePickerViewController.allowsEditing = true
            DispatchQueue.main.async {
                self?.present(imagePickerViewController, animated: true)
            }
        }
        let deleteAction = UIAlertAction(title: "현재 사진 삭제하기", style: .default) { [weak self] _ in
            guard let nickname = UserDefaults.standard.string(forKey: UserDefaultsForkey.nickname.rawValue) else { return }
            DispatchQueue.main.async {
                self?.memberEditView.profileImageView.image = UIImage(systemName: "person")
            }
            self?.viewModel.deleteMemberProfile(nickname)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheetController.addAction(updateAction)
        actionSheetController.addAction(deleteAction)
        actionSheetController.addAction(cancelAction)
        
        present(actionSheetController, animated: true)
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
    
    private func successEdit(message: String) {
        let alertActionController = UIAlertController(title: "변경 완료!", message: "\(message)가 변경되었어요!", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .default)
        alertActionController.addAction(doneAction)
        present(alertActionController, animated: true)
    }
    
    private func bindAll() {
        bindSignoutButton()
        bindProfileUpdateButton()
        bindNicknameEditButton()
        bindNicknameDuplicateButton()
        bindIsProfileDeleted()
        bindIsNickanmeUpdated()
        bindIsChecked()
        bindPasswordEditButton()
        bindIsPasswordUpdated()
    }
    
    private func bindProfileUpdateButton() {
        memberEditView.profileUpdateButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.profileUpdateActionSheet()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNicknameDuplicateButton() {
        memberEditView.nicknameDuplicateButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let nickname = self?.memberEditView.nicknameTextField.text else { return }
                if nickname.isEmpty { return }
                self?.signupVieWModel.nicknameDuplicateCheck(nickname: nickname)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNicknameEditButton() {
        memberEditView.nicknameEditButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let nickname = UserDefaults.standard.string(forKey: UserDefaultsForkey.nickname.rawValue),
                      let newNickname = self?.memberEditView.nicknameTextField.text else { return }
                if newNickname.isEmpty { return }
                let memberNicknameUpdateInformation = MemberNicknameUpdateInformation(newNickname: newNickname, nickname: nickname)
                self?.viewModel.updateMemberNickname(memberNicknameUpdateInformation)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindPasswordEditButton() {
        memberEditView.passwordEditButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let nickname = UserDefaults.standard.string(forKey: UserDefaultsForkey.nickname.rawValue),
                      let newPassword = self?.memberEditView.passwordTextField.text else { return }
                if newPassword.isEmpty { return }
                let memberPasswordUpdateInformation = MemberPasswordUpdateInformation(newPassword: newPassword, nickname: nickname)
                self?.viewModel.updateMemberPassword(memberPasswordUpdateInformation)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSignoutButton() {
        memberEditView.signoutButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.nickname.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.password.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.email.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.profile.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.appleToken.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.favorite.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.userID.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.recentSearch.rawValue)
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsProfileDeleted() {
        viewModel.isProfileDeleted
            .subscribe(onNext: { isProfileDeleted in
                guard isProfileDeleted else { return }
                UserDefaults.standard.removeObject(forKey: UserDefaultsForkey.profile.rawValue)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsNickanmeUpdated() {
        viewModel.isNicknameUpdated
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isNicknameUpdated in
                guard isNicknameUpdated else { return }
                guard let nickname = self?.memberEditView.nicknameTextField.text else { return }
                if nickname.isEmpty { return }
                self?.memberEditView.nicknameTextField.placeholder = nickname
                self?.memberEditView.nicknameTextField.text = nil
                self?.memberEditView.nicknameDuplicateIdLabel.text = "아이디는 영어, 숫자, 언더바(_)만 사용 가능해요. \n 8~16자로 입력해 주세요."
                [
                    self?.memberEditView.nicknameDuplicateButton,
                    self?.memberEditView.nicknameEditButton
                ].forEach {
                    $0?.backgroundColor = .lightGray
                    $0?.isEnabled = false
                }
                self?.successEdit(message: "아이디")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsPasswordUpdated() {
        viewModel.isPasswordUpdated
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isPasswordUpdated in
                guard isPasswordUpdated else { return }
                self?.memberEditView.passwordTextField.text = nil
                self?.memberEditView.passwordCheckLabel.text = "비밀번호는 영어 대소문자, 숫자, 특수문자를 조합해 주세요. \n 8~30자로 입력해 주세요"
                self?.memberEditView.passwordEditButton.backgroundColor = .lightGray
                self?.memberEditView.passwordEditButton.isEnabled = false
                self?.successEdit(message: "비밀번호")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsChecked() {
        signupVieWModel.isChecked
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isChecked in
                guard isChecked else { return }
                self?.memberEditView.nicknameDuplicateIdLabel.text = "사용 가능한 닉네임이에요."
                self?.memberEditView.nicknameEditButton.isEnabled = true
            })
            .disposed(by: disposeBag)
    }
    
    private func configurePasswordTextField() {
        if UserDefaults.standard.string(forKey: UserDefaultsForkey.appleToken.rawValue) != nil {
            memberEditView.passwordTextField.isHidden = true
            memberEditView.passwordEditButton.isHidden = true
        } else {
            memberEditView.passwordTextField.isHidden = false
            memberEditView.passwordEditButton.isHidden = false
        }
    }
    
    private func configureNicknameTextField() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaultsForkey.nickname.rawValue) else { return }
        memberEditView.nicknameTextField.placeholder = nickname
    }
}

extension MemberEditViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.endEditingGesture?.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.endEditingGesture?.isEnabled = false
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case memberEditView.nicknameTextField:
            guard let nickname = textField.text,
                  let newRange = Range(range, in: nickname) else { return true }
            let inputNickname = string.trimmingCharacters(in: .whitespacesAndNewlines)
            let newNickname = nickname.replacingCharacters(in: newRange, with: inputNickname).trimmingCharacters(in: .whitespacesAndNewlines)
            
            if newNickname.isValidNickname {
                memberEditView.nicknameDuplicateButton.isEnabled = true
                memberEditView.nicknameDuplicateButton.backgroundColor = .systemGreen
                memberEditView.nicknameDuplicateIdLabel.text = ""
            } else {
                memberEditView.nicknameDuplicateButton.isEnabled = false
                memberEditView.nicknameDuplicateButton.backgroundColor = .lightGray
                memberEditView.nicknameDuplicateIdLabel.text = "아이디는 영어, 숫자, 언더바(_)만 사용 가능해요. \n 8~16자로 입력해 주세요."
            }
            return true
                  
        case memberEditView.passwordTextField:
            guard let password = textField.text,
                  let newRange = Range(range, in: password) else { return true }
            let inputPassword = string.trimmingCharacters(in: .whitespacesAndNewlines)
            let newPassword = password.replacingCharacters(in: newRange, with: inputPassword).trimmingCharacters(in: .whitespacesAndNewlines)
            if newPassword.isValidPassword {
                memberEditView.passwordEditButton.isEnabled = true
                memberEditView.passwordEditButton.backgroundColor = .systemGreen
                memberEditView.passwordCheckLabel.text = ""
            } else {
                memberEditView.passwordEditButton.isEnabled = false
                memberEditView.passwordEditButton.backgroundColor = .lightGray
                memberEditView.passwordCheckLabel.text = "비밀번호는 영어 대소문자, 숫자, 특수문자를 조합해 주세요. \n 8~30자로 입력해 주세요"
            }
            return true
            
        default: return true
        }
    }
}

extension MemberEditViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            memberEditView.profileImageView.image = editedImage
            if let imageData = editedImage.pngData(),
               let nickname = UserDefaults.standard.string(forKey: UserDefaultsForkey.nickname.rawValue) {
                UserDefaults.standard.set(imageData, forKey: UserDefaultsForkey.profile.rawValue)
                let profileInformation = MemberUpdateInformation(nickname: nickname, profile: imageData)
                viewModel.updateMemberInformation(profileInformation)
            }
            
        } else {
            print("ERROR")
        }
        dismiss(animated: true)
    }
}

extension MemberEditViewController: UINavigationControllerDelegate {
    
}
