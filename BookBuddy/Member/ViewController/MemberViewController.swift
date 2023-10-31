//
//  MemberViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 10/28/23.
//

import Foundation
import UIKit

final class MemberViewController: UIViewController {
    private let memberView = MemberView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMemberView()
        setLayoutConstraintsMemberView()
    }
}

extension MemberViewController {
    private func configureMemberView() {
        self.view.addSubview(memberView)
        memberView.translatesAutoresizingMaskIntoConstraints = false
        memberView.boardCollectionView.dataSource = self
        memberView.boardCollectionView.delegate = self
}
    
    private func setLayoutConstraintsMemberView() {
        NSLayoutConstraint.activate([
            memberView.topAnchor.constraint(equalTo: self.view.topAnchor),
            memberView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            memberView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            memberView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension MemberViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardCollectionViewCell", for: indexPath) as? BoardCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}

extension MemberViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 3 - 10
    
        return CGSize(width: width, height: width)
    }
}

