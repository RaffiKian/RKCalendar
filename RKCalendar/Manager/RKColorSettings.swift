//
//  RKColorSettings.swift
//  RKCalendar
//
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class RKColorSettings : ObservableObject {

    // foreground colors
    @Published var textColor: Color = Color.primary
    @Published var todayColor: Color = Color.white
    @Published var selectedColor: Color = Color.white
    @Published var disabledColor: Color = Color.gray
    @Published var betweenStartAndEndColor: Color = Color.white
    // background colors
    @Published var textBackColor: Color = Color.clear
    @Published var todayBackColor: Color = Color.gray
    @Published var selectedBackColor: Color = Color.red
    @Published var disabledBackColor: Color = Color.clear
    @Published var betweenStartAndEndBackColor: Color = Color.blue
    // headers foreground colors
    @Published var weekdayHeaderColor: Color = Color.primary
    @Published var monthHeaderColor: Color = Color.primary
    // headers background colors
    @Published var weekdayHeaderBackColor: Color = Color.clear
    @Published var monthBackColor: Color = Color.clear

}
