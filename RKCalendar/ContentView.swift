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
    
    var body: some View {
        
        VStack (spacing: 15){
            Text("Example 1 - Single Date Selection")
            PresentationLink(destination: RKViewController(rkManager : self.exampleOne, mode: 0), label:{
                Text(getTextFromDate(date: self.exampleOne.selectedDate, mode: 0))
            }
            )
            
            Divider()

            Text("Example 2 - Start and End Date Selection")
            PresentationLink(destination: RKViewController(rkManager : self.exampleTwo, mode: 1), label:{
                Text(getTextFromDate(date: self.exampleTwo.startDate, mode: 1))
            }
            )
            PresentationLink(destination: RKViewController(rkManager : self.exampleTwo, mode: 2), label:{
                Text(getTextFromDate(date: self.exampleTwo.endDate, mode: 2))
            }
            )
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
