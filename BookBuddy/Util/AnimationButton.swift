//
//  AnimationButton.swift
//  BookBuddy
//
//  Created by 한소희 on 11/9/23.
//

import Foundation
import UIKit

class AnimationButton: UIButton {
    private enum Animation {
        typealias Element = (
        duration: TimeInterval,
        delay: TimeInterval,
        options: UIView.AnimationOptions,
        scale: CGAffineTransform,
        alpha: CGFloat
        )
        
        case touchDown
        case touchUp
        
        var element: Element {
            switch self {
            case .touchDown:
                return Element(
                    duration: 0,
                    delay: 0,
                    options: .curveLinear,
                    scale: .init(scaleX: 1.1, y: 1.1),
                    alpha: 0.8
                )
                
            case .touchUp:
                return Element(
                    duration: 0,
                    delay: 0,
                    options: .curveLinear,
                    scale: .identity,
                    alpha: 1
                )
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet { self.animationWhenHighlighted() }
    }
    
    private func animationWhenHighlighted() {
        let animationElement = self.isHighlighted ? Animation.touchDown.element : Animation.touchUp.element
        
        UIView.animate(withDuration: animationElement.duration,
                       delay: animationElement.delay,
                       options: animationElement.options,
                       animations: {
            self.transform = animationElement.scale
            self.alpha = animationElement.alpha
        })
    }
}
