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

final class MemberEditViewController: UIViewController {
    private let memberEditView = MemberEditView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setLayoutConstraints()
        bindSignoutButton()
    }
}

extension MemberEditViewController {
    private func addSubview() {
        self.view.addSubview(memberEditView)
        self.view.backgroundColor = .systemBackground
        memberEditView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            memberEditView.topAnchor.constraint(equalTo: self.view.topAnchor),
            memberEditView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            memberEditView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            memberEditView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func bindSignoutButton() {
        memberEditView.signoutButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                UserDefaults.standard.removeObject(forKey: "nickname")
                UserDefaults.standard.removeObject(forKey: "password")
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "appleToken")
                
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
