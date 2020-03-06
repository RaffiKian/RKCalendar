//
//  RKViewController.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

public struct RKViewController: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var isPresented: Bool
    @ObservedObject var rkManager: RKManager
    @State var pages = [RKWeeklyPage]()
    @State var index: Int = 0
    
    
    public var body: some View {
        Group {
            // needed for Mac
            Button(action: onDone) {
                HStack {
                    Text("Done")
                    Spacer()
                }.padding(15)
            }
            rkManager.isWeeklyView ? AnyView(weeklyBody) : AnyView(monthlyBody)
        }
    }
    
    public var monthlyBody: some View {
        Group {
            self.rkManager.isVertical
                ? self.rkManager.isContinuous ? AnyView(self.verticalView) : AnyView(self.verticalViewPage)
                : self.rkManager.isContinuous ? AnyView(self.horizontalView) : AnyView(self.horizontalViewPage)
            Spacer()
        }
    }
    
    public var weeklyBody: some View {
        Group {
            self.rkManager.isContinuous
                ? AnyView(continuousView)
                : AnyView(RKPageView(rkManager: rkManager, pages: pages))
        }.onAppear(perform: loadWeeklyData)
    }
    
    var continuousView: some View {
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
    
    func loadWeeklyData() {
        for i in 0..<self.numberOfMonths() {
            for j in 0..<self.numberOfWeeks(monthOffset: i) {
                pages.append(RKWeeklyPage(isPresented: $isPresented, rkManager: rkManager, monthNdx: i, weekNdx: j))
            }
        }
    }
    
    // vertical continuous scroll
    var verticalView: some View {
        Group {
            ScrollView(.vertical) {
                VStack (spacing: 25) {
                    ForEach(0..<self.numberOfMonths()) { index in
                        VStack(alignment: HorizontalAlignment.center, spacing: 15){
                            RKMonthHeader(rkManager: self.rkManager, monthOffset: index)
                            RKWeekdayHeader(rkManager: self.rkManager)
                            // Divider()
                            RKMonth(isPresented: self.$isPresented, rkManager: self.rkManager, monthOffset: index)
                        }
                        Divider()
                    }
                }
            }
        }
    }
    
    // horizontal continuous scroll
    var horizontalView: some View {
        Group {
            ScrollView(.horizontal) {
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
    
    // vertical page scroll
    var verticalViewPage: some View {
        RKPageView(rkManager: rkManager,
                   pages: (0..<numberOfMonths()).map {
                    index in RKPage(isPresented: $isPresented, rkManager: rkManager, index: index)
        })
    }
    
    // horizontal page scroll
    var horizontalViewPage: some View {
        RKPageView(rkManager: rkManager,
                   pages: (0..<numberOfMonths()).map {
                    index in RKPage(isPresented: $isPresented, rkManager: rkManager, index: index)
        })
    }
    
    func onDone() {
        // to go back to the previous view
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func numberOfWeeks(monthOffset: Int) -> Int {
        let firstOfMonth = firstOfMonthForOffset(monthOffset: monthOffset)
        let rangeOfWeeks = rkManager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)
        return (rangeOfWeeks?.count)!
    }
    
    func firstOfMonthForOffset(monthOffset : Int) -> Date {
        var offset = DateComponents()
        offset.month = monthOffset
        return rkManager.calendar.date(byAdding: offset, to: rkManager.RKFirstDateMonth())!
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


