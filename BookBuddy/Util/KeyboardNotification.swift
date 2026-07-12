//
//  KeyboardNotification.swift
//  BookBuddy
//
//  Created by 한소희 on 2/1/24.
//

import Foundation
import UIKit
import RxSwift

final class KeyboardNotification {
    private let disposeBag = DisposeBag()
    
    func setKeyboardNotification(_ view: UIView) {
        let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
        
        keyboardWillShow
            .asDriver(onErrorRecover: { _ in .never() })
            .drive(onNext: {[weak self] notification in
                self?.handleKeyboardWillShow(notification, view)
            })
            .disposed(by: disposeBag)
        
        keyboardWillHide
            .asDriver(onErrorRecover: { _ in . never() })
            .drive(onNext: {[weak self] notification in
                self?.handleKeyboardWillHide(notification, view)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleKeyboardWillShow(_ notification: Notification, _ view: UIView) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= (keyboardFrame.height)
        }
    }
    
    private func handleKeyboardWillHide(_ notification: Notification, _ view: UIView) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    func scrollViewSetKeyboardNotification(_ view: UIScrollView) {
        let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
        
        keyboardWillShow
            .asDriver(onErrorRecover: { _ in .never() })
            .drive(onNext: {[weak self] notification in
                self?.scrollViewHandleKeyboardWillShow(notification, view)
            })
            .disposed(by: disposeBag)
        
        keyboardWillHide
            .asDriver(onErrorRecover: { _ in . never() })
            .drive(onNext: {[weak self] notification in
                self?.scrollViewHandleKeyboardWillShow(notification, view)
            })
            .disposed(by: disposeBag)
    }
    
    private func scrollViewHandleKeyboardWillShow(_ notification: Notification, _ view: UIScrollView) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInset = UIEdgeInsets(top: 0.0,
                                        left: 0.0,
                                        bottom: (keyboardFrame.size.height)
                                        , right: 0.0)
        view.contentInset = contentInset
        view.scrollIndicatorInsets = contentInset
    }
    
    private func scrollViewHandleKeyboardWillHide(_ notification: Notification, _ view: UIScrollView) {
        let contentInset = UIEdgeInsets.zero
        view.contentInset = contentInset
        view.scrollIndicatorInsets = contentInset
    }
}
