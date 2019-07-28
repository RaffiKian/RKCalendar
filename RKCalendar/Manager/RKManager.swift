//
//  RKManager.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import Combine
import SwiftUI

class RKManager : BindableObject {
    let willChange = PassthroughSubject<Void, Never>()
    
    init(calendar: Calendar, minimumDate: Date, maximumDate: Date){
        self.calendar = calendar
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
    }
    
    var calendar : Calendar {
        didSet {
            willChange.send()
        }
    }
    
    var minimumDate : Date {
        didSet {
            willChange.send()
        }
    }
    
    var maximumDate : Date {
        didSet {
            willChange.send()
        }
    }
    
    var selectedDate : Date! {
        didSet {
            willChange.send()
        }
    }
    
    var startDate : Date! {
        didSet {
            willChange.send()
        }
    }
    
    var endDate : Date! {
        didSet {
            willChange.send()
        }
    }
}
