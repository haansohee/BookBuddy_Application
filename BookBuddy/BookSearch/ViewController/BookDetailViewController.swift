//
//  BookDetailViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/20/23.
//

import Foundation
import UIKit
import SkeletonView
import RxSwift
import RxCocoa

final class BookDetailViewController: UIViewController {
    private let bookDetailView = BookDetailView()
    private let bookDetailViewModel = BookDetailViewModel()
    private let bookSearchViewModel = BookSearchViewModel()
    private let disposeBag = DisposeBag()
    
    init(data: BookSearchContents, category: String) {
        super.init(nibName: nil, bundle: nil)
        configureBookDetailView(bookData: data, category: category)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var childForStatusBarStyle: UIViewController? {
        let viewController = BookSearchViewContoller()
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBookDetailView()
        setLayoutConstraintsBookDetailView()
        bindAll()
    }
}


extension BookDetailViewController {
    private func configureBookDetailView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(bookDetailView)
        self.modalPresentationCapturesStatusBarAppearance = true
        bookDetailView.showAnimatedSkeleton()
        bookDetailView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setLayoutConstraintsBookDetailView() {
        NSLayoutConstraint.activate([
            bookDetailView.topAnchor.constraint(equalTo: self.view.topAnchor),
            bookDetailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bookDetailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bookDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func configureBookDetailView(bookData: BookSearchContents, category: String) {
        guard let imageURL = URL(string: bookData.image) else {
            bookSearchViewModel
                .setBookInformationData(
                    title: bookData.title,
                    author: bookData.author,
                    category: category,
                    description: bookData.description,
                    image: Data(),
                    link: bookData.link)
            return
        }
        
        bookSearchViewModel.loadImageData(imageURL: imageURL) { [weak self] data in
            self?.bookSearchViewModel
                .setBookInformationData(
                    title: bookData.title,
                    author: bookData.author,
                    category: category,
                    description: bookData.description,
                    image: data,
                    link: bookData.link)
            guard let information = self?.bookSearchViewModel.bookInformations else { return }
            DispatchQueue.main.async {
                self?.bookDetailView.hideSkeleton()
            }
            self?.checkIsSetFavorite()
            self?.bookDetailView.setBookInformation(information)
        }
    }
    
    private func checkIsSetFavorite() {
        guard let bookInformation = bookSearchViewModel.bookInformations else { return }
        guard bookDetailViewModel.checkIsSetFavorite(bookTitle: bookInformation.title) else {
            DispatchQueue.main.async { [weak self] in
                self?.bookDetailView.likeButton.tag = 0
            }
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.bookDetailView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self?.bookDetailView.likeButton.tag = 1
        }
    }
    
    private func unsetFavoriteBookAlert() {
        let alertController = UIAlertController(title: "최애 책 설정 취소", message: "최애 책 설정을 취소할까요?", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "네, 취소할래요.", style: .destructive) { [weak self] _ in
            self?.bookDetailViewModel.unsetFavoriteBook()
        }
        let cancelAction = UIAlertAction(title: "아니요, 그대로 둘래요.", style: .cancel)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func bindAll() {
        bindLikeButton()
        bindIsSetFavorite()
        bindIsUnsetFavortie()
    }
    
    private func bindLikeButton() {
        bookDetailView.likeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let bookTitle = self?.bookDetailView.bookTitleLabel.text else { return }
                if bookTitle.isEmpty { return }
                switch self?.bookDetailView.likeButton.tag {
                case 0:
                    self?.bookDetailViewModel.settingFavoriteBook(bookTitle: bookTitle)
                case 1:
                    self?.unsetFavoriteBookAlert()
                default: return
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsSetFavorite() {
        bookDetailViewModel.isSetFavorite
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isSetFavorite in
                guard isSetFavorite else { return }
                self?.bookDetailView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self?.bookDetailView.likeButton.tag = 1
                
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUnsetFavortie() {
        bookDetailViewModel.isUnsetFavorite
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isUnsetFavorite in
                guard isUnsetFavorite else{ return }
                self?.bookDetailView.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                self?.bookDetailView.likeButton.tag = 0
            })
            .disposed(by: disposeBag)
    }
}
