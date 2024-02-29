//
//  Reactive+.swift
//  BookBuddy
//
//  Created by 한소희 on 1/24/24.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: BoardSearchViewCell {
    var didTapLikeButton: ControlEvent<Void> { base.likeButton.rx.tap }
    var didTapCommentButton: ControlEvent<Void> { base.commentButton.rx.tap }
    var didTapReadMoreButton: ControlEvent<Void> { base.readMoreButton.rx.tap }
}
