//
//  BoardSearchViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 1/8/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class BoardSearchViewController: UIViewController {
    enum ViewType {
        case boardSearch
        case recentSearch
    }
    
    private let boardSearchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "사용자 혹은 게시물을 검색할 수 있어요."
        label.textColor = .lightGray
        label.backgroundColor = .systemBackground
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    private var viewType: ViewType
    private let searchController = SearchController()
    private let boardSearchView = BoardSearchView()
    private let recentSearchView = RecentSearchView()
    private let boardSearchViewModel = BoardSearchViewModel()
    private let disposeBag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.viewType = .recentSearch
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupBoardSearchViewController()
        setLayoutContraintsBoardSearchView()
        bindIsLoadedBoardSearchResults()
    }
    
    private func setupSearchController() {
        searchController.setupSearchController()
        searchController.searchBar.searchTextField.delegate = self
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupBoardSearchViewController() {
        self.view.backgroundColor = .systemBackground
        [
            boardSearchLabel,
            recentSearchView
        ].forEach { self.view.addSubview($0) }
        boardSearchLabel.translatesAutoresizingMaskIntoConstraints = false
        boardSearchView.translatesAutoresizingMaskIntoConstraints = false
        recentSearchView.translatesAutoresizingMaskIntoConstraints = false
        boardSearchView.delegate = self
        boardSearchView.dataSource = self
        recentSearchView.recentSearchCollectionView.delegate = self
        recentSearchView.recentSearchCollectionView.dataSource = self
    }
    
    private func changeBoardSearchView(_ type: ViewType) {
        switch type {
        case .boardSearch:
            self.view.addSubview(boardSearchView)
            recentSearchView.removeFromSuperview()
        case .recentSearch:
            self.view.addSubview(recentSearchView)
            boardSearchView.removeFromSuperview()
        }
    }
    
    private func setLayoutContraintsBoardSearchView() {
        switch viewType {
        case .boardSearch:
            NSLayoutConstraint.activate([
                boardSearchLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                boardSearchLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                boardSearchLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                boardSearchLabel.heightAnchor.constraint(equalToConstant: 30.0),
                
                boardSearchView.topAnchor.constraint(equalTo: boardSearchLabel.bottomAnchor, constant: 2.0),
                boardSearchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                boardSearchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                boardSearchView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        case .recentSearch:
            NSLayoutConstraint.activate([
                boardSearchLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                boardSearchLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                boardSearchLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                boardSearchLabel.heightAnchor.constraint(equalToConstant: 30.0),
                
                recentSearchView.topAnchor.constraint(equalTo: boardSearchLabel.bottomAnchor, constant: 2.0),
                recentSearchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                recentSearchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                recentSearchView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }
    }
    
    private func bindIsLoadedBoardSearchResults() {
        boardSearchViewModel.isLoadedBoardSearchResults
            .subscribe(onNext: {[weak self] isLoadedBoardSearchResults in
                guard isLoadedBoardSearchResults else { return }
                guard let resultsCount = self?.boardSearchViewModel.boardSearchResultsInformations?.count else { return }
                DispatchQueue.main.async {
                    self?.boardSearchView.reloadData()
                    self?.boardSearchLabel.text = "\(resultsCount)개의 검색 결과입니다."
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func cellDeleteButtonTap(sender: AnimationButton) {
        recentSearchView.recentSearchCollectionView.performBatchUpdates {
            boardSearchViewModel.deleteRecentSearchWord(sender.tag)
            recentSearchView.recentSearchCollectionView.deleteItems(at: [IndexPath(row: sender.tag, section: 0)])
        } completion: { [weak self] _ in
            DispatchQueue.main.async {
                self?.recentSearchView.recentSearchCollectionView.reloadData()
            }
        }
    }
}

extension BoardSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchWord = textField.text else { return true }
        if searchWord == "" { return true }
        viewType = .boardSearch
        boardSearchViewModel.getBoardSearchResultsInformation(searchWord: searchWord)
        boardSearchViewModel.setRecentSearchWord(searchWord)
        DispatchQueue.main.async { [weak self] in
            guard let viewType = self?.viewType else { return }
            self?.changeBoardSearchView(viewType)
            self?.setLayoutContraintsBoardSearchView()
            self?.boardSearchLabel.text = "검색 중...🔎"
        }
        return true
    }
}

extension BoardSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewType = .recentSearch
        DispatchQueue.main.async { [weak self] in
            guard let viewType = self?.viewType else { return }
            self?.changeBoardSearchView(viewType)
            self?.setLayoutContraintsBoardSearchView()
            self?.boardSearchLabel.text = "사용자 혹은 게시물을 검색할 수 있어요."
            self?.recentSearchView.recentSearchCollectionView.reloadData()
        }
    }
}

extension BoardSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewType {
        case .boardSearch:
            guard let boardSearchResults = boardSearchViewModel.boardSearchResultsInformations?.count else {
                return 0
            }
            return boardSearchResults
        case .recentSearch:
            guard let recentSearchCounts = UserDefaults.standard.array(forKey: "recentSearch")?.count else { return 5 }
            return recentSearchCounts
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewType {
        case .boardSearch:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardSearchViewCell", for: indexPath) as? BoardSearchViewCell else { return UICollectionViewCell() }
            guard let boardSearchResultsInformation = boardSearchViewModel.boardSearchResultsInformations else {  return UICollectionViewCell() }
            
            if let profileImage = boardSearchResultsInformation[indexPath.row].profileImage {
                cell.profileImageView.image = UIImage(data: profileImage)
            } else {
                cell.profileImageView.image = UIImage(systemName: "person")
            }
                
            cell.setBoardSearchViewCell(boardSearchResultsInfo: boardSearchResultsInformation[indexPath.row])
            return cell
            
        case .recentSearch:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentSearchViewCell", for: indexPath) as? RecentSearchViewCell else { return UICollectionViewCell() }
            guard let recentSearchInformation = UserDefaults.standard.array(forKey: "recentSearch"),
                  let recentSearchWord = recentSearchInformation[indexPath.row] as? String else { return cell }
            cell.setSearchWordLabel(recentSearchWord)
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(cellDeleteButtonTap(sender:)), for: .touchUpInside)
            return cell
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension BoardSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.boardSearchView:
            let width = collectionView.bounds.width - 20
            let height = collectionView.bounds.height + 20
            return CGSize(width: width, height: height)
        case self.recentSearchView.recentSearchCollectionView:
            let width = collectionView.bounds.width - 10
            let height = 40.0
            return CGSize(width: width, height: height)
        default:
            return CGSize()
        }
    }
}
