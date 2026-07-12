//
//  BoardWriteView.swift
//  BookBuddy
//
//  Created by 한소희 on 12/19/23.
//

import UIKit

final class DashedBorderView: UIView {
    var isDashedBorderHidden: Bool = false {
        didSet { dashedBorderLayer.isHidden = isDashedBorderHidden }
    }

    private let dashedBorderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.systemGray3.cgColor
        layer.fillColor = nil
        layer.lineWidth = 1.0
        layer.lineDashPattern = [6, 4]
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(dashedBorderLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dashedBorderLayer.frame = bounds
        dashedBorderLayer.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: layer.cornerRadius
        ).cgPath
    }
}

final class BoardWriteView: UIView {
    let imagePickerView: UIImagePickerController = {
        let imagePickerView = UIImagePickerController()
        return imagePickerView
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let imageCardView: DashedBorderView = {
        let view = DashedBorderView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 14.0
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()

    private let imagePlaceholderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6.0
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let cameraIconImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 32.0, weight: .regular)
        imageView.image = UIImage(systemName: "camera.fill", withConfiguration: config)
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let imagePlaceholderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "사진을 추가하세요"
        label.textColor = .label
        label.font = .systemFont(ofSize: 15.0, weight: .semibold)
        return label
    }()

    private let imagePlaceholderSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "탭하여 선택"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13.0, weight: .semibold)
        return label
    }()

    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "글의 제목을 입력하세요"
        textField.font = .systemFont(ofSize: 16.0, weight: .semibold)
        textField.textColor = .label
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 10.0
        textField.translatesAutoresizingMaskIntoConstraints = false
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftView = leftPadding
        textField.leftViewMode = .always
        let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.rightView = rightPadding
        textField.rightViewMode = .always
        return textField
    }()

    private let contentSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "내용"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13.0, weight: .semibold)
        return label
    }()

    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15.0, weight: .regular)
        textView.textColor = .label
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 10.0
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    let contentPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 책을 읽으셨나요?"
        label.textColor = .tertiaryLabel
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let uploadButton: AnimationButton = {
        let button = AnimationButton()
        button.setTitle("업로드", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .semibold)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubViews()
        setLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSelectedImage(_ image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        imagePlaceholderStackView.isHidden = true
        imageCardView.isDashedBorderHidden = true
    }

    func resetSelectedImage() {
        imageView.image = nil
        imageView.isHidden = true
        imagePlaceholderStackView.isHidden = false
        imageCardView.isDashedBorderHidden = false
    }

    func updateContentPlaceholderVisibility() {
        contentPlaceholderLabel.isHidden = !contentTextView.text.isEmpty
    }
}

extension BoardWriteView {
    private func addSubViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        imagePlaceholderStackView.addArrangedSubview(cameraIconImageView)
        imagePlaceholderStackView.addArrangedSubview(imagePlaceholderTitleLabel)
        imagePlaceholderStackView.addArrangedSubview(imagePlaceholderSubtitleLabel)
        imageCardView.addSubview(imageView)
        imageCardView.addSubview(imagePlaceholderStackView)

        let titleContainer = UIStackView(arrangedSubviews: [titleSectionLabel, titleTextField])
        titleContainer.axis = .vertical
        titleContainer.spacing = 8.0

        let contentContainer = UIStackView(arrangedSubviews: [contentSectionLabel, contentTextView])
        contentContainer.axis = .vertical
        contentContainer.spacing = 8.0

        contentStackView.addArrangedSubview(imageCardView)
        contentStackView.addArrangedSubview(titleContainer)
        contentStackView.addArrangedSubview(contentContainer)

        contentTextView.addSubview(contentPlaceholderLabel)
    }

    private func setLayoutConstraints() {
        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: contentGuide.topAnchor, constant: 20.0),
            contentStackView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor, constant: 16.0),
            contentStackView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor, constant: -16.0),
            contentStackView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor, constant: -20.0),
            contentStackView.widthAnchor.constraint(equalTo: frameGuide.widthAnchor, constant: -32.0),

            imageCardView.heightAnchor.constraint(equalTo: imageCardView.widthAnchor, multiplier: 0.66),

            imagePlaceholderStackView.centerXAnchor.constraint(equalTo: imageCardView.centerXAnchor),
            imagePlaceholderStackView.centerYAnchor.constraint(equalTo: imageCardView.centerYAnchor),

            imageView.topAnchor.constraint(equalTo: imageCardView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageCardView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageCardView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageCardView.bottomAnchor),

            titleTextField.heightAnchor.constraint(equalToConstant: 48.0),

            contentTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 240.0),

            contentPlaceholderLabel.topAnchor.constraint(equalTo: contentTextView.topAnchor, constant: 12.0),
            contentPlaceholderLabel.leadingAnchor.constraint(equalTo: contentTextView.leadingAnchor, constant: 13.0),
        ])
    }
}
