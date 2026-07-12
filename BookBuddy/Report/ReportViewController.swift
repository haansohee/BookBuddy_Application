//
//  ReportViewController.swift
//  BookBuddy
//
//  Created by 한소희 on 2/19/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ReportViewController: UIViewController {
    private let reportView = ReportView()
    private let disposeBag = DisposeBag()
    private var endEditingGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureReportView()
        setLayoutContraints()
        addEditingTapGesture()
        bindAll()
    }
}

extension ReportViewController {
    private func configureReportView() {
        view.backgroundColor = .clear
        view.addSubview(reportView)
        reportView.translatesAutoresizingMaskIntoConstraints = false
        reportView.reportContentTextView.delegate = self
    }
    
    private func setLayoutContraints() {
        NSLayoutConstraint.activate([
            reportView.topAnchor.constraint(equalTo: view.topAnchor),
            reportView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reportView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reportView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    
    private func submitSuccessAlert() {
        let alertController = UIAlertController(title: "접수 완료", message: "회원님의 신고가 정상적으로 제출되었어요. \n 소중한 피드백 감사합니다. 🙂", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .default) {[weak self] _ in
            self?.dismiss(animated: true)
        }
        alertController.addAction(doneAction)
        present(alertController, animated: true)
    }
    
    private func bindAll() {
        bindSubmitButton()
        bindCancelButton()
    }
    
    private func bindSubmitButton() {
        reportView.submitButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.submitSuccessAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCancelButton() {
        reportView.cancelButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension ReportViewController: UITextViewDelegate {
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
