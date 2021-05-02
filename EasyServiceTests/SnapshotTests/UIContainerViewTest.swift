//
//  UIContainerViewTest.swift
//  EasyServiceTests
//
//  Created by Михаил on 03.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import EasyService

class UIContainerViewTest: FBSnapshotTestCase {
    var view: UIContainerView!
    override func setUp() {
        super.setUp()
        view = UIContainerView(frame: .init(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .white
        view.updateView()
        self.recordMode = false
    }
    
    func test_containerView() {
        FBSnapshotVerifyView(view)
    }
}
