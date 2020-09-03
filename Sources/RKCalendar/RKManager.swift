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
    @Published public var locale: Locale = .current
    
    // font settings
    @Published public var weeklyHeaderFont: Font = Font.system(size: 18)
    @Published public var dayFont: Font = Font.system(size: 20)
    @Published public var timeFont: Font = Font.system(size: 12)
    
    // when true display a continuous calendar of months, when false display one month at a time
    @Published public var isContinuous = true
    
    // must have isWeeklyView=false
    @Published public var isVertical = true
    
    // must have isVertical=false
    @Published public var isWeeklyView: Bool = false {
        willSet {
            if isWeeklyView {
                isVertical = false
            }
        }
    }
    
    // mode=.singleDate for a single date.
    // mode=.dateRange for a contiguous range of dates, from a start date (mode=1) to an end date (mode=.dateRange2).
    // mode=.multiDate for multi dates selections.
    @Published public var mode: RKSelectionMode = .singleDate
    
    // allow disabling of user input for the current mode
    @Published public var disabled: Bool = false
    
    // allow time (hh:mm) to be set and displayed on a long press
    @Published public var displayTime: Bool = false
    
    public var colors = RKColorSettings()
    
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    
    public init(calendar: Calendar, minimumDate: Date, maximumDate: Date, selectedDates: [Date] = [Date](), mode: RKSelectionMode) {
        self.calendar = calendar
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.selectedDates = selectedDates
        self.mode = mode
    }
    
    public init() {
        self.calendar = Calendar.current
        self.minimumDate = Date()
        self.maximumDate = Date()
        self.selectedDates = [Date]()
        self.mode = .singleDate
        self.disabledDates = [Date]()
        self.selectedDates = [Date]()
        self.selectedDate = Date()
        self.startDate = nil
        self.endDate = nil
        self.locale = .current
    }
    
    public func selectedDatesContains(date: Date) -> Bool {
        if let _ = selectedDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return true
        }
        return false
    }
    
    public func selectedDatesFindIndex(date: Date) -> Int? {
        return selectedDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) })
    }
    
    public func disabledDatesContains(date: Date) -> Bool {
        if let _ = disabledDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return true
        }
        return false
    }
    
    public func disabledDatesFindIndex(date: Date) -> Int? {
        return disabledDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) })
    }
  
    public func RKFormatDate(date: Date) -> Date {
        let components = calendar.dateComponents(calendarUnitYMD, from: date)
        return calendar.date(from: components)!
    }
    
    public func RKFormatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = RKFormatDate(date: referenceDate)
        let clampedDate = RKFormatDate(date: date)
        return refDate == clampedDate
    }
    
    public func RKFirstDateMonth() -> Date {
        var components = calendar.dateComponents(calendarUnitYMD, from: minimumDate)
        components.day = 1
        return calendar.date(from: components)!
    }
    
    public func RKMaximumDateMonthLastDay() -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: maximumDate)
        components.month! += 1
        components.day = 0
        return calendar.date(from: components)!
    }
    
    // MARK: - Date Property functions
    
    public func isToday(date: Date) -> Bool {
        return RKFormatAndCompareDate(date: date, referenceDate: Date())
    }
    
    public func isSpecialDate(date: Date) -> Bool {
        return isSelectedDate(date: date) ||
            isStartDate(date: date) ||
            isEndDate(date: date) ||
            isOneOfSelectedDates(date: date)
    }
    
    public func isOneOfSelectedDates(date: Date) -> Bool {
        return selectedDatesContains(date: date)
    }
    
    public func isSelectedDate(date: Date) -> Bool {
        if selectedDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: selectedDate)
    }
    
    public func isStartDate(date: Date) -> Bool {
        if startDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: startDate)
    }
    
    public func isEndDate(date: Date) -> Bool {
        if endDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: endDate)
    }
    
    public func isOneOfDisabledDates(date: Date) -> Bool {
        return disabledDatesContains(date: date)
    }
    
    public func isEnabled(date: Date) -> Bool {
        let clampedDate = RKFormatDate(date: date)
        if calendar.compare(clampedDate, to: minimumDate, toGranularity: .day) == .orderedAscending || calendar.compare(clampedDate, to: maximumDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return !isOneOfDisabledDates(date: date)
    }
    
    public func isStartDateAfterEndDate() -> Bool {
        if startDate == nil {
            return false
        } else if endDate == nil {
            return false
        } else if calendar.compare(endDate, to: startDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    public func isBetweenStartAndEnd(date: Date) -> Bool {
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
    
    public func isBetweenMinAndMaxDates(date: Date) -> Bool {
        return (min(minimumDate, maximumDate) ... max(minimumDate, maximumDate)).contains(date)
    }
  
}
