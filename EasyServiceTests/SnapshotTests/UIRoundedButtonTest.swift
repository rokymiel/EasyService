//
//  UIRoundedButtonTest.swift
//  EasyServiceTests
//
//  Created by Михаил on 03.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import EasyService

class UIRoundedButtonTest: FBSnapshotTestCase {
    var button: UIRoundedButton!
    override func setUp() {
        super.setUp()
        button = UIRoundedButton(frame: .init(x: 0, y: 0, width: 200, height: 50))
        button.setTitle("Нажать", for: .normal)
        self.recordMode = false
    }
    
    func test_uiRoundedButton() {
        FBSnapshotVerifyView(button)
    }
}
