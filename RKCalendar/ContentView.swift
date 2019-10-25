//
//  ContentView.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//


import SwiftUI

struct ContentView : View {
    
    @State var singleIsPresented = false
    @State var startIsPresented = false
    @State var multipleIsPresented = false
    @State var deselectedIsPresented = false
    @State var timeIsPresented = false
    
    var rkManager1 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var rkManager2 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 1) // automatically goes to mode=2 after start selection, and vice versa.
    
    var rkManager3 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 3)
    
    var rkManager4 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var rkManager5 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    
    
    var body: some View {
        VStack (spacing: 25) {
            
            Button(action: { self.singleIsPresented.toggle() }) {
                Text("Example 1 - Single Date Selection").foregroundColor(.blue)
            }
            .sheet(isPresented: self.$singleIsPresented, content: {
                RKViewController(isPresented: self.$singleIsPresented, rkManager: self.rkManager1)})
            Text(RKManager.getTextFromDate(self.rkManager1.selectedDate))
            
            Button(action: { self.startIsPresented.toggle() }) {
                VStack {
                    Text("Example 2 - Range of Dates Selection").foregroundColor(.blue)
                    Text("(end date > start date)").foregroundColor(.blue)
                }
            }
            .sheet(isPresented: self.$startIsPresented, content: {
                RKViewController(isPresented: self.$startIsPresented, rkManager: self.rkManager2)})
            VStack {
                Text(RKManager.getTextFromDate(self.rkManager2.startDate))
                Text(RKManager.getTextFromDate(self.rkManager2.endDate))
            }
            
            Button(action: { self.multipleIsPresented.toggle() }) {
                Text("Example 3 - Multiple Dates Selection ").foregroundColor(.blue)
            }
            .sheet(isPresented: self.$multipleIsPresented, content: {
                RKViewController(isPresented: self.$multipleIsPresented, rkManager: self.rkManager3)})
            datesView(dates: self.rkManager3.selectedDates)
            
            Button(action: { self.deselectedIsPresented.toggle() }) {
                Text("Example 4 - Disabled Dates Setting").foregroundColor(.blue)
            }
            .sheet(isPresented: self.$deselectedIsPresented, content: {
                RKViewController(isPresented: self.$deselectedIsPresented, rkManager: self.rkManager4)})
            datesView(dates: self.rkManager4.disabledDates)
            
            Button(action: { self.timeIsPresented.toggle() }) {
                Text("Example 5 - Time setting on long press").foregroundColor(.blue)
            }
            .sheet(isPresented: self.$timeIsPresented, content: {
                RKViewController(isPresented: self.$timeIsPresented, rkManager: self.rkManager5)})
            // mode 0
            Text(RKManager.getTextFromDateTime(self.rkManager5.selectedDate))
            // mode 3
            // datesView(dates: self.rkManager5.selectedDates, true)
            // mode 1
            // VStack {
            //     Text(RKManager.getTextFromDateTime(self.rkManager5.startDate))
            //      Text(RKManager.getTextFromDateTime(self.rkManager5.endDate))
            // }
            
        }.onAppear(perform: startUp)
            .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func datesView(dates: [Date], _ withTime: Bool = false) -> some View {
        ScrollView (.horizontal) {
            HStack {
                ForEach(dates, id: \.self) { date in
                    withTime ? Text(RKManager.getTextFromDateTime(date)) : Text(RKManager.getTextFromDate(date))
                }
            }
        }.padding(.horizontal, 5)
    }
 
    func startUp() {
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
        rkManager5.displayTime = true
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
