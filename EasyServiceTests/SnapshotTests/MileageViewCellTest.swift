//
//  MileageViewCellTest.swift
//  EasyServiceTests
//
//  Created by Михаил on 03.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import EasyService

class MileageViewCellTest: FBSnapshotTestCase {
    var cell: MileageViewCell!
    override func setUp() {
        super.setUp()
        cell = MileageViewCell(reuseIdentifier: "cell")
        cell.configure(.init(date: Date(timeIntervalSince1970: 0), value: 1000, isVerified: true))
        self.recordMode = false
    }
    
    func test_mileageViewCell() {
        FBSnapshotVerifyView(cell)
    }
}
