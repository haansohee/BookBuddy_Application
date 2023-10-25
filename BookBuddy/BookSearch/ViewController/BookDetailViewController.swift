//
//  BookDetailViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/20/23.
//

import Foundation
import UIKit

final class BookDetailViewController: UIViewController {
    private let bookDetailView = BookDetailView()
    private let viewModel = BookSearchViewModel()
    
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
        if let imageURL = URL(string: bookData.image) {
            viewModel.loadImageData(imageURL: imageURL) { [weak self] data in
                self?.viewModel.setBookInformationData(title: bookData.title, author: bookData.author, category: category, description: bookData.description, image: data)
                guard let information = self?.viewModel.bookInformations else { return }
                self?.bookDetailView.setBookInformation(information)
            }
        }
    }
}
