//
//  NewServiceRegisrtationViewController.swift
//  EasyService
//
//  Created by Михаил on 18.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class NewServiceRegisrtationViewController: UITableViewController {
    
    private var registrationService: IRegistrationService!
    
    @IBOutlet weak var carCell: CarViewCell!
    class func sInit(registrationService: IRegistrationService) -> NewServiceRegisrtationViewController {
        let contraller = UIStoryboard.newServiceRegisrtation.instantiate(self)
        contraller.registrationService = registrationService
        return contraller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        carCell.configure(Car(identifier: "id", mark: "Audi", model: "A4", body: "hjk", gear: "Asd", engine: 2, productionYear: 2019))
    }


}
