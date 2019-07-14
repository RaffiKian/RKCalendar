//
//  RKWeekdayHeader.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

struct RKWeekdayHeader : View {
    
    let calendar : Calendar
    
    var body: some View {
        
        HStack(alignment: .center){
            ForEach(self.getWeekdayHeaders(calendar: self.calendar).identified(by: \.self)) { weekday in
                Text(weekday)
                    .font(.system(size: 20))
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }
    
    func getWeekdayHeaders(calendar: Calendar) -> [String] {
        
        let formatter = DateFormatter()
        
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
        RKWeekdayHeader(calendar: Calendar.current)
    }
}
#endif
