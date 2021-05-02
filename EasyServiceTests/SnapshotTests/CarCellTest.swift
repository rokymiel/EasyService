//
//  CarCellTest.swift
//  EasyServiceTests
//
//  Created by Михаил on 02.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import EasyService

class CarCellTest: FBSnapshotTestCase {
    var cell: CarViewCell!
    override func setUp() {
        super.setUp()
        cell = CarViewCell(style: .default, reuseIdentifier: "cell")
        cell.frame = .init(x: 0, y: 0, width: 444, height: 90)
        cell.configure(.fake(identifier: "ID"))
        self.recordMode = false
    }
    
    func test_carCell() {
        FBSnapshotVerifyView(cell)
    }
}
