//
//  CommentPostView.swift
//  BookBuddy
//
//  Created by 한소희 on 1/30/24.
//

import UIKit

final class CommentPostView: UIView {
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "댓글을 작성해 보세요. 😀"
        textView.textColor = .lightGray
        textView.font = .systemFont(ofSize: 11.0)
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 6.0
        textView.textAlignment = .left
        return textView
    }()
    
    let commentPostButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("게시", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.layer.cornerRadius = 6.0
        return button
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

extension CommentPostView {
    private func addSubviews() {
        [
            commentTextView,
            commentPostButton
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            commentTextView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5.0),
            commentTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10.0),
            commentTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5.0),
            commentTextView.widthAnchor.constraint(equalToConstant: 300.0),
            
            commentPostButton.centerYAnchor.constraint(equalTo: commentTextView.centerYAnchor),
            commentPostButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10.0),
            commentPostButton.heightAnchor.constraint(equalToConstant: 30.0),
            commentPostButton.widthAnchor.constraint(equalToConstant: 50.0)
        ])
    }
}
