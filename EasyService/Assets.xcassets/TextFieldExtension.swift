//
//  TextFieldExtension.swift
//  EasyService
//
//  Created by Михаил on 19.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

extension UITextField {
    func setPlaceholder (string: String? = nil, color: UIColor? = nil) {
        attributedPlaceholder = NSAttributedString(string: string ?? placeholder ?? "",
                                                   attributes: [.foregroundColor: color ?? UIColor.placeholderText])
    }
}
