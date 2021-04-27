//
//  UpdateDelegate.swift
//  EasyService
//
//  Created by Михаил on 27.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation

@objc protocol UpdateDelegate: class {
    func updated(_ sender: Any)
    func faild(with error: Error, _ sender: Any)
}
