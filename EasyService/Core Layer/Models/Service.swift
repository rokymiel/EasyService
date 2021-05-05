//
//  Service.swift
//  EasyService
//
//  Created by Михаил on 11.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Service: Codable {
    @DocumentID var identifier: String?
    let name: String
    let address: String
    let location: GeoPoint
    let workTime: [String]
    let phone: String
    let workTypes: [String]
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case name
        case address
        case location
        case workTime = "work_time"
        case phone
        case workTypes = "work_types"
    }
}
