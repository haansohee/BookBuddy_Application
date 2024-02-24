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
    private let boardSearchCollectionView = BoardSearchCollectionView()
    private let recentSearchView = RecentSearchView()
    private let boardSearchViewModel = BoardSearchViewModel()
    private let homeViewModel = HomeViewModel()
    private let commentViewModel = CommentViewModel()
    private let disposeBag = DisposeBag()
    private var endEditingGesture: UITapGestureRecognizer?
    private var viewTapGesture: UITapGestureRecognizer?
    
    init() {
        self.viewType = .recentSearch
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupBoardSearchViewController()
        setLayoutContraintsBoardSearchView()
        configureRefreshControl()
        bindIsLoadedBoardSearchResults()
        addEditingTapGesture()
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
        navigationItem.title = "둘러보기"
        [
            boardSearchLabel,
            recentSearchView
        ].forEach { self.view.addSubview($0) }
        boardSearchLabel.translatesAutoresizingMaskIntoConstraints = false
        boardSearchCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recentSearchView.translatesAutoresizingMaskIntoConstraints = false
        boardSearchCollectionView.delegate = self
        boardSearchCollectionView.dataSource = self
        recentSearchView.recentSearchCollectionView.delegate = self
        recentSearchView.recentSearchCollectionView.dataSource = self
    }
    
    private func changeBoardSearchView(_ type: ViewType) {
        switch type {
        case .boardSearch:
            self.view.addSubview(boardSearchCollectionView)
            recentSearchView.removeFromSuperview()
        case .recentSearch:
            self.view.addSubview(recentSearchView)
            boardSearchCollectionView.removeFromSuperview()
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
                
                boardSearchCollectionView.topAnchor.constraint(equalTo: boardSearchLabel.bottomAnchor, constant: 2.0),
                boardSearchCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                boardSearchCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                boardSearchCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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
    
    private func addEditingTapGesture() {
        endEditingGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.endEditingGesture?.isEnabled = false
        guard let endEditingGesture = endEditingGesture else { return }
        self.view.addGestureRecognizer(endEditingGesture)
    }
    
    @objc private func endEditing() {
        self.view.endEditing(true)
    }
    
    private func configureRefreshControl() {
        boardSearchCollectionView.refreshControl = UIRefreshControl()
        boardSearchCollectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        guard let searchWord = searchController.searchBar.searchTextField.text else { return }
        boardSearchViewModel.getBoardSearchResultsInformation(searchWord: searchWord)
    }
    
    private func bindIsLoadedBoardSearchResults() {
        boardSearchViewModel.isLoadedBoardSearchResults
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedBoardSearchResults in
                guard isLoadedBoardSearchResults else { return }
                guard let resultsCount = self?.boardSearchViewModel.boardSearchResultsInformations?.count else { return }
                self?.searchController.searchBar.searchTextField.resignFirstResponder()
                self?.boardSearchCollectionView.reloadData()
                self?.boardSearchLabel.text = "\(resultsCount)개의 검색 결과입니다."
                self?.boardSearchCollectionView.refreshControl?.endRefreshing()
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
    
    @objc private func searchMemberNicknameTapGesture(nickname: TapGestureRelayValue) {
        guard let nickname = nickname.nickname else { return }
        navigationController?.pushViewController(BoardSearchMemberViewController(nickname: nickname), animated: true)
    }
    
    @objc private func searchWordLabelTapGesture(word: TapGestureRelayValue) {
        guard let searchWord = word.seachWord else { return }
        viewType = .boardSearch
        boardSearchViewModel.getBoardSearchResultsInformation(searchWord: searchWord)
        boardSearchViewModel.setRecentSearchWord(searchWord)
        changeBoardSearchView(viewType)
        setLayoutContraintsBoardSearchView()
        boardSearchLabel.text = "검색 중...🔎"
        searchController.searchBar.searchTextField.text = searchWord
    }
    
    private func changeLikeCountLabelValue(label: UILabel, deleteLike: Bool) {
        guard deleteLike else {
            if let labelText = label.text {
                if var labelTextValue = Int(labelText) {
                    labelTextValue += 1
                    label.text = String(labelTextValue)
                }
            }
            return
        }
        if let labelText = label.text {
            if var labelTextValue = Int(labelText) {
                labelTextValue -= 1
                label.text = String(labelTextValue)
            }
        }
    }
}

extension BoardSearchViewController: UISearchTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewType = .recentSearch
        changeBoardSearchView(viewType)
        setLayoutContraintsBoardSearchView()
        self.endEditingGesture?.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.endEditingGesture?.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchWord = textField.text else { return true }
        if searchWord.isEmpty { return true }
        viewType = .boardSearch
        boardSearchViewModel.getBoardSearchResultsInformation(searchWord: searchWord)
        boardSearchViewModel.setRecentSearchWord(searchWord)
        changeBoardSearchView(viewType)
        setLayoutContraintsBoardSearchView()
        boardSearchLabel.text = "검색 중...🔎"
        self.endEditingGesture?.isEnabled = false
        return true
    }
}

