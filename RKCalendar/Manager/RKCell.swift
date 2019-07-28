//
//  RKCell.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

struct RKCell : View {
    
    var rkDate : RKDate
    
    var body: some View {
        Text(rkDate.getText())
            .fontWeight(rkDate.getFontWight())
            .foregroundColor(rkDate.getTextColor())
            .frame(width: 32, height: 32)
            .font(.system(size: 20))
            .background(rkDate.getBackgroundColor())
            .cornerRadius(8)
    }
}

#if DEBUG
struct RKCell_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            RKCell(rkDate: RKDate(date: Date(), calendar: Calendar.current, isDisabled: false, isToday: false, isSelected: false, isBetweenStartAndEnd: false))
                .previewDisplayName("Control")
            RKCell(rkDate: RKDate(date: Date(), calendar: Calendar.current, isDisabled: true, isToday: false, isSelected: false, isBetweenStartAndEnd: false))
                .previewDisplayName("Disabled Date")
            RKCell(rkDate: RKDate(date: Date(), calendar: Calendar.current, isDisabled: false, isToday: true, isSelected: false, isBetweenStartAndEnd: false))
                .previewDisplayName("Today")
            RKCell(rkDate: RKDate(date: Date(), calendar: Calendar.current, isDisabled: false, isToday: false, isSelected: true, isBetweenStartAndEnd: false))
                .previewDisplayName("Selected Date")
            RKCell(rkDate: RKDate(date: Date(), calendar: Calendar.current, isDisabled: false, isToday: false, isSelected: false, isBetweenStartAndEnd: true))
                .previewDisplayName("Between Two Dates")
        }
        .previewLayout(.fixed(width: 300, height: 70))
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
