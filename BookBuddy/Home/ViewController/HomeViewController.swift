//
//  HomeViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/6/23.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    private let homeViewCollectionView = BoardSearchCollectionView()
    private let homeViewModel = HomeViewModel()
    private let commentViewModel = CommentViewModel()
    private let activityIndicatorViewController = ActivityIndicatorViewController()
    private let disposeBag = DisposeBag()
    
    init(nickname: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        loadFollowingBoardInformations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setLayoutConstraints()
        configureHomeView()
        configureRefreshControl()
        bindIsLoadedFollowingBoardInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFollowingBoardInformations()
    }
}

extension HomeViewController {
    private func configureHomeView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "홈"
        homeViewCollectionView.translatesAutoresizingMaskIntoConstraints = false
        homeViewCollectionView.dataSource = self
        homeViewCollectionView.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(homeViewCollectionView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            homeViewCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            homeViewCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            homeViewCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            homeViewCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func configureRefreshControl() {
        homeViewCollectionView.refreshControl = UIRefreshControl()
        homeViewCollectionView.refreshControl?.addTarget(self, action: #selector(loadFollowingBoardInformations), for: .valueChanged)
    }
    
    @objc private func loadFollowingBoardInformations() {
        homeViewModel.getFollowingBoards()
    }
    
    private func changeLikeCountLabelValue(label: UILabel, deleteLike: Bool) {
        DispatchQueue.main.async {
            guard deleteLike else {
                if let labelText = label.text,
                   var labelTextValue = Int(labelText) {
                    labelTextValue += 1
                    label.text = String(labelTextValue)
                }
                return
            }
            if let labelText = label.text {
                if var labelTextValue = Int(labelText) {
                    labelTextValue -= 1
                    label.text = String(labelTextValue)
                }
            }
        }
    }
    
    private func bindIsLoadedFollowingBoardInfo() {
        homeViewModel.isUploadedFollowingBoardInfo
            .asDriver(onErrorJustReturn: "noValue")
            .drive(onNext: { [weak self] _ in
                self?.homeViewCollectionView.reloadData()
                self?.homeViewCollectionView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func followingMemberNicknameTapGesture(nickname: TapGestureRelayValue) {
        guard let nickname = nickname.nickname else { return }
        navigationController?.pushViewController(BoardSearchMemberViewController(nickname: nickname), animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let followingBoardInfoCount = homeViewModel.followingBoardInformations?.count else { return 0}
        return followingBoardInfoCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardSearchViewCell.reuseIdentifier, for: indexPath) as? BoardSearchViewCell else { return UICollectionViewCell() }
        guard let followingBoardInformation = homeViewModel.followingBoardInformations else { return cell }
        cell.commentCountLabel.text = String(followingBoardInformation[indexPath.row].comments.count)
        if followingBoardInformation[indexPath.row].didLike {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.likeButton.tag = 1
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.likeButton.tag = 0
        }
        
        if let profileImage = followingBoardInformation[indexPath.row].profileImage {
            cell.profileImageView.image = UIImage(data: profileImage)
        } else {
            cell.profileImageView.image = UIImage(systemName: "person")
        }
        cell.setFollowingBoardViewCell(followingBoardInfo: followingBoardInformation[indexPath.row])
        
        let nicknameTapGesture = TapGestureRelayValue(target: self, action: #selector(followingMemberNicknameTapGesture(nickname:)))
        nicknameTapGesture.nickname = followingBoardInformation[indexPath.row].nickname
        cell.touchStackView.addGestureRecognizer(nicknameTapGesture)
        
        cell.rx.likeButtonTapped
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let likedUserID = self?.homeViewModel.userID else { return }
                let boardLikeInformation = BoardLikeInformation(likedUserID: likedUserID, postUserNickname: followingBoardInformation[indexPath.row].nickname, postID: followingBoardInformation[indexPath.row].postID)
                switch cell.likeButton.tag {
                case 1:
                    self?.homeViewModel.deleteBoardLikeInformation(boardLikeInformation) { result in
                        guard result else { return }
                        DispatchQueue.main.async {
                            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                            cell.likeButton.tag = 0
                        }
                        self?.changeLikeCountLabelValue(label: cell.likeCountLabel, deleteLike: true)
                    }
                case 0:
                    self?.homeViewModel.setBoardLikeInformation(boardLikeInformation) { result in
                        guard result else { return }
                        DispatchQueue.main.async {
                            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                            cell.likeButton.tag = 1
                        }
                        self?.changeLikeCountLabelValue(label: cell.likeCountLabel, deleteLike: false)
                    }
                default:
                    return
                }
            })
            .disposed(by: cell.disposeBag)
        
        cell.rx.commentButtonTapped
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.present(CommentViewController(postID: followingBoardInformation[indexPath.row].postID, commentInformation: followingBoardInformation[indexPath.row].comments), animated: true)
            })
            .disposed(by: cell.disposeBag)
        let reportAction = UIAction(title: "신고하기",
                                  image: UIImage(systemName: "exclamationmark.bubble"),
                                  attributes: .destructive,
                                  handler: { [weak self] _ in
            let reportViewController = ReportViewController()
            reportViewController.modalPresentationStyle = .overFullScreen
            self?.present(reportViewController, animated: true)
        })
        cell.ellipsisButton.menu = UIMenu(children: [reportAction])
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20
        let height = collectionView.bounds.height - 130
        return CGSize(width: width, height: height)
    }
}
