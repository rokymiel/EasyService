//
//  RegistrationCollectionViewCellTest.swift
//  EasyServiceTests
//
//  Created by Михаил on 03.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import EasyService

class RegistrationCollectionViewCellTest: FBSnapshotTestCase {
    var cell: RegistrationCollectionViewCell!
    override func setUp() {
        super.setUp()
        cell = RegistrationCollectionViewCell.fromNib()
        cell.configure(.fake(identifier: "ID"))
        self.recordMode = false
    }
    
    func test_registrationCollectionViewCell() {
        FBSnapshotVerifyView(cell)
    }
}
