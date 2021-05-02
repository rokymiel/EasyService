//
//  UIEdgeInsetLabelTest.swift
//  EasyServiceTests
//
//  Created by Михаил on 03.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import EasyService

class UIEdgeInsetLabelTest: FBSnapshotTestCase {
    var label: UIEdgeInsetLabel!
    override func setUp() {
        super.setUp()
        label = UIEdgeInsetLabel(frame: .init(x: 0, y: 0, width: 70, height: 30))
        label.textInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        label.text = "Текст"
        self.recordMode = false
    }
    
    func test_uiEdgeInsetLabel() {
        FBSnapshotVerifyView(label)
    }
}
