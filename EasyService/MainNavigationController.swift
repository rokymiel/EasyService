//
//  MainNavigationController.swift
//  EasyService
//
//  Created by Михаил on 08.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit
import Firebase

class MainNavigationController: UINavigationController {
    
    private let presentationAssembly: IPresentationAssembly
    
    init(presentationAssembly: IPresentationAssembly) {
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                NSLog("Has user")
//                self.viewControllers = [self.presentationAssembly.buildCarListController()]
//                self.present(self.presentationAssembly.buildItemInListChooserViewController(items: ["Audi", "Kia","Auqura","Keno"]) { item in
//                    print(item)
//                }, animated: true)
                self.present(self.presentationAssembly.buildNewCarViewController(), animated: true)
//                self.present(self.presentationAssembly.buildLoginController(), animated: true)
                
            } else {
                NSLog("No user")
                self.present(self.presentationAssembly.buildLoginController(), animated: true)
            }
            
        }
    }
}
