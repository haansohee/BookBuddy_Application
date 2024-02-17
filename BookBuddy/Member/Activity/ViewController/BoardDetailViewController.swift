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
                                      handler: { _ in
                // 신고 기능
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
    
    @objc private func editBoard() {
        guard let boardWrittenInformation = viewModel.boardDetailInformation else { return }
        let boardEditInformation = BoardEditInformation(postID: boardWrittenInformation.postID, nickname: boardWrittenInformation.nickname, contentTitle: boardWrittenInformation.contentTitle, content: boardWrittenInformation.content, boardImage: boardWrittenInformation.boardImage)
        navigationController?.pushViewController(BoardEditViewController(boardEditInformation), animated: true)
    }

    private func editedBoardInfo() {
        guard let postID = viewModel.postID else {return }
        viewModel.getDetailBoardInformation(postID)
    }
    
    private func bindAll() {
        bindIsBoardDetailInfoLoaded()
        bindIsBoardDeleted()
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
