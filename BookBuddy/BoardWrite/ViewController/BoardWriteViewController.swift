//
//  BoardWriteViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 12/19/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class BoardWriteViewController: UIViewController {
    enum ViewType {
        case notMember
        case member
    }
    
    private let boardWriteView = BoardWriteView()
    private let notMemberView = NotMemberView()
    private let viewModel = BoardWriteViewModel()
    private var viewType: ViewType
    private var endEditingGesture: UITapGestureRecognizer?
    private let disposeBag = DisposeBag()
    private let dateFormatter = DateFormatter()
    
    init(nickname: String? = nil) {
        viewType = nickname != nil ? .member : .notMember
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkMember()
        configureBoardWriteView()
        setLayoutConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addEditingTapGesture()
        imageUploadTapGesture()
        bindAll()
    }
}

extension BoardWriteViewController {
    private func configureBoardWriteView() {
        view.backgroundColor = .systemBackground
        switch viewType {
        case .notMember:
            notMemberView.translatesAutoresizingMaskIntoConstraints = false
        case .member:
            boardWriteView.translatesAutoresizingMaskIntoConstraints = false
            boardWriteView.titleTextField.delegate = self
            boardWriteView.contentTextView.delegate = self
            boardWriteView.imagePickerView.delegate = self
            boardWriteView.imagePickerView.sourceType = .photoLibrary
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: boardWriteView.uploadButton)
        }
    }
    
    private func setLayoutConstraints() {
        switch viewType {
        case .notMember:
            self.view.addSubview(notMemberView)
            boardWriteView.removeFromSuperview()
            NSLayoutConstraint.activate([
                notMemberView.topAnchor.constraint(equalTo: self.view.topAnchor),
                notMemberView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                notMemberView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                notMemberView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        case .member:
            self.view.addSubview(boardWriteView)
            notMemberView.removeFromSuperview()
            NSLayoutConstraint.activate([
                boardWriteView.topAnchor.constraint(equalTo: self.view.topAnchor),
                boardWriteView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                boardWriteView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                boardWriteView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }
    }
    
    private func checkMember() {
        guard UserDefaults.standard.string(forKey: "nickname") != nil else {
            viewType = .notMember
            return
        }
        viewType = .member
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
    
    private func imageUploadTapGesture() {
        print("imageUploadTapGesture")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapGesture))
        boardWriteView.imageView.isUserInteractionEnabled = true
        boardWriteView.imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func imageViewTapGesture() {
        print("imageViewTapGesture")
        let actionSheetController = UIAlertController(title: "글 대표 이미지", message: "이미지를 업로드할까요?", preferredStyle: .actionSheet)
        
        let uploadAction = UIAlertAction(title: "앨범에서 선택하기", style: .default) { [weak self] _ in
            guard let imagePickerViewController = self?.boardWriteView.imagePickerView else { return }
            imagePickerViewController.allowsEditing = true
            DispatchQueue.main.async {
                self?.present(imagePickerViewController, animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheetController.addAction(uploadAction)
        actionSheetController.addAction(cancelAction)
        
        present(actionSheetController, animated: true)
    }
    
    private func uploadSuccessAlert(title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.boardWriteView.titleTextField.text = ""
            self?.boardWriteView.contentTextView.text = ""
            self?.boardWriteView.imageView.image = UIImage(systemName: "photo")
            UserDefaults.standard.removeObject(forKey: "boardImage")
        }
        alertController.addAction(doneAction)
        present(alertController, animated: true)
    }
    
    private func boardBlankAlert(message: String) {
        let alertActionController = UIAlertController(title: "모두 작성해 주세요.", message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .default)
        alertActionController.addAction(doneAction)
        present(alertActionController, animated: true)
    }
    
    private func bindAll() {
        bindJoinButton()
        bindUploadButton()
        bindIsBoardUploaded()
    }
    
    private func bindJoinButton() {
        notMemberView.joinButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.pushViewController(MemberSigninViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUploadButton() {
        boardWriteView.uploadButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let contentTitle = self?.boardWriteView.titleTextField.text,
                      let content = self?.boardWriteView.contentTextView.text,
                      let nickname = UserDefaults.standard.string(forKey: "nickname") else { return }
                
                if (contentTitle == "") {
                    DispatchQueue.main.async {
                        self?.boardBlankAlert(message: "글 제목을 입력해 주세요.")
                    }
                } else if (content == "") {
                    DispatchQueue.main.async {
                        self?.boardBlankAlert(message: "글 내용을 입력해 주세요.")
                    }
                }
                
                guard let boardImage = UserDefaults.standard.data(forKey: "boardImage") else {
                    DispatchQueue.main.async {
                        self?.boardBlankAlert(message: "게시물을 대표할 이미지를 선택해 주세요.")
                    }
                    return
                }
                
                self?.dateFormatter.dateFormat = "yyyy-MM-dd"
                guard let date = self?.dateFormatter.string(from: Date()) else { return }
                let boardWriteInformation = BoardWriteInformation(nickname: nickname, writeDate: date, contentTitle: contentTitle, content: content, boardImage: boardImage)
                self?.viewModel.uploadBoard(boardWriteInformation: boardWriteInformation)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsBoardUploaded() {
        viewModel.isBoardUploaded
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isUpload in
                self?.uploadSuccessAlert(title: "업로드 완료", message: "성공적으로 업로드가 되었어요.")
            }).disposed(by: disposeBag)
    }
}

extension BoardWriteViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.endEditingGesture?.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.endEditingGesture?.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension BoardWriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.endEditingGesture?.isEnabled = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.endEditingGesture?.isEnabled = false
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

extension BoardWriteViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            boardWriteView.imageView.image = editedImage
            if let imageData = editedImage.pngData() {
                UserDefaults.standard.set(imageData, forKey: "boardImage")
            }
        } else {
            print("ERROR")
        }
        dismiss(animated: true)
    }
}

extension BoardWriteViewController: UINavigationControllerDelegate {
    
}
