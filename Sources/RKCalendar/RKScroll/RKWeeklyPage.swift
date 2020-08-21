//
//  RKWeeklyPage.swift
//  RKCalendar
//
//  Adapted by Ringo Wathelet on 2020/01/11.
//  from code gist of:
//  Created by Aleksey Ozerov on 24.10.2019.
//  Copyright © 2019 Aleksey Ozerov. All rights reserved.

import SwiftUI

public struct RKWeeklyPage: View, Identifiable {
    public let id = UUID()
    
    @EnvironmentObject public var rkManager: RKManager
    @State var monthNdx: Int
    @State var weekNdx: Int
    
    public var body: some View {
        VStack(spacing: 15) {
            RKWeekdayHeader()
            RKMonthHeader(monthOffset: monthNdx)
            RKMonth(monthOffset: monthNdx, weekOffset: weekNdx)
        }.fixedSize(horizontal: false, vertical: false)
    }
}
