//
//  RKTimeView.swift
//  RKCalendar
//
//  Created by Ringo Wathelet on 2019/10/23.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI


public struct RKTimeView: View {
    
    @Environment(\.presentationMode) public var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject public var rkManager: RKManager
    
    @Binding var date: Date
    @Binding var showTime: Bool
    @Binding var hasTime: Bool
    
    var todayRange: ClosedRange<Date> {
        let min = Calendar.current.startOfDay(for: date)
        let max = min.addingTimeInterval(60*60*24)
        return min...max
    }
    
    public var body: some View {
        VStack (alignment: .leading) {
            Text("Time").padding(10)
            HStack {
                Spacer()
                DatePicker("Time", selection: Binding<Date>(
                    get: { date },
                    set: {
                        date = $0
                        update()
                    }
                ),
                in: todayRange, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .frame(minWidth: 300, maxWidth: .infinity, minHeight: 80, maxHeight: .infinity, alignment: .leading)
                .datePickerStyle(GraphicalDatePickerStyle())
                .clipped()
                
                Spacer()
            }
        }
        .onAppear(perform: loadData)
    }
    
    public func loadData() {
        // the initial value of the date
        switch rkManager.mode {
        case .singleDate:
            if rkManager.selectedDate != nil && rkManager.calendar.isDate(rkManager.selectedDate, inSameDayAs: date) {
                date = rkManager.selectedDate
            }
        case .dateRange, .dateRange2:
            if rkManager.startDate != nil && rkManager.calendar.isDate(rkManager.startDate, inSameDayAs: date) {
                date = rkManager.startDate
            }
            if rkManager.endDate != nil && rkManager.calendar.isDate(rkManager.endDate, inSameDayAs: date) {
                date = rkManager.endDate
            }
        case .multiDate:
            if let ndx = rkManager.selectedDatesFindIndex(date: date) {
                date = rkManager.selectedDates[ndx]
            }
        }
    }
    
    public func onDone() {
        update()
        showTime = false
        // to go back to the previous view passing through doExit
        presentationMode.wrappedValue.dismiss()
    }
    
    public func update() {
        switch rkManager.mode {
        case .singleDate:
            rkManager.selectedDate = date
        case .dateRange, .dateRange2:
            if rkManager.startDate != nil && rkManager.calendar.isDate(rkManager.startDate, inSameDayAs: date) {
                rkManager.startDate = date
            }
            if rkManager.endDate != nil && rkManager.calendar.isDate(rkManager.endDate, inSameDayAs: date) {
                rkManager.endDate = date
            }
        case .multiDate:
            if let ndx = rkManager.selectedDates.firstIndex(where: {rkManager.calendar.isDate($0, inSameDayAs: date)}) {
                rkManager.selectedDates[ndx] = date
            }
        }
        hasTime.toggle()
    }
    
}


struct RKTimeView_Previews: PreviewProvider {
    static var previews: some View {
        RKTimeView(date: .constant(Date()), showTime: .constant(false), hasTime: .constant(false))
    }
}
