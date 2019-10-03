//
//  RKMonth.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

struct RKMonth : View {
    
    @Binding var viewIsPresented: Bool
    
    @ObservedObject var rkManager : RKManager
    var mode : Int
    let monthOffset : Int
    
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    let daysPerWeek = 7
    var monthsArray: [[Date]] {
        monthArray()
    }
    
    var body: some View {
        
        VStack(alignment: HorizontalAlignment.center, spacing: 10){
            
            Text(getMonthHeader())
            
            VStack(alignment: .leading, spacing: 5) {
                ForEach(monthsArray, id:  \.self) { row in
                    HStack() {
                        ForEach(row, id:  \.self) { column in
                            HStack() {
                                Spacer()
                                if self.isThisMonth(date: column){
                                    RKCell(rkDate: RKDate(
                                        date: column,
                                        calendar: self.rkManager.calendar,
                                        isDisabled: !self.isEnabled(date: column),
                                        isToday: self.isToday(date: column),
                                        isSelected: self.isSpecialDate(date: column),
                                        isBetweenStartAndEnd: self.isBetweenStartAndEnd(date: column)))
                                        .onTapGesture {
                                            self.dateTapped(date: column)
                                    }
                                }else{
                                    Text("")
                                        .frame(width: 32, height: 32)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
    
    func dateTapped(date: Date) {
        if self.isEnabled(date: date){
            if self.mode == 0{
                self.rkManager.selectedDate = date
            }else if self.mode == 1{
                self.rkManager.startDate = date
                if self.isStartDateAfterEndDate(){
                    self.rkManager.endDate = date
                }
            }else if self.mode == 2{
                self.rkManager.endDate = date
                if self.isStartDateAfterEndDate(){
                    self.rkManager.startDate = date
                }
            }
            self.viewIsPresented = false
        }
    }
    
    func isThisMonth(date: Date) -> Bool {
        
        return self.rkManager.calendar.isDate(date, equalTo: firstOfMonthForOffset(), toGranularity: .month)
    }
    
    func monthArray() -> [[Date]]{
        
        var rowArray = [[Date]]()
        
        for row in 0 ..< (numberOfDays(offset: monthOffset) / 7){
            var columnArray = [Date]()
            for column in 0 ... 6{
                let abc = self.getaDateAtIndex(index: (row * 7) + column)
                columnArray.append(abc)
            }
            rowArray.append(columnArray)
        }
        
        return rowArray
    }
    
    func getMonthHeader() -> String{
        let headerDateFormatter = DateFormatter()
        headerDateFormatter.calendar = rkManager.calendar
        headerDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy LLLL", options: 0, locale: rkManager.calendar.locale)
        
        return headerDateFormatter.string(from: firstOfMonthForOffset()).uppercased()
    }
    
    func getaDateAtIndex(index: Int) -> Date{
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
        return isSelectedDate(date: date) || isStartDate(date: date) || isEndDate(date: date)
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
        }else if rkManager.endDate == nil {
            return false
        }else if rkManager.calendar.compare(date, to: rkManager.startDate, toGranularity: .day) == .orderedAscending {
            return false
        }else if rkManager.calendar.compare(date, to: rkManager.endDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        
        return true
    }
    
    func isEnabled(date: Date) -> Bool {
        
        let clampedDate = RKFormatDate(date: date)
        
        if rkManager.calendar.compare(clampedDate, to: rkManager.minimumDate, toGranularity: .day) == .orderedAscending || rkManager.calendar.compare(clampedDate, to: rkManager.maximumDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        
        return true
    }
    
    func isStartDateAfterEndDate() -> Bool {
        if rkManager.startDate == nil {
            return false
        }else if rkManager.endDate == nil {
            return false
        }else if rkManager.calendar.compare(rkManager.endDate, to: rkManager.startDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        
        return true
    }
}

#if DEBUG
struct RKMonth_Previews : PreviewProvider {
    static var previews: some View {
        RKMonth(viewIsPresented: .constant(false),rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365)), mode: 0, monthOffset: 0)
    }
}
#endif
