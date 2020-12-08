//
//  RKCalendarView.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

public struct RKCalendarView: View {
    
    @Environment(\.presentationMode) public var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject public var rkManager: RKManager
    
    @State public var pages = [RKWeeklyPage]()
    @State public var index: Int = 0
    
    @State var scrollIndex: Int = 1
    
    public init(pages: [RKWeeklyPage] = [], index: Int = 0) {
        self.pages = pages
        self.index = index
    }
    
    public var body: some View {
        Group {
            #if !os(iOS)
                Button(action: onDone) {
                    HStack {
                        Text("Done")
                        Spacer()
                    }.padding(15)
                }
            #endif
            rkManager.isWeeklyView ? AnyView(weeklyBody) : AnyView(monthlyBody)
        }
    }
    
    public var monthlyBody: some View {
        Group {
            rkManager.isVertical
                ? rkManager.isContinuous ? AnyView(verticalView) : AnyView(pageScrollView)
                : rkManager.isContinuous ? AnyView(horizontalView) : AnyView(pageScrollView)
            Spacer()
        }
    }
    
    public var weeklyBody: some View {
        Group {
            rkManager.isContinuous
                ? AnyView(weeklyContinuousView)
                : AnyView(RKPageView(pages: pages))
        }.onAppear(perform: loadWeeklyData)
    }
    
    public func loadWeeklyData() {
        for i in 0..<numberOfMonths() {
            for j in 0..<numberOfWeeks(monthOffset: i) {
                pages.append(RKWeeklyPage(monthNdx: i, weekNdx: j))
            }
        }
    }
    
    // weekly continuous
    public var weeklyContinuousView: some View {
        ScrollViewReader { scrollProxy in
            ScrollView (.horizontal) {
                HStack (spacing: 15) {
                    ForEach(0..<numberOfMonths(), id: \.self) { index in
                        VStack (spacing: 15) {
                            Divider()
                            HStack (spacing: 1) {
                                ForEach(0..<numberOfWeeks(monthOffset: index), id: \.self) { _ in
                                    VStack (spacing: 15) {
                                        RKWeekdayHeader()
                                        RKMonthHeader(monthOffset: index)
                                    }
                                }
                            }
                            RKMonth(monthOffset: index)
                            Spacer()
                        } 
                    }
                }
            }.onChange(of: scrollIndex) { id in
                withAnimation {
                    scrollProxy.scrollTo(id)
                }
            }
        }.onAppear(perform: { scrollIndex = (todayScrollIndex() - 1) })
    }
    
    // vertical continuous scroll
    public var verticalView: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack (spacing: 25) {
                    ForEach(0..<numberOfMonths(), id: \.self) { index in
                        VStack(alignment: HorizontalAlignment.center, spacing: 15){
                            RKMonthHeader(monthOffset: index)
                            RKWeekdayHeader()
                            // Divider()
                            RKMonth(monthOffset: index)
                        }
                        Divider()
                    }
                }
            }.onChange(of: scrollIndex) { id in
                withAnimation {
                    scrollProxy.scrollTo(id)
                }
            }
        }.onAppear(perform: { scrollIndex = todayScrollIndex() })
    }
    
    // horizontal continuous scroll
    public var horizontalView: some View {
        ScrollViewReader { scrollProxy in
            ScrollView (.horizontal) {
                HStack {
                    ForEach(0..<numberOfMonths(), id: \.self) { index in
                        VStack (spacing: 15) {
                            RKMonthHeader(monthOffset: index)
                            RKWeekdayHeader()
                            Divider()
                            RKMonth(monthOffset: index)
                            Spacer()
                        }
                        Divider()
                    }
                }
            }.onChange(of: scrollIndex) { id in
                withAnimation {
                    scrollProxy.scrollTo(id)
                }
            }
        }.onAppear(perform: { scrollIndex = todayScrollIndex() })
    }
    
    // a vertical or horizontal page scroll 
    public var pageScrollView: some View {
        RKPageView(pages: (0..<numberOfMonths()).map { index in
            RKPage(index: index)
        })
    }
    
    public func onDone() {
        // to go back to the previous view
        presentationMode.wrappedValue.dismiss()
    }
    
    public func numberOfWeeks(monthOffset: Int) -> Int {
        let firstOfMonth = firstOfMonthForOffset(monthOffset: monthOffset)
        let rangeOfWeeks = rkManager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)
        let nw = (rangeOfWeeks?.count)! - 1
        return nw
    }
    
    public func firstOfMonthForOffset(monthOffset : Int) -> Date {
        var offset = DateComponents()
        offset.month = monthOffset
        return rkManager.calendar.date(byAdding: offset, to: rkManager.RKFirstDateMonth())!
    }
    
    public func numberOfMonths() -> Int {
        return rkManager.calendar.dateComponents([.month], from: rkManager.minimumDate, to: RKMaximumDateMonthLastDay()).month! + 1
    }
    
    public func RKMaximumDateMonthLastDay() -> Date {
        var components = rkManager.calendar.dateComponents([.year, .month, .day], from: rkManager.maximumDate)
        components.month! += 1
        components.day = 0
        return rkManager.calendar.date(from: components)!
    }
    
    public func todayScrollIndex() -> Int {
        let date: Date = Date() // rkManager.selectedDate != nil ? rkManager.selectedDate : Date()
        if rkManager.isBetweenMinAndMaxDates(date: date) {
            let nMonths = 2 + rkManager.calendar.dateComponents([.month], from: rkManager.minimumDate, to: Date()).month!
            return nMonths
        } else {
            return 0
        }
    }
    
}

#if DEBUG
struct RKViewController_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            RKCalendarView()
            RKCalendarView()
                .environment(\.colorScheme, .dark)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
#endif
