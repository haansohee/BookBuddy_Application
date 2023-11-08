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
    
    private var endEditingGesture: UITapGestureRecognizer?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBookSearchView()
        setLayoutConstraintsBookSearchView()
        bindAll()
        addEditingTapGesture()
    }
}

extension BookSearchViewContoller {
    private func configureBookSearchView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(bookSearchView)
        
        bookSearchView.translatesAutoresizingMaskIntoConstraints = false
        bookSearchView.searchResultsCollectionView.dataSource = self
        bookSearchView.searchResultsCollectionView.delegate = self
        
        bookSearchView.searchTextField.delegate = self
        bookSearchView.searchTextField.returnKeyType = .done
    }
    
    private func setLayoutConstraintsBookSearchView() {
        NSLayoutConstraint.activate([
            bookSearchView.topAnchor.constraint(equalTo: self.view.topAnchor),
            bookSearchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bookSearchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bookSearchView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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

extension BookSearchViewContoller: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.endEditingGesture?.isEnabled = true
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.endEditingGesture?.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        let category = viewModel.category[indexPath.row]
        let description = viewModel.bookSearchResults[indexPath.row].description
        
        if let imageURL = URL(string: viewModel.bookSearchResults[indexPath.row].image) {
            viewModel.loadImageData(imageURL: imageURL) { [weak self] data in
                self?.viewModel.setBookInformationData(title: title,
                                                       author: author,
                                                       category: category,
                                                       description: description,
                                                       image: data)
                guard let information = self?.viewModel.bookInformations else { return }
                cell.setBookInformation(information)
            }
        }       
        return cell
    }
}

extension BookSearchViewContoller: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookData = viewModel.bookSearchResults[indexPath.row]
        let categoryData = viewModel.category[indexPath.row]
        
        let controller = BookDetailViewController(data: bookData, category: categoryData)
        
        self.present(controller, animated: true)
    }
}
