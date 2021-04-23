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

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .preferredLocale
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
}

extension Locale {
    static var preferredLocale: Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
}
