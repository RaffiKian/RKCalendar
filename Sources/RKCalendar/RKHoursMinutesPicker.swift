//
//  HoursMinutesPicker.swift
//  RKCalendar
//
//  Created by Ringo Wathelet on 2020/05/30.
//  Copyright © 2020 Raffi Kian. All rights reserved.
//

import Foundation
import SwiftUI

// alternative to using DatePicker for hours and minutes on Mac Catalyst
struct RKHoursMinutesPicker: View {
    
    @Binding var date: Date
    @State var hours: Int = 0
    @State var minutes: Int = 0
    
    var body: some View {
        HStack {
            Spacer()
            Picker("", selection: Binding<Int>(
                get: { hours},
                set: {
                    hours = $0
                    update()
            })) {
                ForEach(0..<24, id: \.self) { i in
                    Text("\(i) hours").tag(i)
                }
            }.pickerStyle(WheelPickerStyle()).frame(width: 90).clipped()
            Picker("", selection: Binding<Int>(
                get: { minutes},
                set: {
                    minutes = $0
                    update()
            })) {
                ForEach(0..<60, id: \.self) { i in
                    Text("\(i) min").tag(i)
                }
            }.pickerStyle(WheelPickerStyle()).frame(width: 90).clipped()
            Spacer()
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        hours = Calendar.current.component(.hour, from: date)
        minutes = Calendar.current.component(.minute, from: date)
    }
    
    func update() {
        if let newDate = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: date), date != newDate {
            date = newDate
        }
    }
}
