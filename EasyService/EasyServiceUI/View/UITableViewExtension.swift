//
//  UITableViewExtension.swift
//  EasyService
//
//  Created by Михаил on 27.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadData(animated: Bool) {
        if animated {
            UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) { self.reloadData() }
        } else {
            reloadData()
        }
    }
}
