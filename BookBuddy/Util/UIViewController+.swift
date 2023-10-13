//
//  UIViewController+.swift
//  BookBuddy
//
//  Created by 한소희 on 10/12/23.
//

import UIKit

extension UIViewController {
    func hideKeyboard() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
