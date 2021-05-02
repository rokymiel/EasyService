//
//  CarFake.swift
//  EasyServiceTests
//
//  Created by Михаил on 02.05.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

@testable import EasyService

extension Car {
    static func fake(identifier: String,
                     mark: String? = nil,
                     model: String? = nil,
                     body: String? = nil,
                     gear: String? = nil,
                     engine: Double? = nil,
                     productionYear: Int? = nil,
                     mileage: [Mileage]? = nil) -> Car {
        .init(identifier: identifier,
              mark: mark ?? "Audi",
              model: model ?? "A7",
              body: body ?? "седан",
              gear: gear ?? "робот",
              engine: engine ?? 2.4,
              productionYear: productionYear ?? 2019,
              mileage: mileage ?? [])
    }
}
