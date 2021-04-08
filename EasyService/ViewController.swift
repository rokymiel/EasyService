//
//  ViewController.swift
//  EasyService
//
//  Created by Михаил on 02.01.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    lazy var assembly = PresentationAssembly()

    @IBAction func show(_ sender: Any) {
        present(assembly.buildLoginController(), animated: true)
    }
}
