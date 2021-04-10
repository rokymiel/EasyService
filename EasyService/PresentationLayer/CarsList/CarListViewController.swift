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
    private var accountService: IAccountService!
    
    class func sInit(accountService: IAccountService, presentationAssembly: IPresentationAssembly) -> CarListViewController {
        let contraller = UIStoryboard.carList.instantiate(CarListViewController.self)
        contraller.presentationAssembly = presentationAssembly
        return contraller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carsListTableView.dataSource = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked(sender:)))
        
        // Do any additional setup after loading the view.
    }
    @objc func addClicked(sender: Any) {
        present(presentationAssembly.buildNewCarViewController { car in
            print(car)
        }, animated: true)
    }
    func getEmptyView(title: String) -> UIView {
            button = UIRoundedButton()
            button.setTitle(title, for: .normal)
            
            let emptyView = UIView(frame: CGRect(x: carsListTableView.center.x,
                                                 y: carsListTableView.center.y,
                                                 width: carsListTableView.bounds.size.width,
                                                 height: carsListTableView.bounds.size.height))
            
            emptyView.addSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
            button.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
            button.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 50).isActive = true
            button.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -50).isActive = true
            
        button.addTarget(self, action: #selector(addClicked(sender:)), for: .touchUpInside)
    //        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            // The only tricky part is here:
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
        //        if names.count == 0 {
        
        tableView.setEmptyView(view: getEmptyView(title: "Добавить автомобиль"))
        //        }
        //        else {
        //            tableView.restore()
        //        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
