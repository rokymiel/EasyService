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
    private var serviceAssembly: IServiceAssembly
    private var isLogin = false
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
        view.backgroundColor = UIColor(named: "main")
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
        self.navigationBar.isHidden = true
        navigationBar.prefersLargeTitles = true
        navigationBar.isTranslucent = true
        navigationBar.tintColor = .systemOrange
        var accountService = serviceAssembly.getAccountService()
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
        print("LLLOOOOGGGGIIINNN")
        DispatchQueue.main.async {
            if !self.isLogin {
            self.navigationBar.isHidden = false
                self.setViewControllers([self.presentationAssembly.buildCarListController()], animated: true)
                self.isLogin = true
            }
        }
    }
    
    func logout() {
        DispatchQueue.main.async {
            print("ASA")
            if self.isLogin {
                let login = self.presentationAssembly.buildLoginController({ })
                
                self.navigationBar.isHidden = true
                self.setViewControllers([login], animated: true)
                self.isLogin = false
                
            }
            
//            self.viewControllers.removeAll()
//            self.viewContr
//            self.present(login, animated: true)
        }
    }
    
    
}
