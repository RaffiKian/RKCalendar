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
    @State var horizontalIsPresented = false
    
    var rkManager1 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var rkManager2 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 1) // automatically goes to mode=2 after start selection, and vice versa.
    
    var rkManager3 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 3)
    
    var rkManager4 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var rkManager5 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)

    
    var body: some View {
        NavigationView {
            VStack (spacing: 15) {
                NavigationLink(destination: RKViewController(isPresented: self.$singleIsPresented, rkManager: rkManager1)) {
                    Text("Example 1 - Single Date Selection").foregroundColor(.blue)
                }
                Divider()
                NavigationLink(destination: RKViewController(isPresented: self.$startIsPresented, rkManager: rkManager2)) {
                    Text("Example 2 - Range of Dates Selection").foregroundColor(.blue)
                }
                Divider()
                NavigationLink(destination: RKViewController(isPresented: self.$multipleIsPresented, rkManager: rkManager3)) {
                    Text("Example 3 - Multiple Dates Selection ").foregroundColor(.blue)
                }
                Divider()
                NavigationLink(destination: RKViewController(isPresented: self.$deselectedIsPresented, rkManager: rkManager4)) {
                    Text("Example 4 - Disabled Dates Setting").foregroundColor(.blue)
                }
                Divider()
                NavigationLink(destination: RKViewController(isPresented: self.$horizontalIsPresented, rkManager: rkManager5)) {
                    Text("Example 5 - Horizontal Scrolling with colors").foregroundColor(.blue)
                }
            }
        }.onAppear(perform: startUp)
            .navigationViewStyle(StackNavigationViewStyle())

    }
    
    func startUp() {
        // example of presetting selected dates
        let testOnDates = [Date().addingTimeInterval(60*60*24), Date().addingTimeInterval(60*60*24*2)]
        rkManager3.selectedDates.append(contentsOf: testOnDates)
        // some foreground colors
        rkManager3.colors.weekdayHeaderColor = Color.blue
        rkManager3.colors.monthHeaderColor = Color.green
        rkManager3.colors.textColor = Color.blue
        rkManager3.colors.disabledColor = Color.red
        
        // example of presetting disabled dates
        let testOffDates = [
            Date().addingTimeInterval(60*60*24*4),
            Date().addingTimeInterval(60*60*24*5),
            Date().addingTimeInterval(60*60*24*7)]
        rkManager4.disabledDates.append(contentsOf: testOffDates)
        
        // exampe of a horizontal scrolling calendar
        rkManager5.isVertical = false
        // some background colors
        rkManager5.colors.weekdayHeaderBackColor = Color.blue
        rkManager5.colors.monthBackColor = Color.green
    }
 
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
