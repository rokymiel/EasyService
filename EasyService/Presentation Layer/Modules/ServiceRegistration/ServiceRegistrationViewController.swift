//
//  ServiceRegistrationViewController.swift
//  EasyService
//
//  Created by Михаил on 24.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit
import MapKit

class ServiceRegistrationViewController: UITableViewController {
    
    private var registrationId: String!
    private var registrationService: IRegistrationService!
    
    @IBOutlet weak var statusCollection: UICollectionView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceAddressLabel: UILabel!
    @IBOutlet weak var serviceMap: MKMapView!
    @IBOutlet weak var registrationDateLabel: UILabel!
    @IBOutlet weak var registrationEndLabel: UILabel!
    @IBOutlet weak var worksTimeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var typeOfWorksLabel: UILabel!
    @IBOutlet weak var notesView: UITextView!
    class func sInit(with registrationId: String, registrationService: IRegistrationService) -> ServiceRegistrationViewController {
        let contraller = UIStoryboard.serviceRegistrationView.instantiate(self)
        contraller.registrationId = registrationId
        contraller.registrationService = registrationService
        return contraller
    }
    
    var registration: Registration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Запись в автосервис"
        navigationController?.navigationBar.prefersLargeTitles = true
        statusCollection.register(
            UINib(nibName:
                    String(describing: StatusCollectionViewCell.self),
                  bundle: nil),
            forCellWithReuseIdentifier: String(describing: StatusCollectionViewCell.self))
        statusCollection.dataSource = self
        addCloseItem()
        registrationService.getRegistration(with: registrationId) { [weak self] result in
            DispatchQueue.main.async {
                if case let .success(registration) = result {
                    self?.registration = registration
                    self?.statusCollection.reloadData()
                    self?.costLabel.text = "-"
                    if let cost = registration.cost {
                        self?.costLabel.text = String(cost)
                    }
                    self?.registrationDateLabel.text = registration.dateOfRegistration.fullDateWithTime
                    self?.registrationEndLabel.text = registration.timeOfWorks?.fullDateWithTime ?? "-"
                    self?.typeOfWorksLabel.text = registration.typeOfWorks
                    self?.notesView.text = registration.notes
                    self?.registrationService.getService(with: registration.serviceId) { [weak self] result in
                        DispatchQueue.main.async {
                            if case let .success(service) = result {
                                self?.serviceNameLabel.text = service.name
                                self?.serviceAddressLabel.text = service.address
                                let annotation = MKPointAnnotation()
                                annotation.coordinate = .init(latitude: service.location.latitude, longitude: service.location.longitude)
                                self?.serviceMap.addAnnotation(annotation)
                                let region = MKCoordinateRegion(center: annotation.coordinate,
                                                                span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
                                
                                self?.serviceMap.setRegion(region, animated: false)
                            }
                        }
                    }
                }
            }
        }
        
    }
}

extension ServiceRegistrationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard registration != nil else {
            return 0
        }
        return Registration.Status.statusNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: StatusCollectionViewCell.self), for: indexPath) as? StatusCollectionViewCell,
           let status = Registration.Status(numberValue: indexPath.row),
           let currentStatus = registration?.status {
            cell.configure((status, status == currentStatus))
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}