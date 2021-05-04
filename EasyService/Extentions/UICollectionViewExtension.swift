//
//  UICollectionViewExtension.swift
//  EasyService
//
//  Created by Михаил on 04.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

extension UICollectionView {
    var widestCellWidth: CGFloat {
        let insets = contentInset.left + contentInset.right
        return bounds.width - insets
    }
}
