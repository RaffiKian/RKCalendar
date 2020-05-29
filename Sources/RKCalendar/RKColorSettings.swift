//
//  RKColorSettings.swift
//  RKCalendar
//
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

public class RKColorSettings : ObservableObject {

    // foreground colors
    @Published public var textColor: Color = Color.primary
    @Published public var todayColor: Color = Color.white
    @Published public var selectedColor: Color = Color.white
    @Published public var disabledColor: Color = Color.gray
    @Published public var betweenStartAndEndColor: Color = Color.white
    // background colors
    @Published public var textBackColor: Color = Color.clear
    @Published public var todayBackColor: Color = Color.gray
    @Published public var selectedBackColor: Color = Color.red
    @Published public var disabledBackColor: Color = Color.clear
    @Published public var betweenStartAndEndBackColor: Color = Color.blue
    // headers foreground colors
    @Published public var weekdayHeaderColor: Color = Color.primary
    @Published public var monthHeaderColor: Color = Color.primary
    // headers background colors
    @Published public var weekdayHeaderBackColor: Color = Color.clear
    @Published public var monthBackColor: Color = Color.clear

    public init() {}
}
