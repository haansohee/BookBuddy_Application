//
//  MemberViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/26/23.
//

import Foundation
import AuthenticationServices
import UIKit
import RxSwift
import RxCocoa

final class MemberSigninViewController: UIViewController {
    private let memberLoginView = MemberSigninView()
    private let disposeBag = DisposeBag()
    private var endEditingGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureMemberLoginView()
        setLayoutConstraintsMemberSigninView()
        bindAll()
        addEditingTapGesture()
    }
}

extension MemberSigninViewController {
    private func configureMemberLoginView() {
        self.view.addSubview(memberLoginView)
        memberLoginView.translatesAutoresizingMaskIntoConstraints = false
        memberLoginView.idTextField.delegate = self
        memberLoginView.passwordTextField.delegate = self
    }
    
    private func setLayoutConstraintsMemberSigninView() {
        NSLayoutConstraint.activate([
            memberLoginView.topAnchor.constraint(equalTo: self.view.topAnchor),
            memberLoginView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            memberLoginView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            memberLoginView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func bindAll() {
        bindSignupButton()
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
    
    private func bindSignupButton() {
        memberLoginView.startToEmailButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.pushViewController(MemberSignupWithEmailViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAppleLoginButton() {
        
    }
    
    @objc private func handleAuthorizationAppleIDButtonPress() {
        let request =  ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension MemberSigninViewController: UITextFieldDelegate {
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

extension MemberSigninViewController: ASAuthorizationControllerDelegate {
    
}

extension MemberSigninViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
}
