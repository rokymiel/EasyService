//
//  CarMainViewController.swift
//  EasyService
//
//  Created by Михаил on 24.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class CarMainViewController: UITabBarController {
    private let presentationAssembly: IPresentationAssembly
    private let carsService: ICarsService
    init(presentationAssembly: IPresentationAssembly, carsService: ICarsService) {
        self.presentationAssembly = presentationAssembly
        self.carsService = carsService
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        let home = presentationAssembly.buildHomeViewController()
        let map = presentationAssembly.buildServicesMapViewController()
        let profile = presentationAssembly.buildProfileViewController()
        let profileNavigation = presentationAssembly.buildNavigationController(root: profile)
        let homeNavigation = presentationAssembly.buildNavigationController(root: home)
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "car.2.fill"), for: .normal)
        button.setTitle("Все", for: .normal)
        button.sizeToFit()
        button.addTarget(nil, action: #selector(backToCarList), for: .touchUpInside)
        home.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        homeNavigation.tabBarItem.image = UIImage(systemName: "car.fill")
        map.tabBarItem.image = UIImage(systemName: "map.fill")
        profileNavigation.tabBarItem.image = UIImage(systemName: "person.fill")
        
        homeNavigation.navigationBar.tintColor = .systemOrange
        profileNavigation.navigationBar.tintColor = .systemOrange
        
        tabBar.tintColor = .systemOrange
        
        viewControllers = [homeNavigation, map, profileNavigation]
        
        homeNavigation.view.gestureRecognizers = navigationController?.view.gestureRecognizers
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        home.view.addGestureRecognizer(edgePan)
    }
    
    @objc func backToCarList() {
        carsService.deselect()
        navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            backToCarList()
        }
    }
}
