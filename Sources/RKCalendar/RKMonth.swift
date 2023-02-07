//
//  RKMonth.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

public struct RKMonth: View {

    @EnvironmentObject public var rkManager: RKManager
    
    let monthOffset: Int
    
    @State var weekOffset: Int?
    
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
    
    
    public var body: some View {
        Group {
            if rkManager.isWeeklyView {
                if weekOffset == nil {
                    weeklyViewContinuous
                } else {
                    weeklyViewPage
                }
            } else {
                monthlyView
            }
        }
        .popover(isPresented: $showTime, arrowEdge: .top) {
            RKTimeView(date: $timeDate, hasTime: $hasTime).environmentObject(rkManager)
        }
    }

    public var monthlyView: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(monthsArray, id: \.self) { row in
                HStack() {
                    ForEach(row, id: \.self) { column in
                        HStack() {
                            Spacer()
                            if isThisMonth(date: column) {
                                RKCell(rkDate: RKDate(date: column, rkManager: rkManager),
                                       cellWidth: cellWidth, hasTime: $hasTime)
                                    .contentShape(Rectangle())
                                    .onTapGesture { dateTapped(date: column) }
                                    .onLongPressGesture { showTime = isLongEnabled(date: column) }
                            } else {
                                Text("").frame(width: cellWidth, height: cellWidth)
                            }
                            Spacer()
                        }
                    }
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
        }.background(rkManager.colors.monthBackColor)
    }

    public var weeklyViewPage: some View {
        HStack(spacing: 10) {
            ForEach(monthsArray[weekOffset!], id: \.self) { column in
                HStack {
                    Spacer()
                    if isThisMonth(date: column) {
                        RKCell(rkDate: RKDate(date: column, rkManager: rkManager),
                               cellWidth: cellWidth, hasTime: $hasTime)
                            .contentShape(Rectangle())
                            .onTapGesture { dateTapped(date: column) }
                            .onLongPressGesture { showTime = isLongEnabled(date: column) }
                    } else {
                        Text("").frame(width: cellWidth, height: cellWidth)
                    }
                    Spacer()
                }
            }.frame(minWidth: 0, maxWidth: .infinity)
        }.background(rkManager.colors.monthBackColor)
    }
    
    public var weeklyViewContinuous: some View {
        HStack {
            ForEach(monthArray2(), id: \.self) { row in   // 7 days
                ForEach(row, id: \.self) { column in      // each day
                    RKCell(rkDate: RKDate(date: column, rkManager: rkManager),
                           cellWidth: cellWidth, hasTime: $hasTime)
                        .contentShape(Rectangle())
                        .onTapGesture { dateTapped(date: column) }
                        .onLongPressGesture { showTime = isLongEnabled(date: column) }
                }
            }.background(rkManager.colors.monthBackColor)
        }
    }
    
    public func isLongEnabled(date: Date) -> Bool {
        if rkManager.disabled {return false}
        if rkManager.isEnabled(date: date) {
            timeDate = rkManager.calendar.startOfDay(for: date)
        }
        return rkManager.isEnabled(date: date) && rkManager.displayTime
    }
    
    public func isThisMonth(date: Date) -> Bool {
        return rkManager.calendar.isDate(date, equalTo: firstOfMonthForOffset(), toGranularity: .month)
    }
    
    public func dateTapped(date: Date) {
        if rkManager.disabled {return}
        if rkManager.isEnabled(date: date) {
            switch rkManager.mode {
            case .singleDate:
                if rkManager.selectedDate != nil &&
                    rkManager.calendar.isDate(rkManager.selectedDate, inSameDayAs: date) {
                    rkManager.selectedDate = nil
                } else {
                    rkManager.selectedDate = date
                }
            case .dateRange:
                if rkManager.startDate != nil &&
                    rkManager.calendar.isDate(rkManager.startDate, inSameDayAs: date) {
                    rkManager.startDate = nil
                } else {
                    rkManager.startDate = date
                    rkManager.endDate = nil
                    rkManager.mode = .dateRange2
                }
            case .dateRange2:
                if rkManager.endDate != nil &&
                    rkManager.calendar.isDate(rkManager.endDate, inSameDayAs: date) {
                    rkManager.endDate = nil
                } else {
                    rkManager.endDate = date
                    if rkManager.isStartDateAfterEndDate() {
                        rkManager.endDate = nil
                        rkManager.startDate = nil
                    }
                }
                rkManager.mode = .dateRange
            case .multiDate:
                if rkManager.selectedDatesContains(date: date) {
                    if let ndx = rkManager.selectedDatesFindIndex(date: date) {
                        rkManager.selectedDates.remove(at: ndx)
                    }
                } else {
                    rkManager.selectedDates.append(date)
                }
            }
        }
    }
    
    public func monthArray() -> [[Date]] {
        var rowArray = [[Date]]()
        for row in 0 ..< (numberOfDays(offset: monthOffset) / 7) {
            var columnArray = [Date]()
            for column in 0 ... 6 {
                let abc = getDateAtIndex(index: (row * 7) + column)
                columnArray.append(abc)
            }
            rowArray.append(columnArray)
        }
        return rowArray
    }
    
    public func monthArray2() -> [[Date]] {
        var rowArray = [[Date]]()
        for row in 0 ..< (numberOfDays(offset: monthOffset) / 7) - 1 {
            var columnArray = [Date]()
            for column in 0 ... 6 {
                let abc = getDateAtIndex(index: (row * 7) + column)
                columnArray.append(abc)
            }
            rowArray.append(columnArray)
        }
        return rowArray
    }
    
    public func getDateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstOfMonthForOffset()
        let weekday = rkManager.calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - rkManager.calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0 : 7
        var dateComponents = DateComponents()
        dateComponents.day = index - startOffset
        
        return rkManager.calendar.date(byAdding: dateComponents, to: firstOfMonth)!
    }
    
    public func numberOfDays(offset : Int) -> Int {
        let firstOfMonth = firstOfMonthForOffset()
        let rangeOfWeeks = rkManager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)
        
        return (rangeOfWeeks?.count)! * 7
    }
    
    public func firstOfMonthForOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset
        
        return rkManager.calendar.date(byAdding: offset, to: rkManager.RKFirstDateMonth())!
    }
    
}

#if DEBUG
struct RKMonth_Previews : PreviewProvider {
    static var previews: some View {
        RKMonth(monthOffset: 0, weekOffset: -1)
    }
}
#endif

