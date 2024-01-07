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
    
    private func uploadSuccessAlert(title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.boardWriteView.titleTextField.text = ""
            self?.boardWriteView.contentTextView.text = ""
        }
        alertController.addAction(doneAction)
        present(alertController, animated: true)
    }
    
    private func bindAll() {
        bindJoinButton()
        bindUploadButton()
        bindIsUpload()
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
                      let nickname = UserDefaults.standard.string(forKey: "nickname")
                else { return }
                
                if (contentTitle == "") ||
                    (content == "") { return }
                
                self?.dateFormatter.dateFormat = "yyyy-MM-dd"
                guard let date = self?.dateFormatter.string(from: Date()) else { return }
                let boardWriteInformation = BoardWriteInformation(nickname: nickname, writeDate: date, contentTitle: contentTitle, content: content)
                self?.viewModel.uploadBoard(boardWriteInformation: boardWriteInformation)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUpload() {
        viewModel.isUpload
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
