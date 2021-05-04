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
    
    private let rootAssemblyType: IRootAssembly.Type
    private var rootAssembly: IRootAssembly
    private var isLogin = false
    private var isFirst = true
    init(rootAssemblyType: IRootAssembly.Type) {
        self.rootAssemblyType = rootAssemblyType
        self.rootAssembly = self.rootAssemblyType.newRootAssembly()
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var coreDataStack = CoreDataStack()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "main")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationBar.prefersLargeTitles = true
        navigationBar.isTranslucent = true
        navigationBar.tintColor = .systemOrange
        setAccountDelegate()
    }
    
    func resetAssemblies() {
        rootAssembly = rootAssemblyType.newRootAssembly()
    }
    
    func setAccountDelegate() {
        var accountService = rootAssembly.serviceAssembly.getAccountService()
        if let delegate = accountService.delegate, delegate == self {
            
        } else {
            accountService.delegate = self
        }
    }
}

extension MainNavigationController: AccountDelegate {
    func login() {
        DispatchQueue.main.async {
            if !self.isLogin || self.isFirst {
                if !self.isFirst {
                    self.resetAssemblies()
                    self.setAccountDelegate()
                    
                }
                self.isLogin = true
                self.isFirst = false
                self.setNavigationBarHidden(false, animated: true)
                self.setViewControllers([self.rootAssembly.presentationAssembly.buildCarListController()], animated: true)
            }
        }
    }
    
    func logout() {
        DispatchQueue.main.async {
            if self.isFirst || self.isLogin {
                self.isLogin = false
                self.isFirst = false
                let login = self.rootAssembly.presentationAssembly.buildLoginController({ })
                
                self.setNavigationBarHidden(true, animated: true)
                self.setViewControllers([login], animated: true)
            }
        }
    }
    
}
