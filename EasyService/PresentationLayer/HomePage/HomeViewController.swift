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
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var registrationsCollectionView: UICollectionView!
    @IBOutlet weak var mileageChartCell: MileageChartViewCell!
    @IBOutlet weak var mileageViewCell: MileageViewCell!
    class func sInit(registrationService:IRegistrationService, carsService: ICarsService) -> HomeViewController {
        let contraller = UIStoryboard.homeView.instantiate(self)
        contraller.carsService = carsService
        contraller.registrationService = registrationService
        return contraller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        registrationsCollectionView.dataSource = self
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
                    if let mileage = car.mileage.max(by: { $0.date < $1.date }) {
                        self?.mileageViewCell.configure(mileage)
                    }
                    self?.mileageChartCell.configure(car.mileage)
                    if let id = car.identifier {
                        self?.registrationService.getRegistrations(with: id, completetion: { result in
                            DispatchQueue.main.async {
                                if case let .success(registrations) = result {
                                    self?.registrations = registrations
                                    self?.registrationsCollectionView.reloadData()
                                }
                            }
                        })
                        
                    }
                }
            }
        }
    }
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
        if let text = headers[section] {
            let header = LabelHeaderView(reuseIdentifier: String(describing: LabelHeaderView.self))
            header.configure(text)
            return header
        }
        print("LOX")
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if headers[section] != nil {
            return 40
        }
        return -1
    }
    private let headers: [Int: String] = [
        1: "Пробег",
        2: "Записи"
    ]
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return registrations?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = registrationsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RegistrationCollectionViewCell.self), for: indexPath) as? RegistrationCollectionViewCell {
            if let registration = registrations?[indexPath.row] {
                cell.configure(registration)
            }
            return cell
        }
        return UICollectionViewCell()
        
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
