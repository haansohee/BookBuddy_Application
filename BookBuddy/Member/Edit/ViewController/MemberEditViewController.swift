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
    private let viewModel = MemberEditViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        configureMemberEditView()
        setLayoutConstraints()
        configurePasswordTextField()
        configureNicknameTextField()
        bindSignoutButton()
        bindProfileUpdateButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        guard let profileData = UserDefaults.standard.data(forKey: "profile") else {
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
            DispatchQueue.main.async {
                self?.memberEditView.profileImageView.image = UIImage(systemName: "person")
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheetController.addAction(updateAction)
        actionSheetController.addAction(deleteAction)
        actionSheetController.addAction(cancelAction)
        
        present(actionSheetController, animated: true)
    }
    
    private func bindProfileUpdateButton() {
        memberEditView.profileUpdateButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.profileUpdateActionSheet()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSignoutButton() {
        memberEditView.signoutButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                UserDefaults.standard.removeObject(forKey: "nickname")
                UserDefaults.standard.removeObject(forKey: "password")
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "profile")
                UserDefaults.standard.removeObject(forKey: "appleToken")
                
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configurePasswordTextField() {
        if UserDefaults.standard.string(forKey: "appleToken") != nil {
            DispatchQueue.main.async { [weak self] in
                self?.memberEditView.passwordTextField.isHidden = true
                self?.memberEditView.passwordEditButton.isHidden = true
            }
        } else {
            guard let password = UserDefaults.standard.string(forKey: "password") else { return }
            DispatchQueue.main.async { [weak self] in
                self?.memberEditView.passwordTextField.placeholder = password
                self?.memberEditView.passwordTextField.isHidden = false
                self?.memberEditView.passwordEditButton.isHidden = false
            }
        }
    }
    
    private func configureNicknameTextField() {
        guard let nickname = UserDefaults.standard.string(forKey: "nickname") else { return }
        DispatchQueue.main.async { [weak self] in
            self?.memberEditView.nicknameTextField.placeholder = nickname
        }
    }
}

extension MemberEditViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            memberEditView.profileImageView.image = editedImage
            if let imageData = editedImage.pngData(),
               let nickname = UserDefaults.standard.string(forKey: "nickname") {
                UserDefaults.standard.set(imageData, forKey: "profile")
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
