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
    let didChange = PassthroughSubject<Void, Never>()
    
    init(calendar: Calendar, minimumDate: Date, maximumDate: Date){
        self.calendar = calendar
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
    }
    
    var calendar : Calendar {
        didSet {
            didChange.send()
        }
    }
    
    var minimumDate : Date {
        didSet {
            didChange.send()
        }
    }
    
    var maximumDate : Date {
        didSet {
            didChange.send()
        }
    }
    
    var selectedDate : Date! {
        didSet {
            didChange.send()
        }
    }
    
    var startDate : Date! {
        didSet {
            didChange.send()
        }
    }
    
    var endDate : Date! {
        didSet {
            didChange.send()
        }
    }
}
