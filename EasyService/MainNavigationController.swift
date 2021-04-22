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
    private var accountService: IAccountService
    init(presentationAssembly: IPresentationAssembly, accountService: IAccountService) {
        self.presentationAssembly = presentationAssembly
        self.accountService = accountService
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
        super.viewDidAppear(animated)
        navigationBar.prefersLargeTitles = true
        navigationBar.isTranslucent = true
        if let delegate = accountService.delegate, delegate == self {
           
        } else {
            accountService.delegate = self
        }
//        self.present(presentationAssembly.buildServicesMapViewController(), animated: true)
//        account()
//        self.viewControllers = [presentationAssembly.buildHomeViewController()]
    }
    
//    func account() {
//
////        do{ try Auth.auth().signOut() } catch {}
//        accountService.getUser { (result) in
//            switch result {
//            case .success(let user):
//                print("QWERTYUI")
////                print("IIIDD ",user.email)
//                DispatchQueue.main.async {
//                    print(user)// TODO: - как-то использовать
//                    self.viewControllers = [self.presentationAssembly.buildCarListController()]
//                }
//
//            case .failure:
//                print("fail")
//                DispatchQueue.main.async {
//                    print("ASA")
//                    self.present(self.presentationAssembly.buildLoginController { _ in
//                        print("asd")
//                        self.viewControllers = [self.presentationAssembly.buildCarListController()]
//                    }, animated: true)
//
//                }
//            }
//        }
//    }
}

extension MainNavigationController: AccountDelegate {
    func login() {
        DispatchQueue.main.async {
            self.viewControllers = [self.presentationAssembly.buildCarListController()]
        }
    }
    
    func logout() {
        DispatchQueue.main.async {
            print("ASA")
            self.viewControllers = []
            self.present(self.presentationAssembly.buildLoginController({ }), animated: true)
        }
    }
    
    
}
