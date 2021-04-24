//
//  UINavigationExtension.swift
//  EasyService
//
//  Created by Михаил on 24.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

extension UIViewController {
    func addCloseItem() {
        let image = UIImage(systemName: "xmark.circle.fill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: #selector(closeView))
        navigationItem.rightBarButtonItem?.tintColor = .systemGray
       
    }
    @objc func closeView() {
        dismiss(animated: true)
    }
}
