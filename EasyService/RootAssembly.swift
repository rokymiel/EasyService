//
//  RootAssembly.swift
//  EasyService
//
//  Created by Михаил on 03.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

protocol IRootAssembly {
    static func newRootAssembly() -> IRootAssembly
    var coreAssembly: ICoreAssembly { get }
    var serviceAssembly: IServiceAssembly { get }
    var presentationAssembly: IPresentationAssembly { get }
}

class RootAssembly: IRootAssembly {
    
    private init(coreAssembly: ICoreAssembly, serviceAssembly: IServiceAssembly, presentationAssembly: IPresentationAssembly) {
        self.coreAssembly = coreAssembly
        self.serviceAssembly = serviceAssembly
        self.presentationAssembly = presentationAssembly
    }
    
    static func newRootAssembly() -> IRootAssembly {
        let coreAssembly = CoreAssembly()
        let serviceAssembly = ServiceAssembly(coreAssembly: coreAssembly)
        let presentationAssembly = PresentationAssembly(serviceAssembly: serviceAssembly)
        return RootAssembly(coreAssembly: coreAssembly, serviceAssembly: serviceAssembly, presentationAssembly: presentationAssembly)
    }
    
    var coreAssembly: ICoreAssembly
    
    var serviceAssembly: IServiceAssembly
    
    var presentationAssembly: IPresentationAssembly
}
