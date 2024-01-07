//
//  MemberViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/28/23.

//

import Foundation
import UIKit
import Kingfisher
import RxSwift
import RxCocoa

final class MemberViewController: UIViewController {
    enum ViewType {
        case notMember
        case member
        case appleMember
    }
    
    private let memberView = MemberView()
    private let notMemberView = NotMemberView()
    private var viewType: ViewType
    private let viewModel = MemberViewModel()
    private let disposeBag = DisposeBag()
    
    init(memberInformation: SignupMemberInformation? = nil, appleMemberInformation: SigninWithAppleInformation? = nil) {
        if memberInformation != nil && appleMemberInformation == nil {
            viewType = .member
        } else if memberInformation == nil && appleMemberInformation != nil {
            viewType = .appleMember
        } else {
            viewType = .notMember
        }

        if let memberInformation = memberInformation,
           let appleMemberInformation = appleMemberInformation {
            self.viewModel.setMemberInformation(memberInformation)
            self.viewModel.setAppleMemberInformation(appleMemberInformation)
        }
        super.init(nibName: nil, bundle: nil)
        loadBoardInformaions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkMember()
        configureMemberView()
        setLayoutConstraintsMemberView()
        settingFavoriteBook()
        loadBoardInformaions()
        settingMemberProfileImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAll()
        self.navigationItem.hidesBackButton = true
    }
}

extension MemberViewController {
    private func configureMemberView() {
        switch viewType {
        case .member, .appleMember:
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
            
            if let nickname = viewModel.memberInformation?.nickname {
                memberView.setNameLabel(nickname)
            }
            
        case .appleMember:
            self.view.addSubview(memberView)
            notMemberView.removeFromSuperview()
            NSLayoutConstraint.activate([
                memberView.topAnchor.constraint(equalTo: self.view.topAnchor),
                memberView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                memberView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                memberView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            if let nickname = viewModel.appleMemberInformation?.nickname {
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
    
    private func checkMember() {
        if let email = UserDefaults.standard.string(forKey: "email"),
           let nickname = UserDefaults.standard.string(forKey: "nickname") {
            if let appleToken = UserDefaults.standard.string(forKey: "appleToken") {
                let appleMemberInformation = SigninWithAppleInformation(nickname: nickname, email: email, appleToken: appleToken)
                self.viewModel.setAppleMemberInformation(appleMemberInformation)
                viewType = .appleMember
            } else {
                guard let password = UserDefaults.standard.string(forKey: "password") else { return }
                let memberInformation = SignupMemberInformation(nickname: nickname, email: email, password: password)
                self.viewModel.setMemberInformation(memberInformation)
                viewType = .member
            }
        } else {
            viewType = .notMember
        }
    }
    
    private func settingFavoriteBook() {
        guard let favoriteBook = UserDefaults.standard.string(forKey: "favorite"),
              let nickname = UserDefaults.standard.string(forKey: "nickname") else { return }
        memberView.favoriteBook.text = "\(nickname) 님이 가장 좋아하는 📗\n\(favoriteBook)"
    }
    
    private func settingMemberProfileImage() {
        guard let profileData = UserDefaults.standard.data(forKey: "profile") else {
            DispatchQueue.main.async { [weak self] in
                self?.memberView.profileImageView.image = UIImage(systemName: "person")
            }
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.memberView.profileImageView.image = UIImage(data: profileData)
        }
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
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.pushViewController(MemberEditViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadBoardInformaions() {
        guard let nickname = UserDefaults.standard.string(forKey: "nickname") else { return }
        viewModel.getMemberBoardInformaion(nickname: nickname)
        DispatchQueue.main.async {
            self.memberView.boardCollectionView.reloadData()
        }
    }
}

extension MemberViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let boardCounts = viewModel.boardWrittenInformations?.count else { return 0 }
        return boardCounts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardCollectionViewCell", for: indexPath) as? BoardCollectionViewCell else { return UICollectionViewCell() }
        cell.contentTitle.text = viewModel.boardWrittenInformations?[indexPath.row].contentTitle
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let boardWrittenInformation = viewModel.boardWrittenInformations?[indexPath.row] else { return }
        navigationController?.pushViewController(BoardDetailViewController(boardWrittenInformation: boardWrittenInformation), animated: true)
    }
}

extension MemberViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 3 - 10
    
        return CGSize(width: width, height: width)
    }
}

