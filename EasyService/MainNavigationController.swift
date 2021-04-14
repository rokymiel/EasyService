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
    init(presentationAssembly: IPresentationAssembly) {
        self.presentationAssembly = presentationAssembly
        self.serviceAssembly = ServiceAssembly()
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var coreDataStack = CoreDataStack()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        let manager = CoreDataManager(dataStack: coreDataStack)
        
        manager.fetchAll(UserDB.self) { (items) in
            print(1)
            //            for item in items ?? [] {
            //                   print(item.identifier, item.name)
            //               }
            print(items?[1].name)
            sleep(1)
            print(11)
            for item in items ?? [] {
                print(item)
                print(item.identifier, item.name)
            }
            
        }
        
        let user = User(identifier: "ASDR",
                        name: "Man5", surname: "Sur", patronymic: nil, dateOfBirth: Date(), phone: "989898", email: "jdhakjdh")
        manager.save(model: user) {
            print("Saved")
            manager.fetchAll(UserDB.self) { (items) in
                print(2)
                print(items?.map({ $0.name }))
                
            }
        }
        
        
        //        serviceAssembly.buildRegisrtationService().getRegistrations { (result) in
        //            switch result {
        //            case .failure(let error):
        //                print(error)
        //            case .success(let registrations):
        //                print(registrations)
        //            }
        //        }
//        Auth.auth().addStateDidChangeListener { _, user in
//            if let user = user {
//                NSLog("Has user")
//                //                self.viewControllers = [self.presentationAssembly.buildCarListController()]
//                self.present(self.presentationAssembly.buildServicesMapViewController(), animated: true)
//                //                self.present(self.presentationAssembly.buildItemInListChooserViewController(items: ["Audi", "Kia","Auqura","Keno"]) { item in
//                //                    print(item)
//                //                }, animated: true)
//                //                self.present(self.presentationAssembly.buildNewCarViewController(), animated: true)
//                //                self.present(self.presentationAssembly.buildLoginController(), animated: true)
//
//            } else {
//                NSLog("No user")
//                self.present(self.presentationAssembly.buildLoginController(), animated: true)
//            }
//
//        }
    }
}
