//
//  DateFormatterExtension.swift
//  EasyService
//
//  Created by Михаил on 07.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import Foundation

extension DateFormatter {
    func isDate(string: String) -> Bool {
        return self.date(from: string) != nil
    }
}
