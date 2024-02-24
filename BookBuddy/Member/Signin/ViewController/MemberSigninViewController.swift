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
    private let memberSigninView = MemberSigninView()
    private let viewModel = MemberSigninViewModel()
    private let signWithAppleViewModel = MemberSigninWithAppleViewModel()
    private let disposeBag = DisposeBag()
    private var endEditingGesture: UITapGestureRecognizer?
    private let activityIndicatorViewController = ActivityIndicatorViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUserDefaults()
    }
    
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
        self.view.addSubview(memberSigninView)
        memberSigninView.translatesAutoresizingMaskIntoConstraints = false
        memberSigninView.idTextField.delegate = self
        memberSigninView.passwordTextField.delegate = self
        memberSigninView.appleLoginButton.addTarget(self, action: #selector(tapAppleSigninButton), for: .touchUpInside)
    }
    
    private func setLayoutConstraintsMemberSigninView() {
        NSLayoutConstraint.activate([
            memberSigninView.topAnchor.constraint(equalTo: self.view.topAnchor),
            memberSigninView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            memberSigninView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            memberSigninView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func checkUserDefaults() {
        if (UserDefaults.standard.string(forKey: UserDefaultsForkey.appleToken.rawValue) != nil) &&
            (UserDefaults.standard.string(forKey: UserDefaultsForkey.email.rawValue) != nil) &&
            (UserDefaults.standard.string(forKey: UserDefaultsForkey.nickname.rawValue) != nil) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func bindAll() {
        bindSignupButton()
        bindSinginButton()
        bindIsSigned()
        bindIsExistence()
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
    
    @objc private func tapAppleSigninButton() {
        let request =  ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func bindSignupButton() {
        memberSigninView.startToEmailButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.pushViewController(MemberSignupWithEmailViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSinginButton() {
        memberSigninView.signinButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let nickname = self?.memberSigninView.idTextField.text,
                      let password = self?.memberSigninView.passwordTextField.text,
                      let button = self?.memberSigninView.signinButton else { return }
                if (nickname == "") || (password == "") { return }
                self?.viewModel.signin(nickname: nickname, password: password)
                self?.activityIndicatorViewController.startButtonTapped(button)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsSigned() {
        viewModel.isSigned
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isSigned in
                guard let button = self?.memberSigninView.signinButton else { return }
                if isSigned {
                    self?.activityIndicatorViewController.stopButtonTapped(button, buttonTitle: "Sign in")
                    let rootViewController = MainTabBarController()
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                    sceneDelegate.changeRootViewController(rootViewController, animated: false)
                } else {
                    self?.activityIndicatorViewController.stopButtonTapped(button, buttonTitle: "Sign in")
                    self?.memberSigninView.idTextField.text = ""
                    self?.memberSigninView.idTextField.attributedPlaceholder = NSAttributedString(string: "아이디 혹은 비밀번호가 일치하지 않아요!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
                    self?.memberSigninView.idTextField.layer.borderColor = UIColor.systemRed.cgColor
                    self?.memberSigninView.passwordTextField.layer.borderColor = UIColor.systemRed.cgColor
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsExistence() {
        signWithAppleViewModel.isExistence
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isExistence in
                if isExistence {
                    let rootViewController = MainTabBarController()
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                    sceneDelegate.changeRootViewController(rootViewController, animated: false)
                } else {
                    guard let email = self?.signWithAppleViewModel.appleEmail,
                          let appleToken = self?.signWithAppleViewModel.appleToken else { return }
                    self?.navigationController?.pushViewController(MemberSigninWithAppleViewController(email: email, appleToken: appleToken), animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MemberSigninViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.endEditingGesture?.isEnabled = true
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        
        if textField == memberSigninView.idTextField {
            textField.attributedPlaceholder = NSAttributedString(string: "ID", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        }
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
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = credential.user
            guard let identityToken = credential.identityToken,
                  let appleToken = String(data: identityToken, encoding: .utf8)
            else { return }

            let provider = ASAuthorizationAppleIDProvider()
            provider.getCredentialState(forUserID: userIdentifier) { credentialState, error in
                switch credentialState {
                case .revoked:
                    print("revoked")
                    
                case .authorized:
                    if let email = credential.email {
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(MemberSigninWithAppleViewController(email: email, appleToken: appleToken), animated: true)
                        }
                    } else {
                        self.signWithAppleViewModel.appleSignin(appleToken: appleToken)
                    }
                    
                case .notFound:
                    print("notfount")
                    
                case .transferred:
                    print("transferred")

                default:
                    break
                }
                
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("ERROR: \(error)")
    }
}

extension MemberSigninViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
