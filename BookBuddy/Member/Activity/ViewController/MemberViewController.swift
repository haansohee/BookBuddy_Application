//
//  MemberViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/28/23.

//

import Foundation
import UIKit
import SkeletonView
import RxSwift
import RxCocoa

final class MemberViewController: UIViewController {
    private let memberView = MemberView()
    private let viewModel = MemberViewModel()
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        loadBoardInformaions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadMemberInformation()
        settingMemberNickname()
        settingFavoriteBook()
        loadBoardInformaions()
        loadFollowListInformation()
        settingMemberProfileImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMemberView()
        setLayoutConstraintsMemberView()
        bindAll()
        self.navigationItem.hidesBackButton = true
    }
}

extension MemberViewController {
    private func configureMemberView() {
        view.addSubview(memberView)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        memberView.translatesAutoresizingMaskIntoConstraints = false
        memberView.startSkeletonAnimation()
        memberView.boardCollectionView.dataSource = self
        memberView.boardCollectionView.delegate = self
}
    
    private func setLayoutConstraintsMemberView() {
        NSLayoutConstraint.activate([
            memberView.topAnchor.constraint(equalTo: self.view.topAnchor),
            memberView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            memberView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            memberView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func settingMemberNickname() {
        guard let nickname = viewModel.memberInformation?.nickname else { return }
        navigationItem.title = nickname
        memberView.setNameLabel(nickname)
    }
    
    private func settingFavoriteBook() {
        if let favoriteBook = UserDefaults.standard.string(forKey: UserDefaultsForkey.favorite.rawValue),
           let nickname = UserDefaults.standard.string(forKey: UserDefaultsForkey.nickname.rawValue) {
            memberView.favoriteBook.text = "\(nickname) 님이 가장 좋아하는 📗\n\(favoriteBook)"
        } else {
            memberView.favoriteBook.text = "가장 좋아하는 책을 설정해 보세요."
        }
    }
    
    private func settingMemberProfileImage() {
        guard let profileData = UserDefaults.standard.data(forKey: UserDefaultsForkey.profile.rawValue) else {
            memberView.profileImageView.image = UIImage(systemName: "person")
            return
        }
        memberView.profileImageView.image = UIImage(data: profileData)
    }
    
    private func bindAll() {
        bindEditButton()
        bindIsLoadedBoardWrittenInfo()
        bindIsLoadedFollowingListInfo()
        bindIsLoadedFollowerListInfo()
    }
    
    private func bindEditButton() {
        memberView.editButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.pushViewController(MemberEditViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedBoardWrittenInfo() {
        viewModel.isLoadedBoardWrittenInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedBoardWritten in
                guard isLoadedBoardWritten else { return }
                guard let boardCount = self?.viewModel.boardWrittenInformations?.count else { return }
                self?.memberView.boardCountLabel.hideSkeleton()
                self?.memberView.boardCountLabel.text = "\(boardCount)"
                self?.memberView.boardCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedFollowingListInfo() {
        viewModel.isLoadedFollowingListInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedFollowingListInfo in
                guard isLoadedFollowingListInfo else { return }
                guard let followingListInfoCount = self?.viewModel.followingListInformations?.count else { return }
                self?.memberView.followingCountLabel.hideSkeleton()
                self?.memberView.followingCountLabel.text = "\(followingListInfoCount)"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedFollowerListInfo() {
        viewModel.isLoadedFollowerListInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedFollowerListInfo in
                guard isLoadedFollowerListInfo else { return }
                guard let followerListInfoCount = self?.viewModel.followerListInformations?.count else { return }
                self?.memberView.followersCountLabel.hideSkeleton()
                self?.memberView.followersCountLabel.text = "\(followerListInfoCount)"
            })
            .disposed(by: disposeBag)
    }
    
    private func loadBoardInformaions() {
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaultsForkey.nickname.rawValue) else { return }
        viewModel.getMemberBoardInformaion(nickname: nickname)
    }
    
    private func loadFollowListInformation() {
        let userID = UserDefaults.standard.integer(forKey: UserDefaultsForkey.userID.rawValue)
        viewModel.getFollowingListInformation(userID: userID)
        viewModel.getFollowerListInformation(userID: userID)
    }
}

extension MemberViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let boardCounts = viewModel.boardWrittenInformations?.count else { return 0 }
        return boardCounts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardCollectionViewCell.reuseIdentifier, for: indexPath) as? BoardCollectionViewCell,
              let imageData = viewModel.boardWrittenInformations?[indexPath.row].boardImage else { return UICollectionViewCell() }
        cell.boardImage.image = UIImage(data: imageData)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let boardWrittenInformation = viewModel.boardWrittenInformations?[indexPath.row] else { return }
        navigationController?.pushViewController(BoardDetailViewController(postID: boardWrittenInformation.postID), animated: true)
    }
}

extension MemberViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 3 - 10
    
        return CGSize(width: width, height: width)
    }
}

