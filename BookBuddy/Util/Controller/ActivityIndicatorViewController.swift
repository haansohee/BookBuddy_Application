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
    
    private let viewActivityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad
    () {
        super.viewDidLoad()
        addSubivews()
        configureActivityIndicator()
        setLayoutConfigure()
    }
}

extension ActivityIndicatorViewController {
    private func addSubivews() {
        view.addSubview(viewActivityIndicator)
    }
    private func configureActivityIndicator() {
        view.backgroundColor = .clear
        viewActivityIndicator.center = view.center
        viewActivityIndicator.style = .large
        viewActivityIndicator.color = .systemGreen
        viewActivityIndicator.startAnimating()
                
    }
    
    private func setLayoutConfigure() {
        NSLayoutConstraint.activate([
            viewActivityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            viewActivityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            viewActivityIndicator.widthAnchor.constraint(equalToConstant: 315),
            viewActivityIndicator.heightAnchor.constraint(equalToConstant: 315)
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
