//
//  BookSearchViewContoller.swift
//  BookBuddy
//
//  Created by 한소희 on 10/5/23.
//

import Foundation
import UIKit

final class BookSearchViewContoller: UIViewController {
    private let bookSearchView = BookSearchView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bookSearchViewSetLayoutConstraints()
    }
}

extension BookSearchViewContoller {
    private func configure() {
        self.view.backgroundColor = .systemBackground
        
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
}

extension BookSearchViewContoller: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    
}

extension BookSearchViewContoller: UICollectionViewDelegate {
    
}


extension BookSearchViewContoller: UICollectionViewDelegateFlowLayout {
    
}
