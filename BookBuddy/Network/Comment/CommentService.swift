//
//  CommentService.swift
//  BookBuddy
//
//  Created by 한소희 on 1/31/24.
//

import Foundation


final class CommentService {
    private let networeSessionMangaer = NetworkSessionManager()
    
    func setCommentInfo(with commentUpldateInformation: CommentUploadInformation, completion: @escaping(Bool) -> Void) {
        let path = "/BookBuddyInfo/setBoardComment/"
        let comment = commentUpldateInformation.toRequestDTO()
        networeSessionMangaer.urlPostMethod(path: path, encodeValue: comment) { result in
            completion(result)
        }
    }
    
    func deleteCommentInfo(with commentDeleteInformation: CommentDeleteInformation, completion: @escaping(Bool)->Void) {
        let path = "/BookBuddyInfo/deleteComment/"
        let comment = commentDeleteInformation.toRequestDTO()
        networeSessionMangaer.urlDeleteMethod(path: path, encodeValue: comment) { result in
            completion(result)
        }
    }
    
    func getCommentInfo(postID: Int, completion: @escaping([CommentInformation]) -> Void) {
        let path = "/BookBuddyInfo/getBoardComment?postID=\(postID)"
        networeSessionMangaer.urlGetMethod(path: path, requestDTO: [CommentDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let commentInformation = responseDTO.map { $0.toDomain() }
                completion(commentInformation)
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
}
