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
    let isIUploadedComment = PublishSubject<Bool>()
    let isLoadedComment = PublishSubject<Bool>()
    let isDeletedComment = PublishSubject<Bool>()
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
            self?.isIUploadedComment.onNext(result)
        }
    }
    
    func loadCommentInformation() {
        guard let postID = postID else { return }
        commentService.getCommentInfo(postID: postID) { [weak self] result in
            self?.commentInformations = result
            self?.isLoadedComment.onNext(!result.isEmpty)
        }
    }
    
    func checkAuthorUser(with commentUserID: Int) -> Bool {
        let userID = UserDefaults.standard.integer(forKey: UserDefaultsForkey.userID.rawValue)
        guard commentUserID == userID else { return false }
        return true
    }
    
    func deleteComment(commentUserID: Int, commentID: Int, indexPath: IndexPath) {
        let commentDeleteInfo = CommentDeleteInformation(commentID: commentID, commentUserID: commentUserID)
        commentService.deleteCommentInfo(with: commentDeleteInfo) { [weak self] result in
            guard result else { return }
            self?.deleteCommentInformation(indexPath.row)
            self?.isDeletedComment.onNext(result)
        }
    }
    
    private func deleteCommentInformation(_ index: Int) {
        commentInformations?.remove(at: index)
    }
}
