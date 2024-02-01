//
//  ActivityIndicatorView.swift
//  BookBuddy
//
//  Created by 한소희 on 1/31/24.
//

import Foundation
import UIKit

final class ActivityIndicatorViewController: UIViewController {
    private let buttonActivityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        return activity
    }()
    
    private let loadingTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "로딩 중이에요. 🏃🏻 \n 잠시만 기다려 주세요!"
        label.textColor = .label
        label.backgroundColor = .systemBackground
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        label.layer.cornerRadius = 25
        return label
    }()
    
    private let viewActivityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.backgroundColor = .systemBackground
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        activity.layer.cornerRadius = 25
        return activity
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubivews()
        configureActivityIndicator()
        setLayoutConfigure()
    }
}

extension ActivityIndicatorViewController {
    private func addSubivews() {
        view.addSubview(containerView)
        [
            loadingTitleLabel,
            viewActivityIndicator
        ].forEach { containerView.addSubview($0) }
    }
    private func configureActivityIndicator() {
        view.backgroundColor = .clear
        containerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        containerView.layer.shadowOffset = CGSize(width: 1, height: 4)
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOpacity = 1
        containerView.layer.cornerRadius = 25
        containerView.clipsToBounds = true
        viewActivityIndicator.center = containerView.center
        viewActivityIndicator.style = .large
        viewActivityIndicator.color = .systemGreen
        viewActivityIndicator.startAnimating()
                
    }
    
    private func setLayoutConfigure() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 367.0),
            containerView.widthAnchor.constraint(equalToConstant: 315.0),
            
            viewActivityIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20.0),
            viewActivityIndicator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            viewActivityIndicator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0),
            
            loadingTitleLabel.topAnchor.constraint(equalTo: viewActivityIndicator.bottomAnchor),
            loadingTitleLabel.leadingAnchor.constraint(equalTo: viewActivityIndicator.leadingAnchor),
            loadingTitleLabel.trailingAnchor.constraint(equalTo: viewActivityIndicator.trailingAnchor),
            loadingTitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20.0),
            loadingTitleLabel.heightAnchor.constraint(equalToConstant: 60.0)
        ])
    }
    
    func startButtonTapped(_ sender: Any) {
        guard let button = sender as? AnimationButton else { return }
        buttonActivityIndicator.center = CGPoint(x: button.bounds.midX, y: button.bounds.midY)
        button.setTitle(nil, for: .normal)
        buttonActivityIndicator.style = .medium
        buttonActivityIndicator.startAnimating()
        button.addSubview(buttonActivityIndicator)
    }
    
    func stopButtonTapped(_ sender: Any) {
        guard let button = sender as? AnimationButton else { return }
        buttonActivityIndicator.stopAnimating()
        buttonActivityIndicator.removeFromSuperview()
        button.setTitle("게시", for: .normal)
    }
}
