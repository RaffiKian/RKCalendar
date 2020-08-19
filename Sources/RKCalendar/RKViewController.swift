//
//  RKViewController.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

public struct RKViewController: View {
    
    @Environment(\.presentationMode) public var presentationMode: Binding<PresentationMode>
    
    @Binding public var isPresented: Bool
    @ObservedObject public var rkManager: RKManager
    
    @State public var pages = [RKWeeklyPage]()
    @State public var index: Int = 0
    
    @State var scrollIndex: Int = 1
    
    public init(isPresented: Binding<Bool>, rkManager: RKManager, pages: [RKWeeklyPage] = [], index: Int = 0) {
        self._isPresented = isPresented
        self.rkManager = rkManager
        self.pages = pages
        self.index = index
    }
    
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
                ? AnyView(weeklyContinuousView)
                : AnyView(RKPageView(rkManager: rkManager, pages: pages))
        }.onAppear(perform: loadWeeklyData)
    }
    
    public func loadWeeklyData() {
        for i in 0..<self.numberOfMonths() {
            for j in 0..<self.numberOfWeeks(monthOffset: i) {
                pages.append(RKWeeklyPage(isPresented: $isPresented, rkManager: rkManager, monthNdx: i, weekNdx: j))
            }
        }
    }
    
    // weekly continuous
    public var weeklyContinuousView: some View {
        ScrollViewReader { scrollProxy in
            ScrollView (.horizontal) {
                HStack (spacing: 15) {
                    ForEach(0..<self.numberOfMonths(), id: \.self) { index in
                        VStack (spacing: 15) {
                            Divider()
                            HStack (spacing: 1) {
                                ForEach(0..<self.numberOfWeeks(monthOffset: index), id: \.self) { _ in
                                    VStack (spacing: 15) {
                                        RKWeekdayHeader(rkManager: self.rkManager)
                                        RKMonthHeader(rkManager: self.rkManager, monthOffset: index)
                                    }
                                }
                            }
                            RKMonth(isPresented: self.$isPresented, rkManager: self.rkManager, monthOffset: index)
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
                    ForEach(0..<self.numberOfMonths(), id: \.self) { index in
                        VStack(alignment: HorizontalAlignment.center, spacing: 15){
                            RKMonthHeader(rkManager: self.rkManager, monthOffset: index)
                            RKWeekdayHeader(rkManager: self.rkManager)
                            // Divider()
                            RKMonth(isPresented: self.$isPresented, rkManager: self.rkManager, monthOffset: index)
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
                    ForEach(0..<self.numberOfMonths(), id: \.self) { index in
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
            }.onChange(of: scrollIndex) { id in
                withAnimation {
                    scrollProxy.scrollTo(id)
                }
            }
        }.onAppear(perform: { scrollIndex = todayScrollIndex() })
    }
    
    // vertical page scroll
    public var verticalViewPage: some View {
        RKPageView(rkManager: rkManager,
                   pages: (0..<numberOfMonths()).map { index in
                    RKPage(isPresented: $isPresented, rkManager: rkManager, index: index)
                   })
    }
    
    // horizontal page scroll
    public var horizontalViewPage: some View {
        RKPageView(rkManager: rkManager,
                   pages: (0..<numberOfMonths()).map { index in
                    RKPage(isPresented: $isPresented, rkManager: rkManager, index: index)
                   })
    }
    
    public func onDone() {
        // to go back to the previous view
        self.presentationMode.wrappedValue.dismiss()
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
        if self.rkManager.isBetweenMinAndMaxDates(date: date) {
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
            RKViewController(isPresented: .constant(false), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0))
            RKViewController(isPresented: .constant(false), rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*32), mode: 0))
                .environment(\.colorScheme, .dark)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
#endif
