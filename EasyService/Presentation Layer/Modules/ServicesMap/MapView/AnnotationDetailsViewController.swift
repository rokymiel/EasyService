//
//  AnnotationDetailsViewController.swift
//  EasyService
//
//  Created by Михаил on 12.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

enum CardState {
    case expanded
    case small
    case collapsed
}

class AnnotationDetailsViewController: UIViewController, Configurable {
    
    private let presentationAssembly: IPresentationAssembly
    private let carsService: ICarsService
    
    var state: CardState = .collapsed
        
    init(carsService: ICarsService, presentationAssembly: IPresentationAssembly) {
        self.presentationAssembly = presentationAssembly
        self.carsService = carsService
        super.init(nibName: "AnnotationDetailsViewController", bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var registrationButtonCellView: UITableViewCell!
    
    lazy var addressViewCell: UITableViewCell = newCell()
    
    private var service: Service?
    private var contactsCount = 0
    private var contactCells: [UITableViewCell] = []
    
    private lazy var workTimeCells: [UITableViewCell] = {
        var cells: [UITableViewCell] = []
        var calender = Calendar.current
        calender.locale = .preferredLocale
        for i in 0..<7 {
            let left = calender.shortWeekdaySymbols[(i + 1) % 7]
            let cell = newDetailsCell()
            cell.textLabel?.text = left
            cells.append(cell)
        }
        return cells
    }()
    
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var dragAreaView: UIView!
    @IBOutlet weak var dragSuperAreaView: UIView!
    @IBOutlet weak var detailsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        dragView.layer.cornerRadius = dragView.frame.height / 2.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.layer.cornerRadius = 15
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
    }
    
    typealias Model = Service
    func configure(_ model: Service) {
        service = model
        contactsCount = 0
        setContacts(service: model)
        setWorkTime(service: model)
        nameLabel.text = service?.name
        addressViewCell.textLabel?.text = service?.address
        detailsTableView.reloadData(animated: true)
    }
    
    func setContacts(service: Service) {
        
        contactsCount += 1
        if contactCells.count < contactsCount {
            contactCells.append(newCell())
        }
        contactCells[contactsCount - 1].textLabel?.text = service.phone
        
    }
    
    func setWorkTime(service: Service) {
        let workTime = service.workTime
        for (i, element) in workTime.enumerated() {
            workTimeCells[i].detailTextLabel?.text = element
        }
    }
    func newCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .systemGray6
        return cell
    }
    func newDetailsCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.backgroundColor = .systemGray6
        return cell
    }
    @IBAction func registerClicked(_ sender: Any) {
        if let service = service {
            carsService.getCar { [weak self] result in
                switch result {
                case .success(let car):
                    if let presentationAssembly = self?.presentationAssembly {
                        DispatchQueue.main.async {
                            let newServiceRegisrtationViewController = presentationAssembly
                                .buildNewServiceRegisrtationViewController(with: car,
                                                                           service: service)
                            self?.present(presentationAssembly
                                            .buildNavigationController(root: newServiceRegisrtationViewController), animated: true)
                        }
                    }
                case .failure:
                    self?.showAlert(with: "Нет автомобиля")
                }
            }
        }
    }
    
}

extension AnnotationDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return contactsCount
        case 2: return 7
        case 3: return 1
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Адрес"
        case 1: return "Контакты"
        case 2: return "Время работы"
        case 3: return nil
        default:
            return nil
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return addressViewCell
        case 1: return contactCells[indexPath.row]
        case 2: return workTimeCells[indexPath.row]
        case 3: return registrationButtonCellView
        default:
            return newCell()
        }
    }
}

extension AnnotationDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 { return 50 }
        return 40
    }
}
