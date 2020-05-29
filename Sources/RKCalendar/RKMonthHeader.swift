//
//  RKMonthHeader.swift
//  RKCalendar
//
//  Created by Ringo Wathelet on 2020/01/08.
//  Copyright © 2020 Raffi Kian. All rights reserved.
//

import Foundation
import SwiftUI


public struct RKMonthHeader : View {
    
    var rkManager: RKManager
    let monthOffset: Int
    
    public init(rkManager: RKManager, monthOffset: Int) {
        self.rkManager = rkManager
        self.monthOffset = monthOffset
    }

    public var body: some View {
        Text(getMonthHeader()).foregroundColor(self.rkManager.colors.monthHeaderColor)
    }
    
    public func getMonthHeader() -> String {
        let headerDateFormatter = DateFormatter()
        headerDateFormatter.locale = rkManager.locale
        headerDateFormatter.calendar = rkManager.calendar
        headerDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy LLLL", options: 0, locale: rkManager.locale)
        
        return headerDateFormatter.string(from: firstOfMonthForOffset()).uppercased()
    }
    
    public func firstOfMonthForOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset
        
        return rkManager.calendar.date(byAdding: offset, to: rkManager.RKFirstDateMonth())!
    }
    
}
