//
//  AnnotationDetailsViewController.swift
//  EasyService
//
//  Created by Михаил on 12.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class AnnotationDetailsViewController: UIViewController, Configurable {
    
    private let presentationAssembly: IPresentationAssembly
    
    typealias Model = Service
    func configure(_ model: Service) {
        service = model
        contactsCount = 0
        setContacts(service: model)
        setWorkTime(service: model)
        nameLabel.text = service?.name
        addressViewCell.textLabel?.text = service?.address
        detailsTableView.reloadData()
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
    init(presentationAssembly: IPresentationAssembly, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
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
        calender.locale = Locale(identifier: "ru")
        for i in 0..<7 {
            let left = calender.shortWeekdaySymbols[(i+1)%7]
            let cell = newDetailsCell()
            cell.textLabel?.text = left
            cells.append(cell)
        }
        return cells
    }()
    
    //    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var dragView: UIView!
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
        //        detailsView.layer.cornerRadius = 20
        //        detailsView.layer.shadowColor = UIColor.black.cgColor
        //        detailsView.layer.shadowOpacity = 0.3
        //        detailsView.layer.shadowOffset = .zero
        //        detailsView.layer.shadowRadius = 20
        //        detailsView.layer.shadowPath = UIBezierPath(rect: detailsView.bounds).cgPath
        //        detailsView.layer.shouldRasterize = true
        //        detailsView.layer.rasterizationScale = UIScreen.main.scale
        //        UIView.animate(withDuration: 0.3) { [weak self] in
        //            let frame = self?.view.frame
        //            let yComponent = UIScreen.main.bounds.height - 200
        //            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
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
        self.present(presentationAssembly.buildNewServiceRegisrtationViewController(service: service!,
                                                                                    car: Car(identifier: "KJLK",
                                                                                             mark: "Audi",
                                                                                             model: "A4",
                                                                                             body: "седан",
                                                                                             gear: "asd",
                                                                                             engine: 2,
                                                                                             productionYear: 2019)), animated: true)
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
        if(indexPath.section == 3) { return 50 }
        return 40
    }
}
