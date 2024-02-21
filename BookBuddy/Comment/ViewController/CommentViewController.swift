//
//  CommentViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 1/25/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SwipeCellKit

final class CommentViewController: UIViewController {
    private let commentTitelView = CommentTitleView()
    private let commentCollectionView = CommentCollectionView()
    private let commentPostView = CommentPostView()
    private let commentViewModel = CommentViewModel()
    private let homeViewmodel = HomeViewModel()
    private let disposeBag = DisposeBag()
    private let activityIndicatorViewController = ActivityIndicatorViewController()
    private let keyboardNotification = KeyboardNotification()
    private var endEditingGesture: UITapGestureRecognizer?
    private let textViewPlaceholder = "댓글을 작성해 보세요. 😀"
    
    init(postID: Int, commentInformation: [CommentInformation]) {
        super.init(nibName: nil, bundle: nil)
        commentViewModel.setPostID(postID)
        commentViewModel.setCommentInformations(commentInformation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var childForStatusBarStyle: UIViewController? {
        let viewController = HomeViewController()
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommentView()
        addSubviews()
        setLayoutConstraintsComment()
        addEditingTapGesture()
        keyboardNotification.setKeyboardNotification(self.view)
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension CommentViewController {
    private func configureCommentView() {
        view.backgroundColor = .systemBackground
        self.modalPresentationCapturesStatusBarAppearance = true
        self.sheetPresentationController?.prefersGrabberVisible = true
        commentTitelView.translatesAutoresizingMaskIntoConstraints = false
        commentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        commentPostView.translatesAutoresizingMaskIntoConstraints = false
        commentCollectionView.dataSource = self
        commentCollectionView.delegate = self
        commentPostView.commentTextView.delegate = self
    }
    
    private func addSubviews() {
        [
            commentTitelView,
            commentCollectionView,
            commentPostView
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayoutConstraintsComment() {
        NSLayoutConstraint.activate([
            commentTitelView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            commentTitelView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            commentTitelView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            commentTitelView.heightAnchor.constraint(equalToConstant: 60.0),
            
            commentCollectionView.topAnchor.constraint(equalTo: commentTitelView.bottomAnchor),
            commentCollectionView.leadingAnchor.constraint(equalTo: commentTitelView.leadingAnchor),
            commentCollectionView.trailingAnchor.constraint(equalTo: commentTitelView.trailingAnchor),
            
            commentPostView.topAnchor.constraint(equalTo: commentCollectionView.bottomAnchor),
            commentPostView.leadingAnchor.constraint(equalTo: commentTitelView.leadingAnchor),
            commentPostView.trailingAnchor.constraint(equalTo: commentTitelView.trailingAnchor),
            commentPostView.heightAnchor.constraint(equalToConstant: 60.0),
            commentPostView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func addEditingTapGesture() {
        endEditingGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.endEditingGesture?.isEnabled = false
        guard let endEditingGesture = endEditingGesture else { return }
        self.view.addGestureRecognizer(endEditingGesture)
    }
    
    @objc private func endEditing() {
        self.view.endEditing(true)
    }
    
    private func calculateCellHeight(textString: String) -> CGFloat {
        let label = UILabel(frame: CGRectMake(0, 0, UIScreen.main.bounds.width - 100, CGFloat.greatestFiniteMagnitude))
        label.text = textString
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.sizeToFit()
        return label.frame.height + 60
    }
    
    private func bindAll() {
        bindCommentPostButton()
        bindIsLoadedComment()
        bindIsIUploadedComment()
        bindIsDeletedComment()
    }
    
    private func bindCommentPostButton() {
        commentPostView.commentPostButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let userID = self?.homeViewmodel.userID else { return }
                guard let commentContent = self?.commentPostView.commentTextView.text,
                      let button = self?.commentPostView.commentPostButton else { return }
                if commentContent.isEmpty { return }
                self?.activityIndicatorViewController.startButtonTapped(button)
                self?.view.endEditing(true)
                self?.commentPostView.commentTextView.text = self?.textViewPlaceholder
                self?.commentPostView.commentTextView.textColor = .lightGray
                self?.commentViewModel.commentUpload(userID: userID, commentContent: commentContent)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsIUploadedComment() {
        commentViewModel.isIUploadedComment
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isCommentUploaded in
                guard isCommentUploaded else { return }
                self?.commentViewModel.loadCommentInformation()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedComment() {
        commentViewModel.isLoadedComment
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isCommentLoaded in
                guard isCommentLoaded,
                      let button = self?.commentPostView.commentPostButton else { return }
                button.backgroundColor = .systemGreen
                button.isEnabled = true
                self?.activityIndicatorViewController.stopButtonTapped(button, buttonTitle: "게시")
                self?.commentCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsDeletedComment() {
        commentViewModel.isDeletedComment
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isCommentDeleted in
                guard isCommentDeleted else { return }
                self?.commentCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITextView Delegate
extension CommentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.endEditingGesture?.isEnabled = true
        guard textView.text == textViewPlaceholder else { return }
        textView.text = nil
        textView.textColor = .label
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.endEditingGesture?.isEnabled = false
        guard  textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        textView.text = textViewPlaceholder
        textView.textColor = .lightGray
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionView DataSource
extension CommentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let commentInformationCount = commentViewModel.commentInformations?.count else { return 0 }
        if commentInformationCount == 0 { return 1 }
        return commentInformationCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCollectionViewCell.reuseIdentifier, for: indexPath) as? CommentCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        guard let commentInformation = commentViewModel.commentInformations else { return cell }
        guard !commentInformation.isEmpty else {
            cell.isHiddenOption(true)
            return cell
        }
        cell.isHiddenOption(false)
        if let profileImage = commentInformation[indexPath.row].profile {
            cell.profileImage.image = UIImage(data: profileImage)
        } else {
            cell.profileImage.image = UIImage(systemName: "person")
        }
        cell.setupCommentViewCell(commentInformation[indexPath.row])
        return cell
    }
}

// MARK: - SwipeCollectionViewCell Delegate
extension CommentViewController: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard let commentInformation = commentViewModel.commentInformations else { return nil }
        guard orientation == .right else { return nil }
        if commentViewModel.checkAuthorUser(with: commentInformation[indexPath.row].userID) {
            let deleteAction = SwipeAction(style: .destructive, title: "삭제") { [weak self] action, indexPath in
                self?.commentViewModel.deleteComment(
                    commentUserID: commentInformation[indexPath.row].userID,
                    commentID: commentInformation[indexPath.row].commentID,
                    indexPath: indexPath)
            }
            deleteAction.image = UIImage(systemName: "trash")
            return [deleteAction]
        } else {
            let reportAction = SwipeAction(style: .default, title: "신고") { [weak self] action, indexPath in
                let reportViewController = ReportViewController()
                reportViewController.modalPresentationStyle = .overFullScreen
                self?.present(reportViewController, animated: true)
            }
            reportAction.image = UIImage(systemName: "exclamationmark.bubble")
            return [reportAction]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        return options
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CommentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let commentInformation = commentViewModel.commentInformations else { return .zero }
        let width = collectionView.bounds.width - 20
        if commentInformation.isEmpty {
            let height = 300.0
            return CGSize(width: width, height: height)
        } else {
            let height = calculateCellHeight(textString: commentInformation[indexPath.row].commentContent)
            return CGSize(width: width, height: height)
        }
    }
}
