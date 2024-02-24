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
import SkeletonView

final class BookSearchViewContoller: UIViewController {
    private let searchController = SearchController()
    private let bookSearchView = BookSearchView()
    private let viewModel = BookSearchViewModel()
    private let disposeBag = DisposeBag()
    private var endEditingGesture: UITapGestureRecognizer?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBookSearchView()
        setLayoutConstraintsBookSearchView()
        setupSearchController()
        bindAll()
        addEditingTapGesture()
    }
}

extension BookSearchViewContoller {
    private func configureBookSearchView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(bookSearchView)
        
        bookSearchView.translatesAutoresizingMaskIntoConstraints = false
        bookSearchView.searchResultsCollectionView.showAnimatedSkeleton()
        bookSearchView.searchResultsCollectionView.dataSource = self
        bookSearchView.searchResultsCollectionView.delegate = self
    }
    
    private func setLayoutConstraintsBookSearchView() {
        NSLayoutConstraint.activate([
            bookSearchView.topAnchor.constraint(equalTo: self.view.topAnchor),
            bookSearchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bookSearchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bookSearchView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController.setupSearchController()
        searchController.searchBar.searchTextField.delegate = self
        searchController.searchBar.delegate = self
        self.navigationItem.title = "책 검색하기"
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func addEditingTapGesture() {
        endEditingGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.endEditingGesture?.isEnabled = false
        guard let endEditingGesture = endEditingGesture else { return }
        self.view.addGestureRecognizer(endEditingGesture)
    }
    
    @objc private func endEditing() {
        self.searchController.searchBar.endEditing(true)
    }
    
    private func bindAll() {
        bindIsParsed()
    }
    
    private func bindIsParsed() {
        viewModel.isParsed
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isParsed in
                guard isParsed else {
                    self?.viewModel.checkSearched(false)
                    return
                }
                guard let searchResults = self?.viewModel.bookSearchResults.count else { return }
                self?.viewModel.checkSearched(true)
                self?.bookSearchView.searchResultsCollectionView.hideSkeleton()
                self?.bookSearchView.searchResultsCollectionView.reloadData()
                self?.bookSearchView.searchResultCountLabel.text = "\(searchResults)개의 검색 결과예요."
            })
            .disposed(by: disposeBag)
    }
}

extension BookSearchViewContoller: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.canceldSearch()
        bookSearchView.searchResultsCollectionView.reloadData()
        bookSearchView.searchResultCountLabel.text = "무슨 책을 찾으시나요? 🧐"
    }
}

extension BookSearchViewContoller: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.endEditingGesture?.isEnabled = true
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.endEditingGesture?.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let bookTitle = self.searchController.searchBar.searchTextField.text else { return false }
        self.viewModel.parsing(bookTitle: bookTitle)
        DispatchQueue.main.async { [weak self] in
            self?.bookSearchView.searchResultCountLabel.text = "검색 중...📗"
        }
        return true
    }
}

extension BookSearchViewContoller: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard viewModel.bookSearchResults.count != 0 else { return 1 }
        return viewModel.bookSearchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as? SearchResultCell else { return UICollectionViewCell() }
        
        guard !viewModel.bookSearchResults.isEmpty else {
            cell.setIsHiddenOption(true)
            return cell }
        cell.setIsHiddenOption(false)
        let title = viewModel.bookSearchResults[indexPath.row].title
        let author = viewModel.bookSearchResults[indexPath.row].author
        let category = viewModel.category[indexPath.row]
        let description = viewModel.bookSearchResults[indexPath.row].description
        let link = viewModel.bookSearchResults[indexPath.row].link
        
        if let imageURL = URL(string: viewModel.bookSearchResults[indexPath.row].image) {
            viewModel.loadImageData(imageURL: imageURL) { [weak self] data in
                self?.viewModel.setBookInformationData(title: title,
                                                       author: author,
                                                       category: category,
                                                       description: description,
                                                       image: data,
                                                       link: link)
                guard let information = self?.viewModel.bookInformations else { return }
                cell.setBookInformation(information)
            }
        }       
        return cell
    }
}

extension BookSearchViewContoller: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !viewModel.bookSearchResults.isEmpty else { return }
        let bookData = viewModel.bookSearchResults[indexPath.row]
        let categoryData = viewModel.category[indexPath.row]
        let controller = BookDetailViewController(data: bookData, category: categoryData)
        present(controller, animated: true)
    }
}

extension BookSearchViewContoller: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel.bookSearchResults.isEmpty {
            let width = (UIScreen.main.bounds.width) - 20
            let height = 380.0
            return CGSize(width: width, height: height)
        } else {
            let width = (UIScreen.main.bounds.width / 2) - 20
            let height = 370.0
            return CGSize(width: width, height: height)
        }
    }
}
