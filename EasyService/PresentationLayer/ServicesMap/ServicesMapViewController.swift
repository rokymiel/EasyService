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
    
    private var registrationService: IRegistrationService!
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var serviceDetaildController: AnnotationDetailsViewController!
    
    class func sInit(registrationService: IRegistrationService) -> ServicesMapViewController {
        let contraller = UIStoryboard.servicesMapView.instantiate(self)
        contraller.registrationService = registrationService
        return contraller
    }
    
    private var servicePoints: [ServiceMKAnnotation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCard()
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
        checkLocationServices()
        mapView.delegate = self
        
    }
    
    func setupCard() {
//        visualEffectView = UIVisualEffectView()
//        visualEffectView.frame = view.frame
////        view.addSubview(visualEffectView)
//        view.insertSubview(visualEffectView, at: 0)
        
        serviceDetaildController = AnnotationDetailsViewController(nibName: "AnnotationDetailsViewController", bundle: nil)
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
}

extension ServicesMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        let translation = recognizer.translation(in: self.view)
        serviceDetaildController.view.frame = CGRect(x: 0, y: self.view.frame.height/3, width:  serviceDetaildController.view.frame.width, height:  serviceDetaildController.view.frame.height)
//        recognizer.setTranslation(.zero, in: self.view)
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("DEselected")
        serviceDetaildController.view.frame = CGRect(x: 0, y: self.view.frame.height, width:  serviceDetaildController.view.frame.width, height:  serviceDetaildController.view.frame.height)
    }
}

extension ServicesMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
        mapView.setRegion(region, animated: true)
    }
    
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
