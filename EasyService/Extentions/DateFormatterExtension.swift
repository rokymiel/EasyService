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
    
    static func monthFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .preferredLocale
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter
    }
    
    static func fullDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = .preferredLocale
        return dateFormatter
    }
    
    static func fullDateWithTimeFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateFormatter.locale = .preferredLocale
        return dateFormatter
    }
    
    static func timeFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = .init(identifier: "ru")
        return dateFormatter
    }
    
    static func dayMonthDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        dateFormatter.locale = .preferredLocale
        return dateFormatter
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
        return DateFormatter.monthFormatter().string(from: self)
    }
    
    var fullDate: String {
        return DateFormatter.fullDateFormatter().string(from: self)
    }
    
    var fullDateWithTime: String {
        return DateFormatter.fullDateWithTimeFormatter().string(from: self)
    }
    
    var time: String  {
        return DateFormatter.timeFormatter().string(from: self)
    }
    
    var dayMonthDate: String {
        return DateFormatter.dayMonthDateFormatter().string(from: self)
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
