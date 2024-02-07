//
//  CommentViewModel.swift
//  BookBuddy
//
//  Created by 한소희 on 1/31/24.
//

import Foundation
import RxSwift

final class CommentViewModel {
    private let commentService = CommentService()
    private let dateFormatter = DateFormatter()
    private(set) var isCommentUploaded = PublishSubject<Bool>()
    private(set) var isCommentLoaded = PublishSubject<Bool>()
    private(set) var commentInformations: [CommentInformation]?
    private(set) var postID: Int?
    
    func setPostID(_ postID: Int) {
        self.postID = postID
    }
    
    func setCommentInformations(_ commentInformations: [CommentInformation]) {
        self.commentInformations = commentInformations
    }
    
    func commentUpload(userID: Int, commentContent: String) {
        guard let uploadPostID = postID,
              let uploadNickname = UserDefaults.standard.string(forKey: UserDefaultsForkey.nickname.rawValue) else { return }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let wrtieDate = dateFormatter.string(from: Date())
        let uploadProfile = UserDefaults.standard.data(forKey: UserDefaultsForkey.profile.rawValue) ?? Data()
        let uploadCommentInformation = CommentUploadInformation(postID: uploadPostID, userID: userID, writeDate: wrtieDate, commentContent: commentContent, nickname: uploadNickname, profile: uploadProfile)
        commentService.setCommentInfo(with: uploadCommentInformation) { [weak self] result in
            self?.isCommentUploaded.onNext(result)
        }
    }
    
    func loadCommentInformation() {
        guard let postID = postID else { return }
        commentService.getCommentInfo(postID: postID) { [weak self] result in
            self?.commentInformations = result
            self?.isCommentLoaded.onNext(!result.isEmpty)
        }
    }
}
