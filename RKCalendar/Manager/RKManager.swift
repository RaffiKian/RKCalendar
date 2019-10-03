//
//  RKManager.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import Combine
import SwiftUI

class RKManager : ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    init(calendar: Calendar, minimumDate: Date, maximumDate: Date){
        self.calendar = calendar
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
    }
    
    var calendar : Calendar {
        didSet {
            objectWillChange.send()
        }
    }
    
    var minimumDate : Date {
        didSet {
            objectWillChange.send()
        }
    }
    
    var maximumDate : Date {
        didSet {
            objectWillChange.send()
        }
    }
    
    var selectedDate : Date! {
        didSet {
            objectWillChange.send()
        }
    }
    
    var startDate : Date! {
        didSet {
            objectWillChange.send()
        }
    }
    
    var endDate : Date! {
        didSet {
            objectWillChange.send()
        }
    }
}
