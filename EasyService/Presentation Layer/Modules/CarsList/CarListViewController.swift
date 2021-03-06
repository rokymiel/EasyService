//
//  CarListViewController.swift
//  EasyService
//
//  Created by Михаил on 09.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class CarListViewController: UIViewController {
    
    @IBOutlet weak var carsListTableView: UITableView!
    private var button: UIRoundedButton!
    private var presentationAssembly: IPresentationAssembly!
    private var carsService: ICarsService!
    
    class func sInit(carsService: ICarsService, presentationAssembly: IPresentationAssembly) -> CarListViewController {
        let contraller = UIStoryboard.carList.instantiate(CarListViewController.self)
        contraller.carsService = carsService
        contraller.presentationAssembly = presentationAssembly
        return contraller
    }
    
    private var cars = [Car]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if carsService.currentId != nil {
            openForSelectedCar()
        }
        carsService.add(delegate: self)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        carsListTableView.dataSource = self
        carsListTableView.delegate = self
        carsListTableView.register(CarViewCell.self, forCellReuseIdentifier: String(describing: CarViewCell.self))
        
        title = "Автомобили"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked(sender:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(profileClicked))
        
        setCars()
    }
    
    func setCars() {
        carsService.getCars { (result) in
            if case let .success(cars) = result {
                DispatchQueue.main.async {
                    self.cars = cars
                    self.carsListTableView.reloadData(animated: true)
                    
                }
            }
        }
    }
    
    @objc func addClicked(sender: Any) {
        let newCarViewController = presentationAssembly.buildNewCarViewController { car in
            self.carsService.saveNew(car: car)
        }
        present(presentationAssembly.buildNavigationController(root: newCarViewController), animated: true)
    }
    
    @objc func profileClicked(sender: Any) {
        navigationController?.pushViewController(presentationAssembly.buildProfileViewController(), animated: true)
    }
    
    func getEmptyView(title: String) -> UIView {
        let messageLabel = UILabel()
        messageLabel.text = "Автомобилей нет"
        button = UIRoundedButton()
        button.setTitle(title, for: .normal)
        
        let emptyView = UIView(frame: CGRect(x: carsListTableView.center.x,
                                             y: carsListTableView.center.y,
                                             width: carsListTableView.bounds.size.width,
                                             height: carsListTableView.bounds.size.height))
        
        emptyView.addSubview(button)
        emptyView.addSubview(messageLabel)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 50).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -50).isActive = true
        
        button.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 70).isActive = true
        
        button.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 50).isActive = true
        button.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.addTarget(self, action: #selector(addClicked(sender:)), for: .touchUpInside)
        
        messageLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textAlignment = .center
        return emptyView
    }
    
    func openForSelectedCar() {
        let tabBar = presentationAssembly.buildCarMainController()
        navigationController?.pushViewController(tabBar, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension CarListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cars.count == 0 {
            
            tableView.setEmptyView(view: getEmptyView(title: "Добавить автомобиль"))
            return 0
        }
        tableView.restore()
        
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.carsListTableView.dequeueReusableCell(withIdentifier: String(describing: CarViewCell.self), for: indexPath) as? CarViewCell {
            cell.configure(cars[indexPath.row])
            //            cell.applyTheme()
            cell.backgroundColor = .systemGray6
            return cell
        }
        return UITableViewCell()
    }
}

private extension UITableView {
    func setEmptyView(view: UIView) {
        
        self.backgroundView = view
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension CarListViewController: UpdateDelegate {
    func updated(_ sender: Any) {
        setCars()
    }
    
    func faild(with error: Error, _ sender: Any) {
        DispatchQueue.main.async {
            self.showAlert(with: "Не удалось обновить данные об автомобилях")
        }
    }
}

extension CarListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let id = cars[indexPath.row].identifier {
            carsService.select(id: id)
        }
        openForSelectedCar()
    }
}
