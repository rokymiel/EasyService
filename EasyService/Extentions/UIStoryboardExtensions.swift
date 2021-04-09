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
    @nonobjc class var carList: UIStoryboard {
      return UIStoryboard(name: .carList, bundle: nil)
    }
    @nonobjc class var itemInListChooser: UIStoryboard {
      return UIStoryboard(name: .itemInListChooser, bundle: nil)
    }
    @nonobjc class var newCarViewController: UIStoryboard {
      return UIStoryboard(name: .newCarViewController, bundle: nil)
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
    static let carList = "CarListView"
    static let itemInListChooser = "ItemInListChooserView"
    static let newCarViewController = "NewCarView"
}
