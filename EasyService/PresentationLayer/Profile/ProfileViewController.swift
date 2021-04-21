//
//  ProfileViewController.swift
//  EasyService
//
//  Created by Михаил on 21.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    class func sInit() -> ProfileViewController {
        let contraller = UIStoryboard.homeView.instantiate(self)

        return contraller
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
