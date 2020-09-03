//
//  RKDate.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

public struct RKDate {

    public var date: Date
    public let rkManager: RKManager
    
    var isDisabled: Bool = false
    var isToday: Bool = false
    var isSelected: Bool = false
    var isBetweenStartAndEnd: Bool = false
    

    public init(date: Date, rkManager: RKManager) {
        self.date = date
        self.rkManager = rkManager
        self.isDisabled = !rkManager.isEnabled(date: date)
        self.isToday = rkManager.isToday(date: date)
        self.isSelected = rkManager.isSpecialDate(date: date)
        self.isBetweenStartAndEnd = rkManager.isBetweenStartAndEnd(date: date)
    }
    
    public func getText() -> String {
        let day = formatDate(date: date, calendar: self.rkManager.calendar)
        return day
    }
     
    public func getTimeText() -> String {
        var txt = ""
        var hours = 0
        var minutes = 0

        switch rkManager.mode {
        case .singleDate:
            hours = rkManager.calendar.component(.hour, from: rkManager.selectedDate)
            minutes = rkManager.calendar.component(.minute, from: rkManager.selectedDate)
        case .dateRange, .dateRange2:
            if rkManager.startDate != nil && rkManager.calendar.isDate(rkManager.startDate, inSameDayAs: date) {
                hours = rkManager.calendar.component(.hour, from: rkManager.startDate)
                minutes = rkManager.calendar.component(.minute, from: rkManager.startDate)
            }
             if rkManager.endDate != nil && rkManager.calendar.isDate(rkManager.endDate, inSameDayAs: date) {
                hours = rkManager.calendar.component(.hour, from: rkManager.endDate)
                minutes = rkManager.calendar.component(.minute, from: rkManager.endDate)
            }
        case .multiDate:
            if let theDate = rkManager.selectedDates.first(where: {rkManager.calendar.isDate($0, inSameDayAs: date)}) {
                hours = rkManager.calendar.component(.hour, from: theDate)
                minutes = rkManager.calendar.component(.minute, from: theDate)
            }
        }
        txt = (hours <= 9 ? "0" : "") + String(hours) + ":" + (minutes <= 9 ? "0" : "") + String(minutes)
        return txt
    }
    
    public func getTextColor() -> Color {
        var textColor = rkManager.colors.textColor
        if isDisabled {
            textColor = rkManager.colors.disabledColor
        } else if isSelected {
            textColor = rkManager.colors.selectedColor
        } else if isToday {
            textColor = rkManager.colors.todayColor
        } else if isBetweenStartAndEnd {
            textColor = rkManager.colors.betweenStartAndEndColor
        }
        return textColor
    }
    
    public func getBackgroundColor() -> Color {
        var backgroundColor = rkManager.colors.textBackColor
        if isBetweenStartAndEnd {
            backgroundColor = rkManager.colors.betweenStartAndEndBackColor
        }
        if isToday {
            backgroundColor = rkManager.colors.todayBackColor
        }
        if isDisabled {
            backgroundColor = rkManager.colors.disabledBackColor
        }
        if isSelected {
            backgroundColor = rkManager.colors.selectedBackColor
        }
        return backgroundColor
    }
    
    public func getFontWeight() -> Font.Weight {
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
    
    public func formatDate(date: Date, calendar: Calendar) -> String {
        let formatter = dateFormatter()
        return stringFrom(date: date, formatter: formatter, calendar: calendar)
    }
    
    public func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "d"
        return formatter
    }
    
    public func stringFrom(date: Date, formatter: DateFormatter, calendar: Calendar) -> String {
        if formatter.calendar != calendar {
            formatter.calendar = calendar
        }
        return formatter.string(from: date)
    }
}

