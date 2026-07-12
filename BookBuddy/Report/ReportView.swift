//
//  ReportView.swift
//  BookBuddy
//
//  Created by 한소희 on 2/19/24.
//

import UIKit

final class ReportView: UIView {
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "신고 사유를 작성해 주세요."
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    let reportContentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemBackground
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 3.0
        textView.font = .systemFont(ofSize: 11.0, weight: .light)
        textView.textColor = .label
        return textView
    }()
    
    let submitButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("제출하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 11.0)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    let cancelButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("취소하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 11.0)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .systemBackground
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black.withAlphaComponent(0.3)
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReportView {
    private func addSubviews() {
        [
            titleLabel,
            reportContentTextView,
            submitButton,
            cancelButton
        ].forEach { containerView.addSubview($0) }
        self.addSubview(containerView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 180.0),
            containerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50.0),
            containerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50.0),
            containerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -260.0),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5.0),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40.0),
            titleLabel.widthAnchor.constraint(equalToConstant: 180.0),
            
            reportContentTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            reportContentTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.0),
            reportContentTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.0),
            
            submitButton.topAnchor.constraint(equalTo: reportContentTextView.bottomAnchor, constant: 8.0),
            submitButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 34.0),
            submitButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12.0),
            submitButton.heightAnchor.constraint(equalToConstant: 35.0),
            submitButton.widthAnchor.constraint(equalToConstant: 60.0),
            
            cancelButton.topAnchor.constraint(equalTo: submitButton.topAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -34.0),
            cancelButton.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalTo: submitButton.heightAnchor),
            cancelButton.widthAnchor.constraint(equalTo: submitButton.widthAnchor)
        ])
    }
}
