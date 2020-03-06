//
//  RKManager.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

public class RKManager : ObservableObject {
    
    @Published public var calendar = Calendar.current
    @Published public var minimumDate: Date = Date()
    @Published public var maximumDate: Date = Date()
    @Published public var disabledDates: [Date] = [Date]()
    @Published public var selectedDates: [Date] = [Date]()
    @Published public var selectedDate: Date! = nil
    @Published public var startDate: Date! = nil
    @Published public var endDate: Date! = nil
    
    // when true display a continuous calendar of months, when false display one month at a time
    @Published public var isContinuous = true
    
    // must have isWeeklyView=false
    @Published public var isVertical = true
    
    // must have isVertical=false
    @Published var isWeeklyView: Bool = false {
        willSet {
            if isWeeklyView {
                isVertical = false
            }
        }
    }
    
    // mode=0 to select a single date.
    // mode=1 to select a contiguous range of dates, from a start date (mode=1) to an end date (mode=2).
    // mode=3 for multi dates selections.
    @Published public var mode: Int = 0
    
    // allow disabling of user input for the current mode
    @Published public var disabled: Bool = false
    
    // allow time (hh:mm) to be set and displayed on a long press
    @Published public var displayTime: Bool = false
    
    public var colors = RKColorSettings()
    
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    
    public init(calendar: Calendar, minimumDate: Date, maximumDate: Date, selectedDates: [Date] = [Date](), mode: Int) {
        self.calendar = calendar
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.selectedDates = selectedDates
        self.mode = mode
    }
    
    func selectedDatesContains(date: Date) -> Bool {
        if let _ = self.selectedDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return true
        }
        return false
    }
    
    func selectedDatesFindIndex(date: Date) -> Int? {
        return self.selectedDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) })
    }
    
    func disabledDatesContains(date: Date) -> Bool {
        if let _ = self.disabledDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return true
        }
        return false
    }
    
    func disabledDatesFindIndex(date: Date) -> Int? {
        return self.disabledDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) })
    }
    
    static func getDateTimeAsString(_ date: Date?) -> String {
        if date == nil { return "" }
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-HH-mm"
        format.timeZone = TimeZone.current
        format.locale = Locale.current
        return format.string(from: date!)
    }
    
    static func getTextFromDate(_ date: Date?) -> String {
        if date == nil { return "" }
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return date == nil ? "" : formatter.string(from: date!)
    }
    
    static func getTextFromDateTime(_ date: Date?) -> String {
        if date == nil { return "" }
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE, MMMM d HH:mm, yyyy"
        return date == nil ? "" : formatter.string(from: date!)
    }
    
    func RKFormatDate(date: Date) -> Date {
        let components = calendar.dateComponents(calendarUnitYMD, from: date)
        return calendar.date(from: components)!
    }
    
    func RKFormatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = RKFormatDate(date: referenceDate)
        let clampedDate = RKFormatDate(date: date)
        return refDate == clampedDate
    }
    
    func RKFirstDateMonth() -> Date {
        var components = calendar.dateComponents(calendarUnitYMD, from: minimumDate)
        components.day = 1
        return calendar.date(from: components)!
    }
    
    func RKMaximumDateMonthLastDay() -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: maximumDate)
        components.month! += 1
        components.day = 0
        return calendar.date(from: components)!
    }
    
    // MARK: - Date Property functions
    
    func isToday(date: Date) -> Bool {
        return RKFormatAndCompareDate(date: date, referenceDate: Date())
    }
    
    func isSpecialDate(date: Date) -> Bool {
        return isSelectedDate(date: date) ||
            isStartDate(date: date) ||
            isEndDate(date: date) ||
            isOneOfSelectedDates(date: date)
    }
    
    func isOneOfSelectedDates(date: Date) -> Bool {
        return selectedDatesContains(date: date)
    }
    
    func isSelectedDate(date: Date) -> Bool {
        if selectedDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: selectedDate)
    }
    
    func isStartDate(date: Date) -> Bool {
        if startDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: startDate)
    }
    
    func isEndDate(date: Date) -> Bool {
        if endDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: endDate)
    }
    
    func isOneOfDisabledDates(date: Date) -> Bool {
        return disabledDatesContains(date: date)
    }
    
    func isEnabled(date: Date) -> Bool {
        let clampedDate = RKFormatDate(date: date)
        if calendar.compare(clampedDate, to: minimumDate, toGranularity: .day) == .orderedAscending || calendar.compare(clampedDate, to: maximumDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return !isOneOfDisabledDates(date: date)
    }
    
    func isStartDateAfterEndDate() -> Bool {
        if startDate == nil {
            return false
        } else if endDate == nil {
            return false
        } else if calendar.compare(endDate, to: startDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    func isBetweenStartAndEnd(date: Date) -> Bool {
        if startDate == nil {
            return false
        } else if endDate == nil {
            return false
        } else if calendar.compare(date, to: startDate, toGranularity: .day) == .orderedAscending {
            return false
        } else if calendar.compare(date, to: endDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    func isBetweenMinAndMaxDates(date: Date) -> Bool {
        return (min(minimumDate, maximumDate) ... max(minimumDate, maximumDate)).contains(date)
    }
  
}
