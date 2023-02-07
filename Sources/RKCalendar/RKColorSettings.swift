//
//  RKColorSettings.swift
//  RKCalendar
//
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

public struct RKColorSettings {

    // foreground colors
     public var textColor: Color = Color.primary
     public var todayColor: Color = Color.white
     public var selectedColor: Color = Color.white
     public var disabledColor: Color = Color.gray
     public var betweenStartAndEndColor: Color = Color.white
    // background colors
     public var textBackColor: Color = Color.clear
     public var todayBackColor: Color = Color.gray
     public var selectedBackColor: Color = Color.red
     public var disabledBackColor: Color = Color.clear
     public var betweenStartAndEndBackColor: Color = Color.blue
    // headers foreground colors
     public var weekdayHeaderColor: Color = Color.primary
     public var monthHeaderColor: Color = Color.primary
    // headers background colors
     public var weekdayHeaderBackColor: Color = Color.clear
     public var monthBackColor: Color = Color.clear

}
