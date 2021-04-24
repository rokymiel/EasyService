//
//  ProfileViewController.swift
//  EasyService
//
//  Created by Михаил on 21.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    private var accountService: IAccountService!
    private var carsService: ICarsService!
    private var registrationService: IRegistrationService!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var patronymicLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var carsLabel: UILabel!
    @IBOutlet weak var registrationsLabel: UILabel!
    class func sInit(accountService: IAccountService,
                     carsService: ICarsService,
                     registrationService: IRegistrationService) -> ProfileViewController {
        let contraller = UIStoryboard.profileView.instantiate(self)
        contraller.accountService = accountService
        contraller.carsService = carsService
        contraller.registrationService = registrationService
        return contraller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        accountService.getUser { [weak self] result in
            DispatchQueue.main.async {
                if case let .success(user) = result {
                    self?.nameLabel.text = user.name
                    self?.surnameLabel.text = user.surname
                    self?.patronymicLabel.text = user.patronymic?.isBlank() ?? true ? "-" : user.patronymic
                    self?.dateOfBirthLabel.text = user.dateOfBirth.fullDate
                    
                    self?.emailLabel.text = user.email
                    self?.phoneLabel.text = user.phone
                    guard let id = user.identifier else { return }
                    self?.registrationService.count(user: id) { [weak self] result in
                        DispatchQueue.main.async {
                            if case let .success(count) = result {
                                self?.registrationsLabel.text = String(count)
                            } else {
                                self?.registrationsLabel.text = String(0)
                            }
                        }
                    }
                }
            }
        }
        carsService.count { [weak self] result in
            DispatchQueue.main.async {
                if case let .success(count) = result {
                    self?.carsLabel.text = String(count)
                } else {
                    self?.carsLabel.text = String(0)
                }
            }
        }
    }

    @IBAction func exitClicked(_ sender: Any) {
        do {
            try accountService.signOut()
        } catch {
            showAlert(with: "Не получилось выйти из аккаунта")
        }
    }
}
