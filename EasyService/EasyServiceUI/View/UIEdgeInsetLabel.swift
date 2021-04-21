//
//  UIEdgeInsetLabel.swift
//  EasyService
//
//  Created by Михаил on 21.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

@IBDesignable
class UIEdgeInsetLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                left: -textInsets.left,
                bottom: -textInsets.bottom,
                right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

extension UIEdgeInsetLabel {
    @IBInspectable
    var leftTextInset: CGFloat {
        get { return textInsets.left }
        set { textInsets.left = newValue }
    }

    @IBInspectable
    var rightTextInset: CGFloat {
        get { return textInsets.right }
        set { textInsets.right = newValue }
    }

    @IBInspectable
    var topTextInset: CGFloat {
        get { return textInsets.top }
        set { textInsets.top = newValue }
    }

    @IBInspectable
    var bottomTextInset: CGFloat {
        get { return textInsets.bottom }
        set { textInsets.bottom = newValue }
    }
}
