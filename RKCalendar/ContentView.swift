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
    
    var rkManager1 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var rkManager2 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 1) // automatically goes to mode=2 after start selection, and vice versa.
    
    var rkManager3 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 3)
    
    var rkManager4 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 1)

    
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
                    Text("Example 3 - Multiple Dates Selection").foregroundColor(.blue)
                }
                Divider()
                NavigationLink(destination: RKViewController(isPresented: self.$multipleIsPresented, rkManager: rkManager4)) {
                    Text("Example 4 - Disabled Dates Setting").foregroundColor(.blue)
                }
            }
        }.onAppear(perform: startUp)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func startUp() {
        let testOnDates = [Date().addingTimeInterval(60*60*24), Date().addingTimeInterval(60*60*24*2)]
        self.rkManager3.selectedDates.append(contentsOf: testOnDates)
        
        let testOffDates = [
            Date().addingTimeInterval(60*60*24*4),
            Date().addingTimeInterval(60*60*24*5),
            Date().addingTimeInterval(60*60*24*7)]
        self.rkManager4.disabledDates.append(contentsOf: testOffDates)
    }
 
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
