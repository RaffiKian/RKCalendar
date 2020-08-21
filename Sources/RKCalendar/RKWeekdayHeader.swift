//
//  RKWeekdayHeader.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

public struct RKWeekdayHeader : View {
    
    @EnvironmentObject public var rkManager: RKManager
    
    public var body: some View {
        HStack(alignment: .center) {
            ForEach(getWeekdayHeaders(calendar: rkManager.calendar), id: \.self) { weekday in
                Text(weekday)
                    .font(rkManager.weeklyHeaderFont)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(rkManager.colors.weekdayHeaderColor)
            }
        }.background(rkManager.colors.weekdayHeaderBackColor)
        .padding(.horizontal, 12)
    }
    
    public func getWeekdayHeaders(calendar: Calendar) -> [String] {
        
        let formatter = DateFormatter()
        formatter.locale = rkManager.locale

        var weekdaySymbols = formatter.shortStandaloneWeekdaySymbols
        let weekdaySymbolsCount = weekdaySymbols?.count ?? 0
        
        for _ in 0 ..< (1 - calendar.firstWeekday + weekdaySymbolsCount){
            let lastObject = weekdaySymbols?.last
            weekdaySymbols?.removeLast()
            weekdaySymbols?.insert(lastObject!, at: 0)
        }
        
        return weekdaySymbols ?? []
    }
}

#if DEBUG
struct RKWeekdayHeader_Previews : PreviewProvider {
    static var previews: some View {
        RKWeekdayHeader()
    }
}
#endif

