//
//  UpdateDelegateStub.swift
//  EasyServiceTests
//
//  Created by Михаил on 02.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService

class UpdateDelegateStub: UpdateDelegate {
    
    func updated(_ sender: Any) {}
    
    func faild(with error: Error, _ sender: Any) {}
}
