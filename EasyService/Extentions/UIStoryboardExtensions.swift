//
//  UIStoryboardExtensions.swift
//  EasyService
//
//  Created by Михаил on 08.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

extension UIStoryboard {
    @nonobjc class var login: UIStoryboard {
      return UIStoryboard(name: .login, bundle: nil)
    }
    @nonobjc class var regisrtation: UIStoryboard {
      return UIStoryboard(name: .regisrtation, bundle: nil)
    }
    @nonobjc func instantiate<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        guard
            let vc = instantiateInitialViewController() as? VC
            else { fatalError("Couldn't instantiate \(VC.self)") }

        return vc
    }
}

private extension String {
    static let login = "Login"
    static let regisrtation = "RegisrtationView"
}
