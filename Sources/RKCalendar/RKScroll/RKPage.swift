//
//  RKPage.swift
//  RKCalendar
//
//  Adapted by Ringo Wathelet on 2020/01/11.
//  from code gist of:
//  Created by Aleksey Ozerov on 24.10.2019.
//  Copyright © 2019 Aleksey Ozerov. All rights reserved.

import SwiftUI

public struct RKPage: View, Identifiable {
    public let id = UUID()
    
    @EnvironmentObject public var rkManager: RKManager
    @State var index: Int
    
    public var body: some View {
        VStack(spacing: 15) {
            RKMonthHeader(monthOffset: index)
            RKWeekdayHeader()
            Divider()
            RKMonth(monthOffset: index)
            Spacer()
        }.fixedSize(horizontal: false, vertical: false)
    }
}
