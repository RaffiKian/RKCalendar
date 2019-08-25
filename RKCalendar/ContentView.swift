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
    @State var endIsPresented = false
    @State var multipleIsPresented = false
    
    var rkManager1 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365))
    
    var rkManager2 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365))
    
    var rkManager3 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365))
    
    var rkManager4 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365))

    
    var body: some View {
        NavigationView {
            VStack (spacing: 15) {
                NavigationLink(destination: RKViewController(isPresented: self.$singleIsPresented, rkManager: rkManager1, mode: 0)) {
                    Text("Example 1 - Single Date Selection").foregroundColor(.blue)
                }
                Divider()
                NavigationLink(destination: RKViewController(isPresented: self.$startIsPresented, rkManager: rkManager2, mode: 1)) {
                    Text("Example 2 - Start Date Selection").foregroundColor(.blue)
                }
                NavigationLink(destination: RKViewController(isPresented: self.$endIsPresented, rkManager: rkManager2, mode: 2)) {
                    Text("Example 2 - End Date Selection").foregroundColor(.blue)
                }
                Divider()
                NavigationLink(destination: RKViewController(isPresented: self.$multipleIsPresented, rkManager: rkManager3, mode: 3)) {
                    Text("Example 3 - Multiple Dates Selection").foregroundColor(.blue)
                }
                Divider()
                NavigationLink(destination: RKViewController(isPresented: self.$multipleIsPresented, rkManager: rkManager4, mode: 1)) {
                    Text("Example 4 - Disabled Dates Setting").foregroundColor(.blue)
                }
            }
        }.onAppear(perform: startUp)
    }
    
    func startUp() {
        self.rkManager1.selectedDate = nil
        self.rkManager2.selectedDate = nil
        self.rkManager3.selectedDate = nil
        self.rkManager4.selectedDate = nil
        
        self.rkManager2.startDate = nil
        self.rkManager2.endDate = nil
        
        let testOnDates = [Date().addingTimeInterval(60*60*24), Date().addingTimeInterval(60*60*24*2)]
        self.rkManager3.selectedDates.append(contentsOf: testOnDates)
        
        let testOfDates = [Date().addingTimeInterval(60*60*24*4), Date().addingTimeInterval(60*60*24*5)]
        self.rkManager4.disabledDates.append(contentsOf: testOfDates)
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
