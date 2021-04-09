//
//  ItemInListChooserViewController.swift
//  EasyService
//
//  Created by Михаил on 09.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class ItemInListChooserViewController: UIViewController {

    @IBOutlet weak var searchTextField: UIUnderlinedTextField!
    
    class func sInit() -> ItemInListChooserViewController {
        let contraller = UIStoryboard.itemInListChooser.instantiate(self)
        return contraller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
