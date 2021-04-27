//
//  HomeViewController.swift
//  EasyService
//
//  Created by Михаил on 21.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    private var carsService: ICarsService!
    private var registrationService: IRegistrationService!
    private var presentationAssembly: IPresentationAssembly!
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var registrationsCollectionView: UICollectionView!
    @IBOutlet weak var mileageChartCell: MileageChartViewCell!
    @IBOutlet weak var mileageViewCell: MileageViewCell!
    class func sInit(registrationService: IRegistrationService,
                     carsService: ICarsService,
                     presentationAssembly: IPresentationAssembly) -> HomeViewController {
        let contraller = UIStoryboard.homeView.instantiate(self)
        contraller.carsService = carsService
        contraller.registrationService = registrationService
        contraller.presentationAssembly = presentationAssembly
        return contraller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        carsService.add(delegate: self)
        registrationService.add(delegate: self)
        navigationController?.navigationBar.prefersLargeTitles = true
        registrationsCollectionView.dataSource = self
        registrationsCollectionView.delegate = self
        registrationsCollectionView.register(
            UINib(nibName:
                    String(describing: RegistrationCollectionViewCell.self),
                  bundle: nil),
            forCellWithReuseIdentifier: String(describing: RegistrationCollectionViewCell.self))
        let layout = registrationsCollectionView.collectionViewLayout
        if let flowLayout = layout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(
                width: registrationsCollectionView.widestCellWidth, height: registrationsCollectionView.frame.height
            )
        }
    }
    
    private var registrations: [Registration]?
    
    func configure() {
        carsService.getCar { [weak self] (result) in
            DispatchQueue.main.async {
                if case let .success(car) = result {
                    self?.carLabel.text = [car.mark, car.model, car.body].joined(separator: " ")
                    self?.carDetailsTable.configure(car)
                    if let mileage = car.mileage.max(by: { $0.date < $1.date }) {
                        self?.mileageViewCell.configure(mileage)
                    }
                    self?.mileageChartCell.configure(car.mileage)
                    if let id = car.identifier {
                        self?.carId = id
                        self?.setRegistrations()
                        
                    }
                }
            }
        }
    }
    
    func setRegistrations() {
        if let id = carId {
            registrationService.getRegistrations(with: id, completetion: { result in
                DispatchQueue.main.async {
                    if case let .success(registrations) = result {
                        self.registrations = registrations
                        self.registrationsCollectionView.reloadData()
                    }
                }
            })
        }
    }
    
    private var carId: String?
    private var firstAppear = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstAppear {
            firstAppear = false
            self.carImage.layer.opacity = 0
            UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseOut) {
                self.carImage.layer.opacity = 1
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let model = headers[section] {
            let header = LabelHeaderView(reuseIdentifier: String(describing: LabelHeaderView.self))
            header.configure(model)
            return header
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if headers[section] != nil {
            return 40
        }
        return -1
    }
    
    @IBOutlet weak var carDetailsTable: CarDetailsTableView!
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0, indexPath.row == 2 {
            if carDetailsHidden {
                return 0
            } else {
                return -1
            }
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    func addMileage() {
        showInputDialog(title: "Текущий пробег",
                        inputPlaceholder: "Введите текущий пробег",
                        inputKeyboardType: .default, actionHandler: { input in
                            guard let input = input,
                                  let mileage = Int(input),
                                  mileage >= 0 else {
                                self.showAlert(with: "Введите неотрицательное число", handler: { _ in self.addMileage()})
                                return
                            }
                            self.carsService.addMileage(.init(date: Date(), value: mileage, isVerified: false)) { error in
                                self.showAlert(with: "Не удалось добавить пробег")
                            }
                        })
    }
    private lazy var headers: [Int: LabelHeaderView.Model] = [
        1: .init(header: "Пробег", action: addMileage, actionText: nil, actionImage: UIImage(systemName: "plus")),
        2: .init(header: "Записи", action: nil, actionText: nil, actionImage: nil)
    ]
    private var carDetailsHidden = true
    @IBAction func carDetailsClicked(_ sender: UIButton) {
        if carDetailsHidden {
            sender.setTitle("Скрыть", for: .normal)
        } else {
            sender.setTitle("Ещё", for: .normal)
        }
        carDetailsHidden = !carDetailsHidden
        tableView.reloadRows(at: [.init(row: 2, section: 0)], with: .top)
    }
}

extension HomeViewController: UpdateDelegate {
    func updated(_ sender: Any) {
        if sender is IRegistrationService {
            setRegistrations()
        }
        if sender is ICarsService {
            configure()
        }
    }
    
    func faild(with error: Error, _ sender: Any) {
        if sender is IRegistrationService {
            DispatchQueue.main.async {
                self.showAlert(with: "Не удалось обновить данные о записях в автосервисы")
            }
        }
        if sender is ICarsService {
            DispatchQueue.main.async {
                self.showAlert(with: "Не удалось обновить данные об автомобиле")
            }
        }
    }

}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return registrations?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = registrationsCollectionView
            .dequeueReusableCell(withReuseIdentifier: String(describing: RegistrationCollectionViewCell.self),
                                 for: indexPath) as? RegistrationCollectionViewCell {
            if let registration = registrations?[indexPath.row] {
                cell.configure(registration)
            }
            return cell
        }
        return UICollectionViewCell()
        
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return false
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print("ASK")
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SELECTED")
        if let id = registrations?[indexPath.row].identifier {
            self.present(presentationAssembly.buildNavigationController(root: presentationAssembly.buildServiceRegistrationViewController(with: id)), animated: true)
        }
        
        //        let cell = collectionView.cellForItem(at: indexPath)
        
        //        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        //        animation.fromValue = 1
        //        animation.toValue = 0.5
        //        animation.duration = 2
        //        animation.autoreverses = true
        //        cell?.statusLabel.layer.add(animation, forKey: #keyPath(CALayer.opacity))
        //        cell?.statusLabel.layer.opacity = 0.5
        //        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: []) {
        //            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
        //                cell?.transform = .init(scaleX: 0.8, y: 0.8)
        //            }
        //            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
        //                cell?.transform = .init(scaleX: 1, y: 1)
        //            }
        //        }
        
        //        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse]) {
        //            cell?.transform = .init(scaleX: 0.6, y: 0.6)
        //        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

class FullWidthCollectionViewCell: UICollectionViewCell {
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        // Replace the height in the target size to
        // allow the cell to flexibly compute its height
        var targetSize = targetSize
        targetSize.height = CGFloat.greatestFiniteMagnitude
        
        // The .required horizontal fitting priority means
        // the desired cell width (targetSize.width) will be
        // preserved. However, the vertical fitting priority is
        // .fittingSizeLevel meaning the cell will find the
        // height that best fits the content
        let size = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return size
    }
}

extension UICollectionView {
    var widestCellWidth: CGFloat {
        let insets = contentInset.left + contentInset.right
        return bounds.width - insets
    }
}
