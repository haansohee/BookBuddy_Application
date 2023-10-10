//
//  BookSearchViewContoller.swift
//  BookBuddy
//
//  Created by 한소희 on 10/5/23.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class BookSearchViewContoller: UIViewController {
    private let bookSearchView = BookSearchView()
    private let viewModel = BookSearchViewModel()
    private let disposeBag = DisposeBag()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        bookSearchViewConfigure()
        bookSearchViewSetLayoutConstraints()
        bindAll()
    }
    
}

extension BookSearchViewContoller {
    private func bookSearchViewConfigure() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(bookSearchView)
        
        bookSearchView.translatesAutoresizingMaskIntoConstraints = false
        bookSearchView.searchResultsCollectionView.dataSource = self
        bookSearchView.searchResultsCollectionView.delegate = self
    }
    
    private func bookSearchViewSetLayoutConstraints() {
        NSLayoutConstraint.activate([
            bookSearchView.topAnchor.constraint(equalTo: self.view.topAnchor),
            bookSearchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bookSearchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bookSearchView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func bindAll() {
        bindSearchButton()
        bindIsParsed()
    }
    
    private func bindSearchButton() {
        bookSearchView.searchButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let bookTitle = self?.bookSearchView.searchTextField.text else { return }
                self?.viewModel.parsing(bookTitle: bookTitle)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsParsed() {
        viewModel.isParsed
            .subscribe(onNext: { [weak self] isParsed in
                guard isParsed else { return }
                DispatchQueue.main.async {
                    self?.bookSearchView.searchResultsCollectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension BookSearchViewContoller: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.bookSearchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else { return UICollectionViewCell() }
        
        let title = viewModel.bookSearchResults[indexPath.row].title
        let author = viewModel.bookSearchResults[indexPath.row].author
        
        cell.setBookTitleLabel(title: title)
        cell.setBookAuthorLabel(author: author)
        
        return cell
    }
    
    
}

extension BookSearchViewContoller: UICollectionViewDelegate {
    
}


extension BookSearchViewContoller: UICollectionViewDelegateFlowLayout {
    
}
