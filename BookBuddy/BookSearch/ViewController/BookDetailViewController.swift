//
//  BookDetailViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/20/23.
//

import Foundation
import UIKit
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
                    image: Data())
            print("엥?")
            return
        }
        
        bookSearchViewModel.loadImageData(imageURL: imageURL) { [weak self] data in
            self?.bookSearchViewModel
                .setBookInformationData(
                    title: bookData.title,
                    author: bookData.author,
                    category: category,
                    description: bookData.description,
                    image: data)
            guard let information = self?.bookSearchViewModel.bookInformations else { return }
            self?.bookDetailView.setBookInformation(information)
        }
    }
    
    private func bindAll() {
        bindLikeButton()
        bindIsSetFavorite()
    }
    
    private func bindLikeButton() {
        bookDetailView.likeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let bookTitle = self?.bookDetailView.bookTitleLabel.text else { return }
                if bookTitle == "" { return }
                self?.bookDetailViewModel.settingFavoriteBook(bookTitle: bookTitle)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsSetFavorite() {
        bookDetailViewModel.isSetFavorite
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isSetFavorite in
                guard isSetFavorite else {
                    return
                }
                self?.bookDetailView.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            })
            .disposed(by: disposeBag)
    }
}
