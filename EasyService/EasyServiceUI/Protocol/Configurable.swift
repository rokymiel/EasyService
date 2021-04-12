//
//  Configurable.swift
//  EasyService
//
//  Created by Михаил on 13.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation

protocol Configurable {
    associatedtype Model
    
    func configure(_ model: Model)
}
