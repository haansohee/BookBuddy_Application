//
//  HomeView.swift
//  BookBuddy
//
//  Created by 한소희 on 10/6/23.
//

import UIKit

final class HomeView: UIView {
    private let testLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "테스트입니다. 홈홈홈홈"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView {
    private func addSubviews() {
        addSubview(testLabel)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
