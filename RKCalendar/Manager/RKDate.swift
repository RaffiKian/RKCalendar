//
//  RKDate.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

struct RKDate {
    
    var date: Date
    let calendar: Calendar
    
    var isDisabled: Bool = false
    var isToday: Bool = false
    var isSelected: Bool = false
    var isBetweenStartAndEnd: Bool = false
    
    init(date: Date, calendar: Calendar, isDisabled: Bool, isToday: Bool, isSelected: Bool, isBetweenStartAndEnd: Bool) {
        self.date = date
        self.calendar = calendar
        self.isDisabled = isDisabled
        self.isToday = isToday
        self.isSelected = isSelected
        self.isBetweenStartAndEnd = isBetweenStartAndEnd
    }
    
    func getText() -> String {
        let day = formatDate(date: date, calendar: calendar)
        return day
    }
    
    func getTextColor() -> Color {
        var textColor = Color.primary
        if isDisabled {
            textColor = Color.gray
        } else if isSelected {
            textColor = Color.white
        } else if isToday {
            textColor = Color.white
        } else if isBetweenStartAndEnd {
            textColor = Color.white
        }
        return textColor
    }
    
    func getBackgroundColor() -> Color {
        var backgroundColor = Color.clear
        if isBetweenStartAndEnd {
            backgroundColor = Color.blue
        }
        if isToday {
            backgroundColor = Color.gray
        }
        if isDisabled {
            backgroundColor = Color.clear
        }
        if isSelected {
            backgroundColor = Color.red
        }
        return backgroundColor
    }
    
    func getFontWeight() -> Font.Weight {
        var fontWeight = Font.Weight.medium
        if isDisabled {
            fontWeight = Font.Weight.thin
        } else if isSelected {
            fontWeight = Font.Weight.heavy
        } else if isToday {
            fontWeight = Font.Weight.heavy
        } else if isBetweenStartAndEnd {
            fontWeight = Font.Weight.heavy
        }
        return fontWeight
    }
    
    // MARK: - Date Formats
    
    func formatDate(date: Date, calendar: Calendar) -> String {
        let formatter = dateFormatter()
        return stringFrom(date: date, formatter: formatter, calendar: calendar)
    }
    
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "d"
        return formatter
    }
    
    func stringFrom(date: Date, formatter: DateFormatter, calendar: Calendar) -> String {
        if formatter.calendar != calendar {
            formatter.calendar = calendar
        }
        return formatter.string(from: date)
    }
}
