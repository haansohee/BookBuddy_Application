//
//  BookSearchView.swift
//  BookBuddy
//
//  Created by 한소희 on 10/5/23.
//

import UIKit

final class BookSearchView: UIView {
    let searchTextField: UITextField = {
        let textField =  UITextField()
        textField.placeholder = "🔍 책 이름 혹은 책 장르로 검색해 보세요."
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let searchResultCountLabel: UILabel = {
        let label = UILabel()
        label.text = "무슨 책을 찾으시나요? 🧐"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
         
        return label
    }()
    
    let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 370)
        layout.minimumLineSpacing = 10.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: "SearchResultCell")
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.backgroundColor = .systemBackground
        collectionView.isPagingEnabled = false
        
        return collectionView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookSearchView {
    private func addSubviews() {
        [
            searchTextField,
            searchButton,
            searchResultCountLabel,
            searchResultsCollectionView
        ].forEach { addSubview($0)}
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            searchTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            searchTextField.heightAnchor.constraint(equalToConstant: 40.0),
            searchTextField.widthAnchor.constraint(equalToConstant: 330.0),
            
            searchButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            searchButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            searchButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            searchButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            searchResultCountLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 12.0),
            searchResultCountLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            searchResultCountLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            searchResultCountLabel.heightAnchor.constraint(equalToConstant: 60.0),
            
            searchResultsCollectionView.topAnchor.constraint(equalTo: searchResultCountLabel.bottomAnchor, constant: 12.0),
            searchResultsCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            searchResultsCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            searchResultsCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
