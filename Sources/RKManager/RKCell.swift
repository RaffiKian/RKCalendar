//
//  RKCell.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

struct RKCell: View {
    
    var rkDate: RKDate
    var cellWidth: CGFloat
    
    // this is used only to refresh the view
    @Binding var hasTime: Bool
    

    var body: some View {
        VStack {
            Text(rkDate.getText())
                .fontWeight(rkDate.getFontWeight())
                .foregroundColor(rkDate.getTextColor())
                .frame(width: cellWidth, height: cellWidth)
                .font(.system(size: 22))
                .background(rkDate.getBackgroundColor())
                .cornerRadius(cellWidth/2)
            
            if rkDate.isSelected && rkDate.rkManager.displayTime {
                Text(rkDate.getTimeText()).font(.system(size: 12)).foregroundColor(rkDate.getBackgroundColor())
            } else {
                Text(".").font(.system(size: 12)).foregroundColor(.clear)
            }
        }
    }
    
}

#if DEBUG
struct RKCell_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            RKCell(rkDate: RKDate(date: Date(), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)), cellWidth: CGFloat(32), hasTime: .constant(false))
                .previewDisplayName("Control")

            RKCell(rkDate: RKDate(date: Date(), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)), cellWidth: CGFloat(32), hasTime: .constant(false))
                .previewDisplayName("Disabled Date")

            RKCell(rkDate: RKDate(date: Date(), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)), cellWidth: CGFloat(32), hasTime: .constant(false))
                .previewDisplayName("Today")

            RKCell(rkDate: RKDate(date: Date(), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)), cellWidth: CGFloat(32), hasTime: .constant(false))
                .previewDisplayName("Selected Date")

            RKCell(rkDate: RKDate(date: Date(), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)), cellWidth: CGFloat(32), hasTime: .constant(false))
                .previewDisplayName("Between Two Dates")
        }
        .previewLayout(.fixed(width: 300, height: 70))
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif


