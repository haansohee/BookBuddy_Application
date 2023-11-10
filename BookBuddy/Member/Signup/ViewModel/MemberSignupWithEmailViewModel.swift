//
//  MemberSignupWithEmailViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 11/8/23.
//

import Foundation
import FirebaseAuth
import RxSwift

final class MemberSignupWithEmailViewModel {
    private(set) var isAuthed = PublishSubject<Bool>()
    
    func emailAuthentication(email: String, address: String) {
        guard let identifier = Bundle.main.bundleIdentifier else { return }
        let emailAddress = "\(email)@\(address)"
        let authURL = "https://bookbuddy-72136.firebaseapp.com/?email=\(emailAddress)"
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: authURL)
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(identifier)
        
        Auth.auth().sendSignInLink(toEmail: emailAddress, actionCodeSettings: actionCodeSettings) { [weak self] error in
            if let error = error {
                print("email not sent: \(error.localizedDescription)")
            } else {
                self?.isAuthed.onNext(true)
            }
        }
    }
}
