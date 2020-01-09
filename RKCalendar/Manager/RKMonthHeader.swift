//
//  RKMonthHeader.swift
//  RKCalendar
//
//  Created by Ringo Wathelet on 2020/01/08.
//  Copyright © 2020 Raffi Kian. All rights reserved.
//

import Foundation
import SwiftUI


struct RKMonthHeader : View {
    
    var rkManager: RKManager
    
    let monthOffset: Int
    
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    
    var body: some View {
        Text(getMonthHeader()).foregroundColor(self.rkManager.colors.monthHeaderColor)
    }
    
    func getMonthHeader() -> String {
        let headerDateFormatter = DateFormatter()
        headerDateFormatter.calendar = rkManager.calendar
        headerDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy LLLL", options: 0, locale: rkManager.calendar.locale)
        
        return headerDateFormatter.string(from: firstOfMonthForOffset()).uppercased()
    }
    
    func firstOfMonthForOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset
        
        return rkManager.calendar.date(byAdding: offset, to: RKFirstDateMonth())!
    }
    
    func RKFirstDateMonth() -> Date {
        var components = rkManager.calendar.dateComponents(calendarUnitYMD, from: rkManager.minimumDate)
        components.day = 1
        
        return rkManager.calendar.date(from: components)!
    }
    
}
