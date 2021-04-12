//
//  ServiceMKAnnotation.swift
//  EasyService
//
//  Created by Михаил on 12.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import MapKit

class ServiceMKAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    private(set) var service: Service
    
    init(service: Service) {
        self.service = service
        coordinate = CLLocationCoordinate2D(latitude: service.location.latitude, longitude: service.location.longitude)
        title = service.name
    }
}
