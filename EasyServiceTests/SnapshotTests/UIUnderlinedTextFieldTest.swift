//
//  UIUnderlinedTextFieldTest.swift
//  EasyServiceTests
//
//  Created by Михаил on 03.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import EasyService

class UIUnderlinedTextFieldTest: FBSnapshotTestCase {
    var textField: UIUnderlinedTextField!
    override func setUp() {
        super.setUp()
        textField = UIUnderlinedTextField(frame: .init(x: 0, y: 0, width: 50, height: 30))
        textField.text = "Текст"
        self.recordMode = false
    }
    
    func test_uiUnderlinedTextField() {
        FBSnapshotVerifyView(textField)
    }
}
