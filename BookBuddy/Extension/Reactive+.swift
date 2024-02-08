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
    var likeButtonTapped: ControlEvent<Void> { base.likeButton.rx.tap }
    var commentButtonTapped: ControlEvent<Void> { base.commentButton.rx.tap }
}
