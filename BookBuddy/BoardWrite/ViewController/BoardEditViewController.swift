//
//  BoardEditViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 2/13/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class BoardEditViewController: UIViewController {
    private let boardEditView = BoardWriteView()
    private let boardEditViewModel = BoardEditViewModel()
    private let disposeBag = DisposeBag()
    private var endEditingGesture: UITapGestureRecognizer?
    
    init(_ boardEditInformation: BoardEditInformation) {
        super.init(nibName: nil, bundle: nil)
        boardEditViewModel.setBoardEditInformation(boardEditInformation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBoardEditView()
        addSubviews()
        setLayoutConstraints()
        settingBoardEditView()
        addEditingTapGesture()
        imageUploadTapGesture()
        bindAll()
    }
}

extension BoardEditViewController {
    private func configureBoardEditView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "수정하기"
        boardEditView.translatesAutoresizingMaskIntoConstraints = false
        boardEditView.titleTextField.delegate = self
        boardEditView.contentTextView.delegate = self
        boardEditView.imagePickerView.delegate = self
        boardEditView.imagePickerView.sourceType = .photoLibrary
        boardEditView.uploadButton.setTitle("수정하기", for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: boardEditView.uploadButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소하기", style: .plain, target: self, action: #selector(tapCancelButton))
        navigationItem.leftBarButtonItem?.tintColor = .systemGreen
    }
    
    private func addSubviews() {
        view.addSubview(boardEditView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            boardEditView.topAnchor.constraint(equalTo: view.topAnchor),
            boardEditView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardEditView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardEditView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func settingBoardEditView() {
        guard let boardEditInformation = boardEditViewModel.boardEditInformation else { return }
        boardEditView.titleTextField.text = boardEditInformation.contentTitle
        boardEditView.contentTextView.text = boardEditInformation.content
        boardEditView.imageView.image = UIImage(data: boardEditInformation.boardImage)
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
    
    
    @objc private func tapCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func imageUploadTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapGesture))
        boardEditView.imageView.isUserInteractionEnabled = true
        boardEditView.imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func imageViewTapGesture() {
        let actionSheetController = UIAlertController(title: "글 대표 이미지", message: "이미지를 업로드할까요?", preferredStyle: .actionSheet)
        
        let uploadAction = UIAlertAction(title: "앨범에서 선택하기", style: .default) { [weak self] _ in
            guard let imagePickerViewController = self?.boardEditView.imagePickerView else { return }
            imagePickerViewController.allowsEditing = true
            self?.present(imagePickerViewController, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheetController.addAction(uploadAction)
        actionSheetController.addAction(cancelAction)
        
        present(actionSheetController, animated: true)
    }
    
    private func boardBlankAlert(message: String) {
        let alertActionController = UIAlertController(title: "모두 작성해 주세요.", message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .default)
        alertActionController.addAction(doneAction)
        present(alertActionController, animated: true)
    }
    
    private func bindAll() {
        bindUploadButton()
        bindIsBoardInfoUpdated()
    }
    
    private func bindUploadButton() {
        boardEditView.uploadButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let contentTitle = self?.boardEditView.titleTextField.text,
                      let content = self?.boardEditView.contentTextView.text else { return }
                
                if (contentTitle == "") {
                    self?.boardBlankAlert(message: "글 제목을 입력해 주세요.")
                } else if (content == "") {
                    self?.boardBlankAlert(message: "글 내용을 입력해 주세요.")
                }
                
                guard let boardImage = self?.boardEditView.imageView.image?.pngData() else {
                    self?.boardBlankAlert(message: "게시물을 대표할 이미지를 선택해 주세요.")
                    return
                }
                
                guard let postID = self?.boardEditViewModel.boardEditInformation?.postID,
                      let nickname = self?.boardEditViewModel.boardEditInformation?.nickname else { return }
                let boardEditInformation = BoardEditInformation(postID: postID, nickname: nickname, contentTitle: contentTitle, content: content, boardImage: boardImage)
                self?.boardEditViewModel.updateBoardInformation(boardEditInformation)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsBoardInfoUpdated() {
        boardEditViewModel.isBoardInfoUpdated
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isBoardInfoUpdated in
                guard isBoardInfoUpdated else { return }
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension BoardEditViewController: UITextFieldDelegate {
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

extension BoardEditViewController: UITextViewDelegate {
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

extension BoardEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        boardEditView.imageView.image = editedImage
        dismiss(animated: true)
    }
}
