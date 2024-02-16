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
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/setBoardComment/") else { return }
        let comment = commentUpldateInformation.toRequestDTO()
        networeSessionMangaer.urlPostMethod(url: url, encodeValue: comment) { result in
            completion(result)
        }
    }
    
    func deleteCommentInfo(with commentDeleteInformation: CommentDeleteInformation, completion: @escaping(Bool)->Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/deleteComment/") else { return }
        let comment = commentDeleteInformation.toRequestDTO()
        networeSessionMangaer.urlDeleteMethod(url: url, encodeValue: comment) { result in
            completion(result)
        }
    }
    
    func getCommentInfo(postID: Int, completion: @escaping([CommentInformation]) -> Void) {
        guard let serverURL = Bundle.main.infoDictionary?["Server_URL"] as? String else { return }
        guard let url = URL(string: serverURL+"/BookBuddyInfo/getBoardComment?postID=\(postID)") else { return }
        networeSessionMangaer.urlGetMethod(url: url, requestDTO: [CommentDTO].self) { result in
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
