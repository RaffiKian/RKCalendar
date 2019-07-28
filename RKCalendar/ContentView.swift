//
//  ContentView.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    
    @ObjectBinding var exampleOne : RKManager
    @ObjectBinding var exampleTwo : RKManager
    
    @State var singleDateSelectionIsPresented = false
    @State var startDateSelectionIsPresented = false
    @State var endDateSelectionIsPresented = false
    
    var body: some View {
        
        VStack (spacing: 15){
            Text("Example 1 - Single Date Selection")
            Button(action: { self.singleDateSelectionIsPresented.toggle() }) {
                Text(getTextFromDate(date: self.exampleOne.selectedDate, mode: 0))
            }
            .sheet(isPresented: $singleDateSelectionIsPresented, content: {
                RKViewController(viewIsPresented: self.$singleDateSelectionIsPresented, rkManager : self.exampleOne, mode: 0)
            })
            
            Divider()

            Text("Example 2 - Start and End Date Selection")
            Button(action: { self.startDateSelectionIsPresented.toggle() }) {
                Text(getTextFromDate(date: self.exampleTwo.startDate, mode: 1))
            }
            .sheet(isPresented: $startDateSelectionIsPresented, content: {
                RKViewController(viewIsPresented: self.$startDateSelectionIsPresented, rkManager : self.exampleTwo, mode: 1)
            })
            
            Button(action: { self.endDateSelectionIsPresented.toggle() }) {
                Text(getTextFromDate(date: self.exampleTwo.endDate, mode: 2))
            }
            .sheet(isPresented: $endDateSelectionIsPresented, content: {
                RKViewController(viewIsPresented: self.$endDateSelectionIsPresented, rkManager : self.exampleTwo, mode: 2)
            })
        }
    }
    
    func getTextFromDate(date: Date!, mode: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        var text = "Select Date"
        if mode == 1 {
            text = "Select Start Date"
        }else if mode == 2{
            text = "Select End Date"
        }
        
        if date != nil {
            text = formatter.string(from: date)
        }
        return text
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(exampleOne: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365)), exampleTwo:RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365)))
    }
}
#endif