extension BoardSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewType = .recentSearch
        changeBoardSearchView(viewType)
        setLayoutContraintsBoardSearchView()
        boardSearchLabel.text = "사용자 혹은 게시물을 검색할 수 있어요."
        recentSearchView.recentSearchCollectionView.reloadData()
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
            guard let recentSearchCounts = UserDefaults.standard.array(forKey: UserDefaultsForkey.recentSearch.rawValue)?.count else { return 0 }
            return recentSearchCounts
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewType {
        case .boardSearch:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardSearchViewCell.reuseIdentifier, for: indexPath) as? BoardSearchViewCell else { return UICollectionViewCell() }
            guard let boardSearchResultsInformation = boardSearchViewModel.boardSearchResultsInformations else {  return cell }
            if let profileImage = boardSearchResultsInformation[indexPath.row].profileImage {
                cell.profileImageView.image = UIImage(data: profileImage)
            } else {
                cell.profileImageView.image = UIImage(systemName: "person")
            }
            cell.commentCountLabel.text = String(boardSearchResultsInformation[indexPath.row].comments.count)
            cell.setBoardSearchViewCell(boardSearchResultsInfo: boardSearchResultsInformation[indexPath.row])
            if boardSearchResultsInformation[indexPath.row].didLike {
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                cell.likeButton.tag = 1
            } else {
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.likeButton.tag = 0
            }
            
            let viewTapGesture = TapGestureRelayValue(target: self, action: #selector(searchMemberNicknameTapGesture(nickname:)))
            viewTapGesture.nickname = boardSearchResultsInformation[indexPath.row].nickname
            cell.touchStackView.addGestureRecognizer(viewTapGesture)
            
            cell.rx.likeButtonTapped
                .asDriver()
                .drive(onNext: {[weak self] _ in
                    guard let likedUserID = self?.boardSearchViewModel.userID else { return }
                    let boardLikeInformation = BoardLikeInformation(likedUserID: likedUserID, postUserNickname: boardSearchResultsInformation[indexPath.row].nickname, postID: boardSearchResultsInformation[indexPath.row].postID)
                    
                    switch cell.likeButton.tag {
                    case 1:
                        self?.homeViewModel.deleteBoardLikeInformation(boardLikeInformation) { result in
                            guard result else { return }
                            DispatchQueue.main.async {
                                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                                cell.likeButton.tag = 0
                                self?.changeLikeCountLabelValue(label: cell.likeCountLabel, deleteLike: true)
                            }
                        }
                    case 0:
                        self?.homeViewModel.setBoardLikeInformation(boardLikeInformation) { result in
                            guard result else { return }
                            DispatchQueue.main.async {
                                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                                cell.likeButton.tag = 1
                                self?.changeLikeCountLabelValue(label: cell.likeCountLabel, deleteLike: false)
                            }
                        }
                    default:
                        return
                    }
                })
                .disposed(by: cell.disposeBag)
            
            cell.rx.commentButtonTapped
                .asDriver()
                .drive(onNext: {[weak self] _ in
                    self?.present(CommentViewController(postID: boardSearchResultsInformation[indexPath.row].postID, commentInformation: boardSearchResultsInformation[indexPath.row].comments), animated: true)
                })
                .disposed(by: cell.disposeBag)
            
            let reportAction = UIAction(title: "신고하기",
                                      image: UIImage(systemName: "exclamationmark.bubble"),
                                      attributes: .destructive,
                                      handler: { [weak self] _ in
                let reportViewController = ReportViewController()
                reportViewController.modalPresentationStyle = .overFullScreen
                self?.present(reportViewController, animated: true)
            })

            if boardSearchResultsInformation[indexPath.row].postFromUser {
                cell.ellipsisButton.isHidden = true
            } else {
                cell.ellipsisButton.isHidden = false
                cell.ellipsisButton.menu = UIMenu(children: [reportAction])
            }
            
            return cell
            
        case .recentSearch:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchViewCell.reuseIdentifier, for: indexPath) as? RecentSearchViewCell else { return UICollectionViewCell() }
            guard let recentSearchInformation = UserDefaults.standard.array(forKey: UserDefaultsForkey.recentSearch.rawValue),
                  let recentSearchWord = recentSearchInformation[indexPath.row] as? String else { return cell }
            let labelTapGesture = TapGestureRelayValue(target: self, action: #selector(searchWordLabelTapGesture(word:)))
            labelTapGesture.seachWord = recentSearchWord
            cell.addGestureRecognizer(labelTapGesture)
            cell.searchWordLabel.text = recentSearchWord
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(cellDeleteButtonTap(sender:)), for: .touchUpInside)
            return cell
        }
    }
}

extension BoardSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.boardSearchCollectionView:
            let width = collectionView.bounds.width - 20
            let height = collectionView.bounds.height + 70
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
