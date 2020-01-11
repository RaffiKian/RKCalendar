//
//  RKMonth.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

struct RKMonth: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var rkManager: RKManager
    
    let monthOffset: Int
    
    @State var weekOffset: Int?
    
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    let daysPerWeek = 7
    var monthsArray: [[Date]] {
        monthArray()
    }
    let cellWidth = CGFloat(32)
    
    // to trigger the time selection view
    @State var showTime = false
    // to "refresh" the dependent views
    @State var hasTime = false
    // holds the date and time of the selection
    @State var timeDate = Date()
    
    
    var body: some View {
        self.rkManager.isWeeklyView ? AnyView(self.weeklyView) : AnyView(self.monthlyView)
    }
    
    var monthlyView: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(monthsArray, id:  \.self) { row in
                HStack() {
                    ForEach(row, id:  \.self) { column in
                        HStack() {
                            Spacer()
                            if self.isThisMonth(date: column) {
                                RKCell(rkDate: RKDate(
                                    date: column,
                                    rkManager: self.rkManager,
                                    isDisabled: !self.isEnabled(date: column),
                                    isToday: self.isToday(date: column),
                                    isSelected: self.isSpecialDate(date: column),
                                    isBetweenStartAndEnd: self.isBetweenStartAndEnd(date: column)),
                                       cellWidth: self.cellWidth, hasTime: self.$hasTime)
                                    .onTapGesture { self.dateTapped(date: column) }
                                    .onLongPressGesture { self.showTime = self.isLongEnabled(date: column) }
                            } else {
                                Text("").frame(width: self.cellWidth, height: self.cellWidth)
                            }
                            Spacer()
                        }
                    }
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
        }.background(rkManager.colors.monthBackColor)
            .sheet(isPresented: self.$showTime) {
                RKTimeView(rkManager: self.rkManager, date: self.$timeDate, showTime: self.$showTime, hasTime: self.$hasTime)
        }
    }
    
    var weeklyView: some View {
        weekOffset == nil ? AnyView(self.weeklyViewContinuous) : AnyView(self.weeklyViewPage)
    }
    
    var weeklyViewPage: some View {
        HStack(spacing: 10) {
            ForEach(monthsArray[weekOffset!], id:  \.self) { column in
                HStack {
                    Spacer()
                    if self.isThisMonth(date: column) {
                        RKCell(rkDate: RKDate(
                            date: column,
                            rkManager: self.rkManager,
                            isDisabled: !self.isEnabled(date: column),
                            isToday: self.isToday(date: column),
                            isSelected: self.isSpecialDate(date: column),
                            isBetweenStartAndEnd: self.isBetweenStartAndEnd(date: column)),
                               cellWidth: self.cellWidth, hasTime: self.$hasTime)
                            .onTapGesture { self.dateTapped(date: column) }
                            .onLongPressGesture { self.showTime = self.isLongEnabled(date: column) }
                    } else {
                        Text("").frame(width: self.cellWidth, height: self.cellWidth)
                    }
                    Spacer()
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
        }.background(rkManager.colors.monthBackColor)
            .sheet(isPresented: self.$showTime) {
                RKTimeView(rkManager: self.rkManager, date: self.$timeDate, showTime: self.$showTime, hasTime: self.$hasTime)
        }
    }
    
    var weeklyViewContinuous: some View {
        HStack(spacing: 10) {
            ForEach(monthsArray, id:  \.self) { row in
                HStack(spacing: 15) {
                    ForEach(row, id:  \.self) { column in
                        HStack {
                            Spacer()
                            if self.isThisMonth(date: column) {
                                RKCell(rkDate: RKDate(
                                    date: column,
                                    rkManager: self.rkManager,
                                    isDisabled: !self.isEnabled(date: column),
                                    isToday: self.isToday(date: column),
                                    isSelected: self.isSpecialDate(date: column),
                                    isBetweenStartAndEnd: self.isBetweenStartAndEnd(date: column)),
                                       cellWidth: self.cellWidth, hasTime: self.$hasTime)
                                    .onTapGesture { self.dateTapped(date: column) }
                                    .onLongPressGesture { self.showTime = self.isLongEnabled(date: column) }
                            } else {
                                Text("").frame(width: self.cellWidth, height: self.cellWidth)
                            }
                            Spacer()
                        }
                    }
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
        }.background(rkManager.colors.monthBackColor)
            .sheet(isPresented: self.$showTime) {
                RKTimeView(rkManager: self.rkManager, date: self.$timeDate, showTime: self.$showTime, hasTime: self.$hasTime)
        }
    }
    
    func isLongEnabled(date: Date) -> Bool {
        if rkManager.disabled {return false}
        if self.isEnabled(date: date) {
            timeDate = rkManager.calendar.startOfDay(for: date)
        }
        return self.isEnabled(date: date) && rkManager.displayTime
    }
    
    func isThisMonth(date: Date) -> Bool {
        return self.rkManager.calendar.isDate(date, equalTo: firstOfMonthForOffset(), toGranularity: .month)
    }
    
    func dateTapped(date: Date) {
        if rkManager.disabled {return}
        if self.isEnabled(date: date) {
            switch rkManager.mode {
            case 0:
                if rkManager.selectedDate != nil &&
                    rkManager.calendar.isDate(rkManager.selectedDate, inSameDayAs: date) {
                    rkManager.selectedDate = nil
                } else {
                    rkManager.selectedDate = date
                }
            case 1:
                if rkManager.startDate != nil &&
                    rkManager.calendar.isDate(rkManager.startDate, inSameDayAs: date) {
                    rkManager.startDate = nil
                } else {
                    rkManager.startDate = date
                    rkManager.endDate = nil
                    rkManager.mode = 2
                }
            case 2:
                if rkManager.endDate != nil &&
                    rkManager.calendar.isDate(rkManager.endDate, inSameDayAs: date) {
                    rkManager.endDate = nil
                } else {
                    rkManager.endDate = date
                    if isStartDateAfterEndDate() {
                        rkManager.endDate = nil
                        rkManager.startDate = nil
                    }
                }
                rkManager.mode = 1
            case 3:
                if rkManager.selectedDatesContains(date: date) {
                    if let ndx = rkManager.selectedDatesFindIndex(date: date) {
                        rkManager.selectedDates.remove(at: ndx)
                    }
                } else {
                    rkManager.selectedDates.append(date)
                }
            default:
                rkManager.selectedDate = date
            }
        }
    }
    
    func monthArray() -> [[Date]] {
        var rowArray = [[Date]]()
        for row in 0 ..< (numberOfDays(offset: monthOffset) / 7) {
            var columnArray = [Date]()
            for column in 0 ... 6 {
                let abc = self.getDateAtIndex(index: (row * 7) + column)
                columnArray.append(abc)
            }
            rowArray.append(columnArray)
        }
//        print("\n-----> monthOffset: \(monthOffset) rowArray: \(rowArray.debugDescription)")
        return rowArray
    }
    
    func getDateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstOfMonthForOffset()
        let weekday = rkManager.calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - rkManager.calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        var dateComponents = DateComponents()
        dateComponents.day = index - startOffset
        
        return rkManager.calendar.date(byAdding: dateComponents, to: firstOfMonth)!
    }
    
    func numberOfDays(offset : Int) -> Int {
        let firstOfMonth = firstOfMonthForOffset()
        let rangeOfWeeks = rkManager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)
        
        return (rangeOfWeeks?.count)! * daysPerWeek
    }
    
    func firstOfMonthForOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset
        
        return rkManager.calendar.date(byAdding: offset, to: RKFirstDateMonth())!
    }
    
    func RKFormatDate(date: Date) -> Date {
        let components = rkManager.calendar.dateComponents(calendarUnitYMD, from: date)
        
        return rkManager.calendar.date(from: components)!
    }
    
    func RKFormatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = RKFormatDate(date: referenceDate)
        let clampedDate = RKFormatDate(date: date)
        return refDate == clampedDate
    }
    
    func RKFirstDateMonth() -> Date {
        var components = rkManager.calendar.dateComponents(calendarUnitYMD, from: rkManager.minimumDate)
        components.day = 1
        
        return rkManager.calendar.date(from: components)!
    }
    
    // MARK: - Date Property Checkers
    
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
        return self.rkManager.selectedDatesContains(date: date)
    }
    
    func isSelectedDate(date: Date) -> Bool {
        if rkManager.selectedDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: rkManager.selectedDate)
    }
    
    func isStartDate(date: Date) -> Bool {
        if rkManager.startDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: rkManager.startDate)
    }
    
    func isEndDate(date: Date) -> Bool {
        if rkManager.endDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: rkManager.endDate)
    }
    
    func isBetweenStartAndEnd(date: Date) -> Bool {
        if rkManager.startDate == nil {
            return false
        } else if rkManager.endDate == nil {
            return false
        } else if rkManager.calendar.compare(date, to: rkManager.startDate, toGranularity: .day) == .orderedAscending {
            return false
        } else if rkManager.calendar.compare(date, to: rkManager.endDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    func isOneOfDisabledDates(date: Date) -> Bool {
        return self.rkManager.disabledDatesContains(date: date)
    }
    
    func isEnabled(date: Date) -> Bool {
        let clampedDate = RKFormatDate(date: date)
        if rkManager.calendar.compare(clampedDate, to: rkManager.minimumDate, toGranularity: .day) == .orderedAscending || rkManager.calendar.compare(clampedDate, to: rkManager.maximumDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return !isOneOfDisabledDates(date: date)
    }
    
    func isStartDateAfterEndDate() -> Bool {
        if rkManager.startDate == nil {
            return false
        } else if rkManager.endDate == nil {
            return false
        } else if rkManager.calendar.compare(rkManager.endDate, to: rkManager.startDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
}

#if DEBUG
struct RKMonth_Previews : PreviewProvider {
    static var previews: some View {
        RKMonth(isPresented: .constant(false),rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), monthOffset: 0, weekOffset: -1)
    }
}
#endif

