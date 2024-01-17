//
//  BoardSearchMemberViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 1/14/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class BoardSearchMemberViewController: UIViewController {
    private let viewModel = BoardSearchViewModel()
    private let memberViewModel = MemberViewModel()
    private let memberView = MemberView()
    private let disposeBag = DisposeBag()
    
    init(nickname: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.getBoardSearchMemberInformation(nickname)
        memberViewModel.getMemberBoardInformaion(nickname: nickname)
//        loadFollowListInformation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchMemberView()
        setLayoutConstraintsSearchMemberView()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension BoardSearchMemberViewController {
    private func configureSearchMemberView() {
        self.view.backgroundColor = .systemBackground
        memberView.translatesAutoresizingMaskIntoConstraints = false
        memberView.boardCollectionView.dataSource = self
        memberView.boardCollectionView.delegate = self
        memberView.editButton.setTitle("로딩 중", for: .normal)
        memberView.editButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    }
    
    private func setLayoutConstraintsSearchMemberView() {
        self.view.addSubview(memberView)
        NSLayoutConstraint.activate([
            memberView.topAnchor.constraint(equalTo: self.view.topAnchor),
            memberView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            memberView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            memberView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func checkFollowed() {
        let userID = UserDefaults.standard.integer(forKey: "userID")
        guard let searchUserID = viewModel.searchMemberInformation?.userID else { return }
        viewModel.checkFollowed(userID: userID, searchUserID: searchUserID)
    }
    
    private func bindAll() {
        bindIsLoadedSearchMember()
        bindIsLoadedBoardWrittenInfo()
        bindEditButton()
        bindIsUpdatedFollow()
        bindIsDeletedFollow()
        bindIsLoadedFollowingListInfo()
        bindIsLoadedFollowerListInfo()
        bindIsCheckedFollowed()
    }
    
    private func bindIsLoadedSearchMember() {
        viewModel.isLoadedSearchMember
            .subscribe(onNext: {[weak self] isLoadedSearchMember in
                guard isLoadedSearchMember else { return }
                guard let nickname = self?.viewModel.searchMemberInformation?.nickname,
                      let profile = self?.viewModel.searchMemberInformation?.profile,
                      let searchUserID = self?.viewModel.searchMemberInformation?.userID else { return }
                let userID = UserDefaults.standard.integer(forKey: "userID")
                DispatchQueue.main.async {
                    self?.memberView.setNameLabel(nickname)
                    if let favorite = self?.viewModel.searchMemberInformation?.favorite {
                        self?.memberView.favoriteBook.text = "\(nickname) 님이 가장 좋아하는 📗\n\(favorite)"
                    } else {
                        self?.memberView.favoriteBook.text = "\(nickname) 님은 아직 가장 좋아하는 책을 \n 설정하지 않았어요. 🥲"
                    }
                    
                    if profile.isEmpty {
                        self?.memberView.profileImageView.image = UIImage(systemName: "person")
                    } else {
                        self?.memberView.profileImageView.image = UIImage(data: profile)
                    }
                }
                self?.memberViewModel.getFollowingListInformation(userID: searchUserID)
                self?.memberViewModel.getFollowerListInformation(userID: searchUserID)
                self?.viewModel.checkFollowed(userID: userID, searchUserID: searchUserID)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindEditButton() {
        memberView.editButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let followerUserID = self?.viewModel.searchMemberInformation?.userID else { return }
                let followingUserID = UserDefaults.standard.integer(forKey: "userID")
                let followingInformation = FollowingInformation(followingUserID: followingUserID, followerUserID: followerUserID)
                switch self?.memberView.editButton.tag {
                case 0:
                    self?.viewModel.following(followingInformation: followingInformation)
                case 1:
                    self?.viewModel.deleteFollowing(followingInformation: followingInformation)
                case .none:
                    return
                case .some(_):
                    return
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedBoardWrittenInfo() {
        memberViewModel.isLoadedBoardWrittenInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedBoardWrittenInfo in
                guard isLoadedBoardWrittenInfo else { return }
                guard let boardCount = self?.memberViewModel.boardWrittenInformations?.count else { return }
                self?.memberView.boardCountLabel.text = "\(boardCount)"
                self?.memberView.boardCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUpdatedFollow() {
        viewModel.isUpdatedFollow
            .subscribe(onNext: {[weak self] isUpdatedFollow in
                guard isUpdatedFollow else { return }
                guard let searchUserID = self?.viewModel.searchMemberInformation?.userID else { return }
                self?.memberViewModel.getFollowerListInformation(userID: searchUserID)
                DispatchQueue.main.async {
                    self?.memberView.editButton.setTitle("팔로우 취소", for: .normal)
                    self?.memberView.editButton.backgroundColor = .lightGray
                    self?.memberView.editButton.tag = 1
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsDeletedFollow() {
        viewModel.isDeletedFollow
            .subscribe(onNext: {[weak self] isDeletedFollow in
                guard isDeletedFollow else { return }
                guard let searchUserID = self?.viewModel.searchMemberInformation?.userID else { return }
                self?.memberViewModel.getFollowerListInformation(userID: searchUserID)
                DispatchQueue.main.async {
                    self?.memberView.editButton.setTitle("팔로우", for: .normal)
                    self?.memberView.editButton.backgroundColor = .systemGreen
                    self?.memberView.editButton.tag = 0
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedFollowingListInfo() {
        memberViewModel.isLoadedFollowingListInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedFollowingListInfo in
                guard isLoadedFollowingListInfo else { return }
                guard let followingListInfoCount = self?.memberViewModel.followingListInformations?.count else { return }
                self?.memberView.followingCountLabel.text = "\(followingListInfoCount)"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedFollowerListInfo() {
        memberViewModel.isLoadedFollowerListInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedFollowerListInfo in
                guard isLoadedFollowerListInfo else { return }
                guard let followerListInfoCount = self?.memberViewModel.followerListInformations?.count else { return }
                self?.memberView.followersCountLabel.text = "\(followerListInfoCount)"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsCheckedFollowed() {
        viewModel.isCheckedFollowed
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isCheckedFollowed in
                if isCheckedFollowed {
                    self?.memberView.editButton.setTitle("팔로우 취소", for: .normal)
                    self?.memberView.editButton.backgroundColor = .lightGray
                    self?.memberView.editButton.tag = 1
                } else {
                    self?.memberView.editButton.setTitle("팔로우", for: .normal)
                    self?.memberView.editButton.backgroundColor = .systemGreen
                    self?.memberView.editButton.tag = 0
                }
            })
            .disposed(by: disposeBag)
    }
}

extension BoardSearchMemberViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let boardCounts = memberViewModel.boardWrittenInformations?.count else { return 0 }
        return boardCounts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardCollectionViewCell", for: indexPath) as? BoardCollectionViewCell else { return UICollectionViewCell() }
        guard let imageData = memberViewModel.boardWrittenInformations?[indexPath.row].boardImage else { return UICollectionViewCell() }
        cell.boardImage.image = UIImage(data: imageData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let boardWrittenInformation = memberViewModel.boardWrittenInformations?[indexPath.row] else { return }
        navigationController?.pushViewController(BoardDetailViewController(boardWrittenInformation: boardWrittenInformation), animated: true)
    }
    
}

extension BoardSearchMemberViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 3 - 10
        return CGSize(width: width, height: width)
    }
}
