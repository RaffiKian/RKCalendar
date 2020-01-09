//
//  RKViewController.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

struct RKViewController: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var isPresented: Bool
    
    @ObservedObject var rkManager: RKManager
    
    var body: some View {
        Group {
            // needed for Mac
            Button(action: onDone) {
                HStack {
                    Text("Done")
                    Spacer()
                }.padding(15)
            }
            self.rkManager.isVertical ? AnyView(self.verticalView) : AnyView(self.horizontalView)
            Spacer()
        }
    }
    
    var verticalView: some View {
        Group {
            ScrollView (.vertical) {
                VStack (spacing: 25) {
                    ForEach(0..<numberOfMonths()) { index in
                        VStack(alignment: HorizontalAlignment.center, spacing: 15){
                            RKMonthHeader(rkManager: self.rkManager, monthOffset: index)
                            RKWeekdayHeader(rkManager: self.rkManager)
      //                      Divider()
                            RKMonth(isPresented: self.$isPresented, rkManager: self.rkManager, monthOffset: index)
                        }
                        Divider()
                    }
                }
            }
        }
    }

    var horizontalView: some View {
        Group {
            ScrollView (.horizontal) {
                HStack {
                    ForEach(0..<self.numberOfMonths()) { index in
                        VStack (spacing: 15) {
                            RKMonthHeader(rkManager: self.rkManager, monthOffset: index)
                            RKWeekdayHeader(rkManager: self.rkManager)
                            Divider()
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
        return rkManager.calendar.dateComponents([.month], from: rkManager.minimumDate, to: RKMaximumDateMonthLastDay()).month! + 1
    }
    
    func RKMaximumDateMonthLastDay() -> Date {
        var components = rkManager.calendar.dateComponents([.year, .month, .day], from: rkManager.maximumDate)
        components.month! += 1
        components.day = 0
        
        return rkManager.calendar.date(from: components)!
    }
}

#if DEBUG
struct RKViewController_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            RKViewController(isPresented: .constant(false), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0))
            RKViewController(isPresented: .constant(false), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*32), mode: 0))
                .environment(\.colorScheme, .dark)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
#endif

