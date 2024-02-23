//
//  BoardDetailViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 12/21/23.
//

import Foundation
import UIKit
import SkeletonView
import RxSwift
import RxCocoa

final class BoardDetailViewController: UIViewController {
    private let boardDetailView = BoardDetailView()
    private let viewModel = BoardDetailViewModel()
    private let homeViewModel = HomeViewModel()
    private let boardEditViewModel = BoardEditViewModel()
    private let disposeBag = DisposeBag()
    
    init(postID: Int) {
        viewModel.getDetailBoardInformation(postID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBoardDetailView()
        setLayoutConstraintsBoardDetailView()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editedBoardInfo()
    }
}

extension BoardDetailViewController {
    private func configureBoardDetailView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(boardDetailView)
        boardDetailView.translatesAutoresizingMaskIntoConstraints = false
        boardDetailView.showAnimatedSkeleton()
        navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    private func setLayoutConstraintsBoardDetailView() {
        NSLayoutConstraint.activate([
            boardDetailView.topAnchor.constraint(equalTo: self.view.topAnchor),
            boardDetailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            boardDetailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            boardDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func checkBoardAuthor() {
        if viewModel.checkBoardAuthor() {
            let editMenu = UIAction(title: "수정하기",
                                    image: UIImage(systemName: "pencil.circle"),
                                    handler: { [weak self] _ in
                self?.editBoard()
            })
            let deleteMenu = UIAction(title: "삭제하기",
                                      image: UIImage(systemName: "trash"),
                                      attributes: .destructive,
                                      handler: { [weak self] _ in
                self?.deleteCheckAlert()
            })
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: UIMenu(children: [editMenu, deleteMenu]))
        } else {
            let reportMenu = UIAction(title: "신고하기",
                                      image: UIImage(systemName: "exclamationmark.bubble"),
                                      attributes: .destructive,
                                      handler: { [weak self] _ in
                let reportViewController = ReportViewController()
                reportViewController.modalPresentationStyle = .overFullScreen
                self?.present(reportViewController, animated: true)
            })
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: UIMenu(children: [reportMenu]))
        }
    }
    
    private func deleteCheckAlert() {
        let alertController = UIAlertController(title: "게시글 삭제", message: "정말 삭제할까요? 🥲", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteBoard()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func editBoard() {
        guard let boardWrittenInformation = viewModel.boardDetailInformation else { return }
        let boardEditInformation = BoardEditInformation(
            postID: boardWrittenInformation.postID,
            nickname: boardWrittenInformation.nickname,
            contentTitle: boardWrittenInformation.contentTitle,
            content: boardWrittenInformation.content,
            boardImage: boardWrittenInformation.boardImage)
        navigationController?.pushViewController(BoardEditViewController(boardEditInformation), animated: true)
    }

    private func editedBoardInfo() {
        guard let postID = viewModel.postID else {return }
        viewModel.getDetailBoardInformation(postID)
    }
    
    private func settingLikeCommentCount() {
        guard let boardInformation = viewModel.boardDetailInformation else { return }
        boardDetailView.likeCountLabel.text = "\(boardInformation.likes)"
        boardDetailView.commentCountLabel.text = "\(boardInformation.comments.count)"
        if boardInformation.didLike {
            boardDetailView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            boardDetailView.likeButton.tag = 1
        } else {
            boardDetailView.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            boardDetailView.likeButton.tag = 0
        }
    }
    
    private func changeLikeCountLabelValue(label: UILabel, deleteLike: Bool) {
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
    
    private func bindAll() {
        bindLikeButton()
        bindCommentButton()
        bindIsBoardDetailInfoLoaded()
        bindIsBoardDeleted()
    }
    
    private func bindLikeButton() {
        boardDetailView.likeButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let likedUserID = self?.homeViewModel.userID,
                      let boardInformation = self?.viewModel.boardDetailInformation,
                      let label = self?.boardDetailView.likeCountLabel else { return }
                let boardLikeInformation = BoardLikeInformation(likedUserID: likedUserID,
                                                                postUserNickname: boardInformation.nickname,
                                                                postID: boardInformation.postID)
                switch self?.boardDetailView.likeButton.tag {
                case 1:
                    self?.homeViewModel.deleteBoardLikeInformation(boardLikeInformation) { result in
                        guard result else { return }
                        DispatchQueue.main.async {
                            self?.boardDetailView.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                            self?.boardDetailView.likeButton.tag = 0
                            self?.changeLikeCountLabelValue(label: label, deleteLike: true)
                        }
                    }
                case 0:
                    self?.homeViewModel.setBoardLikeInformation(boardLikeInformation) { result in
                        guard result else { return }
                        DispatchQueue.main.async {
                            self?.boardDetailView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                            self?.boardDetailView.likeButton.tag = 1
                            self?.changeLikeCountLabelValue(label: label, deleteLike: false)
                        }
                            
                    }
                default: return
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCommentButton() {
        boardDetailView.commentButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let boardInformation = self?.viewModel.boardDetailInformation else { return }
                self?.present(CommentViewController(postID: boardInformation.postID, commentInformation: boardInformation.comments), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsBoardDetailInfoLoaded() {
        viewModel.isBoardDetailInfoLoaded
            .asDriver(onErrorJustReturn: "noValue")
            .drive(onNext: {[weak self] value in
                guard let boardDetailInformation = self?.viewModel.boardDetailInformation else { return }
                self?.boardDetailView.hideSkeleton()
                self?.boardDetailView.setBoardDetailView(boardDetailInformation)
                self?.navigationItem.title = boardDetailInformation.nickname
                self?.checkBoardAuthor()
                self?.settingLikeCommentCount()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsBoardDeleted() {
        viewModel.isBoardDeleted
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isBoardDeleted in
                guard isBoardDeleted else { return }
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
