//
//  RKWeeklyViewController.swift
//  RKCalendar
//
//  Created by Ringo Wathelet on 2020/01/08.
//  Copyright © 2020 Raffi Kian. All rights reserved.
//


import SwiftUI

struct RKWeeklyViewController: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var isPresented: Bool
    
    @ObservedObject var rkManager: RKManager
    
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    
    var body: some View {
        Group {
            // needed for Mac
            Button(action: self.onDone) {
                HStack {
                    Text("Done")
                    Spacer()
                }.padding(15)
            }
            ScrollView (.horizontal) {
                HStack {
                    ForEach(0..<self.numberOfMonths()) { index in
                        VStack (spacing: 15) {
                            Divider()
                            HStack {
                                ForEach(0..<self.numberOfWeeks(monthOffset: index)) { _ in
                                    VStack (spacing: 15) {
                                        RKWeekdayHeader(rkManager: self.rkManager)
                                        RKMonthHeader(rkManager: self.rkManager, monthOffset: index)
                                    }
                                }
                            }
                            RKMonth(isPresented: self.$isPresented, rkManager: self.rkManager, monthOffset: index)
                            Spacer()
                        }
                        Divider()
                    }
                }
            }
        }
    }
    
    func onDone() {
        // to go back to the previous view
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func numberOfMonths() -> Int {
        return rkManager.calendar.dateComponents([.month], from: rkManager.minimumDate, to: RKMaximumDateMonthLastDay()).month! 
    }
    
    func numberOfWeeks(monthOffset: Int) -> Int {
        let firstOfMonth = firstOfMonthForOffset(monthOffset: monthOffset)
        let rangeOfWeeks = rkManager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)
        
        return (rangeOfWeeks?.count)!
    }
    
    func firstOfMonthForOffset(monthOffset : Int) -> Date {
        var offset = DateComponents()
        offset.month = monthOffset
        
        return rkManager.calendar.date(byAdding: offset, to: RKFirstDateMonth())!
    }
    
    func RKFirstDateMonth() -> Date {
        var components = rkManager.calendar.dateComponents(calendarUnitYMD, from: rkManager.minimumDate)
        components.day = 1
        
        return rkManager.calendar.date(from: components)!
    }
    
    func RKMaximumDateMonthLastDay() -> Date {
        var components = rkManager.calendar.dateComponents([.year, .month, .day], from: rkManager.maximumDate)
        components.month! += 1
        components.day = 0
        
        return rkManager.calendar.date(from: components)!
    }
}

#if DEBUG
struct RKWeeklyViewController_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            RKWeeklyViewController(isPresented: .constant(false), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0))
            RKWeeklyViewController(isPresented: .constant(false), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*32), mode: 0))
                .environment(\.colorScheme, .dark)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
#endif

