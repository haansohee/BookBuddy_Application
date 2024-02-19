//
//  BoardSearchMemberViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 1/14/24.
//

import Foundation
import UIKit
import SkeletonView
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
        configureEditButton()
    }
}

extension BoardSearchMemberViewController {
    private func configureSearchMemberView() {
        self.view.backgroundColor = .systemBackground
        memberView.translatesAutoresizingMaskIntoConstraints = false
        memberView.boardCollectionView.dataSource = self
        memberView.boardCollectionView.delegate = self
    }
    
    private func configureEditButton() {
        if viewModel.checkAuthorUser() {
            memberView.followingButton.isHidden = true
            memberView.editButton.isHidden = false
        } else {
            memberView.followingButton.isHidden = false
            memberView.editButton.isHidden = true
        }
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
        let userID = UserDefaults.standard.integer(forKey: UserDefaultsForkey.userID.rawValue)
        guard let searchUserID = viewModel.searchMemberInformation?.userID else { return }
        viewModel.checkFollowed(userID: userID, searchUserID: searchUserID)
    }
    
    private func bindAll() {
        bindIsLoadedSearchMember()
        bindIsLoadedBoardWrittenInfo()
        bindFollowingButton()
        bindEditButton()
        bindIsUpdatedFollow()
        bindIsDeletedFollow()
        bindIsLoadedFollowingListInfo()
        bindIsLoadedFollowerListInfo()
        bindIsCheckedFollowed()
    }
    
    private func bindIsLoadedSearchMember() {
        viewModel.isLoadedSearchMember
            .subscribe(onNext: {[weak self] _ in
                guard let nickname = self?.viewModel.searchMemberInformation?.nickname,
                      let searchUserID = self?.viewModel.searchMemberInformation?.userID else { return }
                let userID = UserDefaults.standard.integer(forKey: UserDefaultsForkey.userID.rawValue)
                let profile = self?.viewModel.searchMemberInformation?.profile ?? Data()
                DispatchQueue.main.async {
                    self?.configureEditButton()
                    self?.memberView.setNameLabel(nickname)
                    if let favorite = self?.viewModel.searchMemberInformation?.favorite {
                        self?.memberView.favoriteBook.text = "\(nickname) 님이 가장 좋아하는 📗\n\(favorite)"
                    } else {
                        self?.memberView.favoriteBook.text = "\(nickname) 님은 아직 가장 좋아하는 책을 \n 설정하지 않았어요. 🥲"
                    }
                    self?.memberView.profileImageView.image = profile.isEmpty ? UIImage(systemName: "person") : UIImage(data: profile)
                }
                self?.memberViewModel.getFollowingListInformation(userID: searchUserID)
                self?.memberViewModel.getFollowerListInformation(userID: searchUserID)
                self?.viewModel.checkFollowed(userID: userID, searchUserID: searchUserID)
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
    
    private func bindFollowingButton() {
        memberView.followingButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let followerUserID = self?.viewModel.searchMemberInformation?.userID else { return }
                let followingUserID = UserDefaults.standard.integer(forKey: UserDefaultsForkey.userID.rawValue)
                let followingInformation = FollowingInformation(followingUserID: followingUserID, followerUserID: followerUserID)
                switch self?.memberView.followingButton.tag {
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
                self?.memberView.boardCountLabel.hideSkeleton()
                self?.memberView.boardCountLabel.text = "\(boardCount)"
                self?.memberView.boardCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUpdatedFollow() {
        viewModel.isUpdatedFollow
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isUpdatedFollow in
                guard isUpdatedFollow else { return }
                guard let searchUserID = self?.viewModel.searchMemberInformation?.userID else { return }
                self?.memberViewModel.getFollowerListInformation(userID: searchUserID)
                self?.memberView.followingButton.setTitle("팔로우 취소", for: .normal)
                self?.memberView.followingButton.backgroundColor = .lightGray
                self?.memberView.followingButton.tag = 1
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsDeletedFollow() {
        viewModel.isDeletedFollow
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isDeletedFollow in
                guard isDeletedFollow else { return }
                guard let searchUserID = self?.viewModel.searchMemberInformation?.userID else { return }
                self?.memberViewModel.getFollowerListInformation(userID: searchUserID)
                self?.memberView.followingButton.setTitle("팔로우", for: .normal)
                self?.memberView.followingButton.backgroundColor = .systemGreen
                self?.memberView.followingButton.tag = 0
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedFollowingListInfo() {
        memberViewModel.isLoadedFollowingListInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedFollowingListInfo in
                guard isLoadedFollowingListInfo else { return }
                guard let followingListInfoCount = self?.memberViewModel.followingListInformations?.count else { return }
                self?.memberView.followingCountLabel.hideSkeleton()
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
                self?.memberView.followersCountLabel.hideSkeleton()
                self?.memberView.followersCountLabel.text = "\(followerListInfoCount)"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsCheckedFollowed() {
        viewModel.isCheckedFollowed
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isCheckedFollowed in
                if isCheckedFollowed {
                    self?.memberView.followingButton.setTitle("팔로우 취소", for: .normal)
                    self?.memberView.followingButton.backgroundColor = .lightGray
                    self?.memberView.followingButton.tag = 1
                } else {
                    self?.memberView.followingButton.setTitle("팔로우", for: .normal)
                    self?.memberView.followingButton.backgroundColor = .systemGreen
                    self?.memberView.followingButton.tag = 0
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
        navigationController?.pushViewController(BoardDetailViewController(postID: boardWrittenInformation.postID), animated: true)
    }
    
}

extension BoardSearchMemberViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 3 - 10
        return CGSize(width: width, height: width)
    }
}
