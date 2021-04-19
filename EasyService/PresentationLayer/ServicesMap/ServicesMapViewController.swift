//
//  ServicesMapViewController.swift
//  EasyService
//
//  Created by Михаил on 11.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ServicesMapViewController: UIViewController {
    enum CardState {
        case expanded
        case collapsed
    }
    
    var visualEffectView: UIVisualEffectView!
    lazy var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    private var isSearching = false
    private let cellReuseIdentifier = "searchCell"
    
    private var registrationService: IRegistrationService!
    private var presentationAssembly: IPresentationAssembly!
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var serviceDetaildController: AnnotationDetailsViewController!
    
    class func sInit(presentationAssembly: IPresentationAssembly, registrationService: IRegistrationService) -> ServicesMapViewController {
        let contraller = UIStoryboard.servicesMapView.instantiate(self)
        contraller.registrationService = registrationService
        contraller.presentationAssembly = presentationAssembly
        return contraller
    }
    private var searchString: String? = nil
    private var servicePoints: [ServiceMKAnnotation]?
    private var filteredPoints: [ServiceMKAnnotation] {
        if let items = servicePoints {
            if let searchString = searchString?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
               !searchString.isEmpty {
                return items.filter { $0.service.name.lowercased().contains(searchString)}
            }
            return items
        }
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCard()
        hideKeyboardWhenTappedAround()
        registrationService.getServices { result in
            switch result {
            case .success(let services):
                self.servicePoints = services.map({ ServiceMKAnnotation(service: $0)
                })
                self.mapView.addAnnotations(self.servicePoints ?? [])
            case .failure(let error):
                print(error)
            }
        }
        searchView.layer.cornerRadius = 15
        searchView.layer.cornerCurve = .continuous
        searchView.setBlur()
        checkLocationServices()
        mapView.delegate = self
        searchTableView.layer.cornerRadius = 15
        searchTableView.layer.cornerCurve = .continuous
        searchBar.delegate = self
        //        searchTableView.register(UITableViewCell.De.self, forCellReuseIdentifier: cellReuseIdentifier)
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
    }
    
    func setupCard() {
        //        visualEffectView = UIVisualEffectView()
        //        visualEffectView.frame = view.frame
        ////        view.addSubview(visualEffectView)
        //        view.insertSubview(visualEffectView, at: 0)
        
        serviceDetaildController = AnnotationDetailsViewController(presentationAssembly: presentationAssembly, nibName: "AnnotationDetailsViewController", bundle: nil)
        addChild(serviceDetaildController)
        view.addSubview(serviceDetaildController.view)
        
        serviceDetaildController.view.frame = CGRect(x: 0,
                                                     y: view.frame.height ,
                                                     width: view.bounds.width,
                                                     height: 2*view.frame.height/3)
        serviceDetaildController.view.clipsToBounds = true
        
        
    }
    
    @objc func handleCardTap(recognizer: UITapGestureRecognizer) {
        
    }
    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
        
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animation in runningAnimations {
            animation.pauseAnimation()
            animationProgressWhenInterrupted = animation.fractionComplete
        }
    }
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animation in runningAnimations {
            animation.pauseAnimation()
            animation.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    func continueInteractiveTransition() {
        for animation in runningAnimations {
            animation.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimation = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.serviceDetaildController.view.frame.origin.y = self.view.frame.height - 2*self.view.frame.height/3
                case .collapsed:
                    self.serviceDetaildController.view.frame.origin.y = 0
                }
            }
            
            frameAnimation.addCompletion { (_) in
                self.runningAnimations.removeAll()
            }
            
            frameAnimation.startAnimation()
            runningAnimations.append(frameAnimation)
        }
    }
    func hide() {
        serviceDetaildController.view.frame = CGRect(x: 0, y: self.view.frame.height, width:  serviceDetaildController.view.frame.width, height:  serviceDetaildController.view.frame.height)
    }
}

extension ServicesMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //        let translation = recognizer.translation(in: self.view)
        if let annotation = (view.annotation as? ServiceMKAnnotation) {
            serviceDetaildController.configure(annotation.service)
            var region = MKCoordinateRegion(center: annotation.coordinate, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
            region.center.latitude -= 0.05 / 4.5
            
            self.mapView.setRegion(region, animated: true)
            
        }
        serviceDetaildController.view.frame = CGRect(x: 0, y: self.view.frame.height/3, width:  serviceDetaildController.view.frame.width, height:  serviceDetaildController.view.frame.height)
        //        recognizer.setTranslation(.zero, in: self.view)
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("DEselected")
        hide()
    }
}

extension ServicesMapViewController: CLLocationManagerDelegate {
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        guard let location = locations.last else { return }
    //        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
    //        mapView.setRegion(region, animated: true)
    //    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            followUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            // Show alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show alert
            break
        case .authorizedAlways:
            break
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // the user didn't turn it on
        }
    }
    
    func followUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension ServicesMapViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        mapView.deselectAnnotation(nil, animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTableView.isHidden = false
        if searchText.isBlank() {
            if isSearching {
                hideSearchTable()
            }
        } else if !isSearching {
            showSearchTable()
            
        }
        if isSearching {
            searchString = searchText
            searchTableView.reloadData()
        }
    }
    
    func hideSearchTable() {
        isSearching = false
        UIView.transition(with: searchTableView, duration: 0.2,
                          options: [.transitionCrossDissolve, .showHideTransitionViews],
                          animations: {
                            self.searchTableView.layer.opacity = 0 },
                          completion: { _ in
                            self.searchTableView.isHidden = true })
    }
    func showSearchTable() {
        isSearching = true
        UIView.transition(with: searchTableView, duration: 0.4,
                          options: [.transitionFlipFromTop, .showHideTransitionViews],
                          animations: {
                            self.searchTableView.layer.opacity = 1
                            self.searchTableView.isHidden = false
                          })
    }
}

extension ServicesMapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredPoints.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) ?? UITableViewCell()
        
        let points = filteredPoints[indexPath.row]
        cell.textLabel?.text = points.service.name
        cell.detailTextLabel?.text = points.service.address
        return cell
    }
}

extension ServicesMapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hideSearchTable()
        mapView.selectAnnotation(filteredPoints[indexPath.row], animated: true)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
