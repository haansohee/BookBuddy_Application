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
    private let disposeBag = DisposeBag()
    
    init() {
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
}

extension HomeViewController {
    private func configureHomeView() {
        view.backgroundColor = .systemBackground
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
        homeViewCollectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        homeViewModel.getFollowingBoards()
        DispatchQueue.main.async { [weak self] in
            self?.homeViewCollectionView.refreshControl?.endRefreshing()
        }
    }
    
    private func loadFollowingBoardInformations() {
        homeViewModel.getFollowingBoards()
    }
    
    private func bindIsLoadedFollowingBoardInfo() {
        homeViewModel.isUploadedFollowingBoardInfo
            .asDriver(onErrorJustReturn: "noValue")
            .drive(onNext: { [weak self] _ in
                self?.homeViewCollectionView.reloadData()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardSearchViewCell", for: indexPath) as? BoardSearchViewCell else { return UICollectionViewCell() }
        guard let followingBoardInformation = homeViewModel.followingBoardInformations else { return UICollectionViewCell() }
        
        if let profileImage = followingBoardInformation[indexPath.row].profileImage {
            cell.profileImageView.image = UIImage(data: profileImage)
        } else {
            cell.profileImageView.image = UIImage(systemName: "person")
        }
        cell.setFollowingBoardViewCell(followingBoardInfo: followingBoardInformation[indexPath.row])
        let nicknameTapGesture = TapGestureRelayValue(target: self, action: #selector(followingMemberNicknameTapGesture(nickname:)))
        nicknameTapGesture.nickname = followingBoardInformation[indexPath.row].nickname
        cell.touchStackView.addGestureRecognizer(nicknameTapGesture)
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20
        let height = collectionView.bounds.height - 140
        return CGSize(width: width, height: height)
    }
}
