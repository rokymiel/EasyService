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
    private let serviceAssembly: IServiceAssembly
    init(presentationAssembly: IPresentationAssembly, serviceAssembly: IServiceAssembly) {
        self.presentationAssembly = presentationAssembly
        self.serviceAssembly = serviceAssembly
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var coreDataStack = CoreDataStack()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        //        accountService.getUser { (result) in
        //            switch result {
        //            case .success(let user): // TODO: - как-то использовать
        //                self.viewControllers = [self.presentationAssembly.buildCarListController()]
        //            case .failure:
        //                print("ASA")
        //                self.present(self.presentationAssembly.buildLoginController(), animated: true)
        //            }
        //        }
    }
    override func viewDidAppear(_ animated: Bool) {
        let accountService = serviceAssembly.buildAccountService()
        do{ try Auth.auth().signOut() } catch {}
        accountService.getUser { (result) in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    print()// TODO: - как-то использовать
                    self.viewControllers = [self.presentationAssembly.buildCarListController()]
                }
                
            case .failure:
                DispatchQueue.main.async {
                    print("ASA")
                    self.present(self.presentationAssembly.buildLoginController(), animated: true)
                    
                }
            }
        }
    }
}
