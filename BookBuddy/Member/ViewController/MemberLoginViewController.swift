//
//  MemberViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/26/23.
//

import Foundation
import UIKit
import AuthenticationServices
import RxSwift
import RxCocoa

final class MemberLoginViewController: UIViewController {
    private let memberLoginView = MemberLoginView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureMemberLoginView()
        setLayoutConstraintsMemberLoginView()
        bindSignupButton()
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
    
    private func bindSignupButton() {
        memberLoginView.startToEmailButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.present(MemberSignupWithEmailViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
