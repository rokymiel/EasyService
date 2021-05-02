//
//  UIRoundedTextFieldTest.swift
//  EasyServiceTests
//
//  Created by Михаил on 03.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import EasyService

class UIRoundedTextFieldTest: FBSnapshotTestCase {
    var textField: UIRoundedTextField!
    override func setUp() {
        super.setUp()
        textField = UIRoundedTextField(frame: .init(x: 0, y: 0, width: 100, height: 30))
        textField.text = "Текст"
        self.recordMode = false
    }
    
    func test_uiRoundedTextField() {
        FBSnapshotVerifyView(textField)
    }
}
