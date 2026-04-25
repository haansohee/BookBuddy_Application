//
//  NotificationViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 3/19/24.
//

import Foundation
import UIKit
import SkeletonView
import RxSwift

final class NotificationViewController: UIViewController {
    private let notificationCollectionView = NotificationCollectionView()
    private let notificationViewModel = NotificationViewModel()
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        notificationViewModel.getNotificationInformation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubivews()
        configureNotificationView()
        setLayoutConstraintsNotificationView()
        isLoadedNotificationInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationViewModel.getNotificationInformation()
    }
}

extension NotificationViewController {
    private func configureNotificationView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "알림 🔔"
        notificationCollectionView.showAnimatedSkeleton()
        notificationCollectionView.translatesAutoresizingMaskIntoConstraints = false
        notificationCollectionView.dataSource = self
        notificationCollectionView.delegate = self
    }
    
    private func addSubivews() {
        view.addSubview(notificationCollectionView)
    }
    
    private func setLayoutConstraintsNotificationView() {
        NSLayoutConstraint.activate([
            notificationCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notificationCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            notificationCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            notificationCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func calculateCellHeight(textString: String) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-100, height: CGFloat.greatestFiniteMagnitude))
        label.text = textString
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12.0)
        label.sizeToFit()
        return label.frame.height + 70
    }
    
    private func isLoadedNotificationInfo() {
        notificationViewModel.isLoadedNotificationInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedNotificationInfo in
                guard isLoadedNotificationInfo else { return }
                self?.notificationCollectionView.hideSkeleton()
                self?.notificationCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionView DataSource
extension NotificationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard notificationViewModel.notificationInformation.isEmpty else { return notificationViewModel.notificationInformation.count }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCollectionViewCell.reuseIdentifier, for: indexPath) as? NotificationCollectionViewCell else { return UICollectionViewCell() }
        guard !notificationViewModel.notificationInformation.isEmpty else {
            cell.setIsHiddenOption(false)
            return cell
        }
        cell.setIsHiddenOption(true)
        cell.setNotificationInfo(notificationViewModel.notificationInformation[indexPath.row])
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NotificationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 10.0
        guard notificationViewModel.notificationInformation.isEmpty else {
            let height = 80.0
            return CGSize(width: width, height: height)
        }
        let height = collectionView.bounds.height - 50.0
        return CGSize(width: width, height: height)
    }
}
