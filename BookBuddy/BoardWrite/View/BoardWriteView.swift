//
//  BoardWriteView.swift
//  BookBuddy
//
//  Created by 한소희 on 12/19/23.
//

import UIKit

final class BoardWriteView: UIView {
    let imagePickerView: UIImagePickerController = {
        let imagePickerView = UIImagePickerController()
        return imagePickerView
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "글의 제목을 입력하세요."
        textField.font = .systemFont(ofSize: 16.0, weight: .bold)
        textField.textColor = .label
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let titleLineView: LineView = {
        let lineView = LineView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    let uploadButton: AnimationButton = {
        let button = AnimationButton()
        button.setTitle("업로드", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .light)
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "게시글을 대표할 사진을 선택해 보세요."
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13.0, weight: .light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemBackground
        imageView.image = UIImage(systemName: "photo.circle")
        imageView.tintColor = .label
        return imageView
    }()
    
    private let imageLineView: LineView = {
        let lineView = LineView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14.0, weight: .light)
        textView.textAlignment = .left
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5.0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BoardWriteView {
    private func addSubViews() {
        [
            titleTextField,
            titleLineView,
            descriptionLabel,
            imageView,
            imageLineView,
            contentTextView
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            titleTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            titleTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            titleTextField.heightAnchor.constraint(equalToConstant: 40.0),
            
            titleLineView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4.0),
            titleLineView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            titleLineView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            titleLineView.heightAnchor.constraint(equalToConstant: 0.5),
    
            contentTextView.topAnchor.constraint(equalTo: titleLineView.bottomAnchor, constant: 4.0),
            contentTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            contentTextView.heightAnchor.constraint(equalToConstant: 280.0),
            
            imageLineView.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 4.0),
            imageLineView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            imageLineView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            imageLineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageLineView.bottomAnchor, constant: 4.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4.0),
            imageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300.0),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
}
