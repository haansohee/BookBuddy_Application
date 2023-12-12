//
//  MemberViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/28/23.

//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class MemberViewController: UIViewController {
    enum ViewType {
        case notMember
        case member
    }
    
    private let memberView = MemberView()
    private let notMemberView = NotMemberView()
    private var viewType: ViewType
    private var memberInformation: SignupMemberInformation?
    private let disposeBag = DisposeBag()
    
    init(memberInformation: SignupMemberInformation? = nil) {
        viewType = memberInformation != nil ? .member : .notMember
        self.memberInformation = memberInformation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkMember()
        configureMemberView()
        setLayoutConstraintsMemberView()
    }
}

extension MemberViewController {
    private func configureMemberView() {
        switch viewType {
        case .member:
            memberView.translatesAutoresizingMaskIntoConstraints = false
            memberView.boardCollectionView.dataSource = self
            memberView.boardCollectionView.delegate = self
            
        case .notMember:
            notMemberView.translatesAutoresizingMaskIntoConstraints = false
        }
}
    
    private func setLayoutConstraintsMemberView() {
        switch viewType {
        case .member:
            self.view.addSubview(memberView)
            notMemberView.removeFromSuperview()
            NSLayoutConstraint.activate([
                memberView.topAnchor.constraint(equalTo: self.view.topAnchor),
                memberView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                memberView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                memberView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            if let nickname = memberInformation?.nickname {
                memberView.setNameLabel(nickname)
            }
            
        case .notMember:
            self.view.addSubview(notMemberView)
            memberView.removeFromSuperview()
            NSLayoutConstraint.activate([
                notMemberView.topAnchor.constraint(equalTo: self.view.topAnchor),
                notMemberView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                notMemberView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                notMemberView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }
    }
    
    private func checkMember(){
        guard let nickname = UserDefaults.standard.string(forKey: "nickname"),
              let password = UserDefaults.standard.string(forKey: "password"),
              let email = UserDefaults.standard.string(forKey: "email") else {
            viewType = .notMember
            return
        }
        
        guard self.memberInformation != nil else {
            self.memberInformation = SignupMemberInformation(nickname: nickname, email: email, password: password)
            viewType = .member
            return
        }
        viewType = .member
    }
    
    private func bindAll() {
        bindJoinButton()
        bindEditButton()
    }
    
    private func bindJoinButton() {
        notMemberView.joinButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.navigationController?.pushViewController(MemberSigninViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindEditButton() {
        memberView.editButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.navigationController?.pushViewController(MemberEditViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension MemberViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardCollectionViewCell", for: indexPath) as? BoardCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}

extension MemberViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 3 - 10
    
        return CGSize(width: width, height: width)
    }
}

