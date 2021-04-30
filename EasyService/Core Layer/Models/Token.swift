//
//  Token.swift
//  EasyService
//
//  Created by Михаил on 29.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation

struct Token: Codable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token
    }
}
