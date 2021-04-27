//
//  Resources.swift
//  EasyService
//
//  Created by Михаил on 27.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation

protocol IResources {
    func getData(forResource: String, withExtension: String) -> Data?
}

class Resources: IResources {
    func getData(forResource: String, withExtension: String) -> Data? {
        if let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) {
            return try? Data(contentsOf: url)
        }
        return nil
    }
}
