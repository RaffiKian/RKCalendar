//
//  ContentView.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//


import SwiftUI

struct ContentView : View {
    
    @State var isPresented1 = false
    @State var isPresented2 = false
    @State var isPresented3 = false
    @State var isPresented4 = false
    @State var isPresented5 = false
    @State var isPresented6 = false
    @State var isPresented7 = false
    
    var rkManager1 = RKManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-60*60*24*60), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var rkManager2 = RKManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-60*60*24*60), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 1) // automatically goes to mode=2 after start selection, and vice versa.
    
    var rkManager3 = RKManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-60*60*24*60), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 3)
    
    var rkManager4 = RKManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-60*60*24*60), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var rkManager5 = RKManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-60*60*24*60), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var rkManager6 = RKManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-60*60*24*60), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var rkManager7 = RKManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-60*60*24*60), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var body: some View {
        VStack (spacing: 10) {
            Group {
                Button(action: { isPresented1.toggle() }) {
                    Text("Example 1 - Single Date Selection").foregroundColor(.blue)
                }
                .sheet(isPresented: $isPresented1, content: {
                        RKViewController().environmentObject(rkManager1)})
                Text(ContentView.getTextFromDate(rkManager1.selectedDate))
                
                Button(action: { isPresented2.toggle() }) {
                    VStack {
                        Text("Example 2 - Range of Dates Selection").foregroundColor(.blue)
                        Text("(end date > start date)").foregroundColor(.blue)
                    }
                }
                .sheet(isPresented: $isPresented2, content: {
                        RKViewController().environmentObject(rkManager2)})
                VStack {
                    Text(ContentView.getTextFromDate(rkManager2.startDate))
                    Text(ContentView.getTextFromDate(rkManager2.endDate))
                }
                
                Button(action: { isPresented3.toggle() }) {
                    Text("Example 3 - Multiple Dates Selection ").foregroundColor(.blue)
                }
                .sheet(isPresented: $isPresented3, content: {
                        RKViewController().environmentObject(rkManager3)})
                datesView(dates: rkManager3.selectedDates)
            }
            Group {
                Button(action: { isPresented4.toggle() }) {
                    Text("Example 4 - Disabled Dates Setting").foregroundColor(.blue)
                }
                .sheet(isPresented: $isPresented4, content: {
                        RKViewController().environmentObject(rkManager4)})
                datesView(dates: rkManager4.disabledDates)
                
                Button(action: { isPresented5.toggle() }) {
                    Text("Example 5 - Time setting on long press").foregroundColor(.blue)
                }
                .sheet(isPresented: $isPresented5, content: {
                        RKViewController().environmentObject(rkManager5)})
                // mode 0
                Text(ContentView.getTextFromDateTime(rkManager5.selectedDate))
                // mode 3
                // datesView(dates: rkManager5.selectedDates, true)
                // mode 1
                // VStack {
                //     Text(RKManager.getTextFromDateTime(rkManager5.startDate))
                //      Text(RKManager.getTextFromDateTime(rkManager5.endDate))
                // }
                
                Button(action: { isPresented6.toggle() }) {
                    Text("Example 6 - Weekly view").foregroundColor(.blue)
                }
                .sheet(isPresented: $isPresented6, content: {
                        RKViewController().environmentObject(rkManager6)})
                Text(ContentView.getTextFromDate(rkManager6.selectedDate))
                
                Button(action: { isPresented7.toggle() }) {
                    Text("Example 7 - Horizontal view with paging").foregroundColor(.blue)
                }
                .sheet(isPresented: $isPresented7, content: {
                        RKViewController().environmentObject(rkManager7)})
                Text(ContentView.getTextFromDate(rkManager7.selectedDate))
            }
        }.onAppear(perform: startUp)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func datesView(dates: [Date], _ withTime: Bool = false) -> some View {
        ScrollView (.horizontal) {
            HStack {
                ForEach(dates, id: \.self) { date in
                    withTime ? Text(ContentView.getTextFromDateTime(date)) : Text(ContentView.getTextFromDate(date))
                }
            }
        }.padding(.horizontal, 5)
    }
    
    func startUp() {
        
        // example of horizontal view
        //        rkManager1.isVertical = false
        
        // example of pre-setting selected dates
        let testOnDates = [Date().addingTimeInterval(60*60*24), Date().addingTimeInterval(60*60*24*2)]
        rkManager3.selectedDates.append(contentsOf: testOnDates)
        
        // example of some foreground colors
        rkManager3.colors.weekdayHeaderColor = Color.blue
        rkManager3.colors.monthHeaderColor = Color.green
        rkManager3.colors.textColor = Color.blue
        rkManager3.colors.disabledColor = Color.red
        
        // example of pre-setting disabled dates
        let testOffDates = [
            Date().addingTimeInterval(60*60*24*4),
            Date().addingTimeInterval(60*60*24*5),
            Date().addingTimeInterval(60*60*24*7)]
        rkManager4.disabledDates.append(contentsOf: testOffDates)
        
        // example of allowing time (hh:mm) to be set and displayed on a long press
        // example to display in Japanese
        rkManager5.locale = Locale(identifier: "ja")
        rkManager5.displayTime = true
        
        // example of weekly view with "paging"
        rkManager6.isVertical = false
        rkManager6.isWeeklyView = true
        rkManager6.isContinuous = false
        rkManager6.colors.weekdayHeaderColor = Color.blue
        rkManager6.colors.monthHeaderColor = Color.green
        
        // example of horizontal view with "paging"
        rkManager7.isVertical = false
        rkManager7.isContinuous = false
        rkManager7.colors.weekdayHeaderColor = Color.blue
        rkManager7.colors.monthHeaderColor = Color.green
    }
    
    static func getDateTimeAsString(_ date: Date?) -> String {
        if date == nil { return "" }
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-HH-mm"
        format.timeZone = TimeZone.current
        format.locale = Locale.current
        return format.string(from: date!)
    }
    
    static func getTextFromDate(_ date: Date?) -> String {
        if date == nil { return "" }
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return date == nil ? "" : formatter.string(from: date!)
    }
    
    static func getTextFromDateTime(_ date: Date?) -> String {
        if date == nil { return "" }
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE, MMMM d HH:mm, yyyy"
        return date == nil ? "" : formatter.string(from: date!)
    }
    
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
