//
//  UINoneActionsTextField.swift
//  EasyService
//
//  Created by Михаил on 14.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class UINoneActionsTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
