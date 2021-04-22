//
//  CarListViewController.swift
//  EasyService
//
//  Created by Михаил on 09.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class CarListViewController: UIViewController{
    
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
    private var cars = [Car]()//[Car(identifier: "1", mark: "Audi", model: "A6", body: "седан", gear: "автоматическая", engine: 2.0, productionYear: 2016),
    // Car(identifier: "2", mark: "Audi", model: "A3", body: "седан", gear: "автоматическая", engine: 2.0, productionYear: 2020)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if carsService.currentId != nil{
            navigationController?.pushViewController(presentationAssembly.buildHomeViewController(), animated: true)
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        carsListTableView.dataSource = self
        carsListTableView.delegate = self
        carsListTableView.register(CarViewCell.self, forCellReuseIdentifier: String(describing: CarViewCell.self))
        
        title = "Автомобили"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked(sender:)))
        
        carsService.getCars { (result) in
            if case let .success(cars) = result {
                print("HIQWERTYU", cars.count)
                DispatchQueue.main.async {
                    print("MileageDB", cars.map { $0.mileage})
                    self.cars = cars
                    self.carsListTableView.reloadData()
                    
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    @objc func addClicked(sender: Any) {
        present(presentationAssembly.buildNewCarViewController { car in
            self.carsService.saveNew(car: car)
        }, animated: true)
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
        //        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // The only tricky part is here:
        messageLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textAlignment = .center
        return emptyView
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UIRoundedButton()
        
        let messageLabel = UILabel()
        
        titleLabel.backgroundColor = .red
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        //    titleLabel.textColor = UIColor.black
        //    titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.setTitle(title, for: .normal)
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension CarListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let id = cars[indexPath.row].identifier {
            carsService.select(id: id)
        }
        navigationController?.pushViewController(presentationAssembly.buildHomeViewController(), animated: true)
//        self.present(, animated: true)
    }
}
