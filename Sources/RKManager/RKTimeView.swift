//
//  RKTimeView.swift
//  RKCalendar
//
//  Created by Ringo Wathelet on 2019/10/23.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI


public struct RKTimeView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var rkManager: RKManager
    
    @Binding var date: Date
    @Binding var showTime: Bool
    @Binding var hasTime: Bool
    
//    @ObservedObject var options = ClockLooks()
    
    var todayRange: ClosedRange<Date> {
        let min = Calendar.current.startOfDay(for: date)
        let max = min.addingTimeInterval(60*60*24)
        return min...max
    }
    
    public var body: some View {
        NavigationView {
            VStack {
  //              ClockPickerView(date: self.$date, options: self.options)
                DatePicker("", selection: self.$date, in: todayRange, displayedComponents: .hourAndMinute).fixedSize()
            }.navigationBarTitle(Text("Time setting"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: self.onDone ) { Text("Done") })
                .onDisappear(perform: doExit)
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        // the initial value of the date
        switch rkManager.mode {
        case 0:
            if rkManager.selectedDate != nil && rkManager.calendar.isDate(rkManager.selectedDate, inSameDayAs: date) {
                date = rkManager.selectedDate
            }
        case 1, 2:
            if rkManager.startDate != nil && rkManager.calendar.isDate(rkManager.startDate, inSameDayAs: date) {
                date = rkManager.startDate
            }
            if rkManager.endDate != nil && rkManager.calendar.isDate(rkManager.endDate, inSameDayAs: date) {
                date = rkManager.endDate
            }
        case 3:
            if let ndx = rkManager.selectedDatesFindIndex(date: date) {
                date = rkManager.selectedDates[ndx]
            }
        default:
            break
        }
    }
     
    func onDone() {
        // to go back to the previous view passing through doExit
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func doExit() {
        switch rkManager.mode {
        case 0:
            rkManager.selectedDate = date
        case 1, 2:
            if self.rkManager.startDate != nil && self.rkManager.calendar.isDate(self.rkManager.startDate, inSameDayAs: date) {
                self.rkManager.startDate = date
            }
            if self.rkManager.endDate != nil && self.rkManager.calendar.isDate(self.rkManager.endDate, inSameDayAs: date) {
                self.rkManager.endDate = date
            }
        case 3:
            if let ndx = rkManager.selectedDates.firstIndex(where: {
                rkManager.calendar.isDate($0, inSameDayAs: date)}) {
                rkManager.selectedDates[ndx] = date
            }
        default:
            break
        }
        showTime = false
        hasTime.toggle()
    }
    
}


struct RKTimeView_Previews: PreviewProvider {
    static var previews: some View {
        RKTimeView(rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0), date: .constant(Date()), showTime: .constant(false), hasTime: .constant(false))
    }
}
