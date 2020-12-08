# RKCalendar

**RKCalendar** is a SwiftUI Calendar / Date Picker for iOS and MacOS.


### Features include:

- minimum and maximum calendar dates selectable,
- single date selection, 
- range of dates selection, 
- multi-dates selection, 
- disabled dates setting,
- time selection,
- horizontal view,
- weekly view.


### Light Mode
<img src="https://github.com/RaffiKian/RKCalendar/blob/master/RKCalendar/Images/demo-app-light-mode-1.png" alt="demo app first screenshot" width="260"/> <img src="https://github.com/RaffiKian/RKCalendar/blob/master/RKCalendar/Images/demo-app-light-mode-2.png" alt="demo app first screenshot" width="260"/> 
### Dark Mode
<img src="https://github.com/RaffiKian/RKCalendar/blob/master/RKCalendar/Images/demo-app-dark-mode-1.png" alt="demo app first screenshot" width="260"/> <img src="https://github.com/RaffiKian/RKCalendar/blob/master/RKCalendar/Images/demo-app-dark-mode-2.png" alt="demo app first screenshot" width="260"/> 


# Requirements

- iOS 14+, MacOS 11+
- Swift 5.3+

# Installation

`RKCalendar` is install via the official [Swift Package Manager](https://swift.org/package-manager/).  

Select `Xcode`>`File`> `Swift Packages`>`Add Package Dependency...`  
and add `https://github.com/RaffiKian/RKCalendar`

# Usage 

Typically create a **RKManager** and pass it to a **RKCalendarView**, for example:

```swift
import SwiftUI
import RKCalendar

struct ContentView : View {
    
    @State var showCalendar = false
    @ObservedObject var rkManager = RKManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-60*60*24*60), maximumDate: Date().addingTimeInterval(60*60*24*90), mode: .singleDate)
    
    var body: some View {
                Button(action: { showCalendar.toggle() }) {
                    Text("Example - Single Date Selection").foregroundColor(.blue)
                }
                .sheet(isPresented: $showCalendar) { 
                        RKCalendarView().environmentObject(rkManager) 
                }     
        }
    }
}
```

## Calendar minimum and maximum date setting

Setting the calendar, minimum and maximum dates that can be selected.

    RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: .singleDate)

## Single date selection

Use mode  *.singleDate* to select a single date.

    RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: maxDate, mode: .singleDate)

## Range of dates selection

Use mode *.dateRange* to select a contiguous range of dates, from a start date to an end date.

    RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: maxDate, mode: .dateRange)

Note, mode *.dateRange* is automatically toggled internally and the end date must be greater than the start date.

## Multi-dates selection

Use mode *.multiDate* for selecting a number of dates.

    RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: maxDate, mode: .multiDate)

## Disabled-dates setting

Use any mode and set zero or more dates to be disabled (un-selectable).

For example:

    var rkManager = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: maxDate, mode: .singleDate)

    rkManager.disabledDates.append(contentsOf: [
        Date().addingTimeInterval(60*60*24*4),
        Date().addingTimeInterval(60*60*24*5),
        Date().addingTimeInterval(60*60*24*7)
    ])

## Time selection

**RKTimeView** allows for a time (hh:mm) selection option on a long press.

Time selection is activated by setting **displayTime=true** in RKManager (default **false**).
On a long press, a time selection view will popup allowing hours and minutes to be selected.  
Time selection is available for all modes. For mode ".dateRange", select the start and end dates as usual with a tap, then with a long press, select the time desired.  

## Horizontal view

An  **horizontal view** of the calendar is activated by setting **isVertical=false** in RKManager (default **true**).


## Weekly view

An  **weekly view** of the calendar is activated by setting **isWeeklyView=true** in RKManager (default **false**). Note you must also set **isVertical=false**. Currently only works with **isContinuous=false**, that is, horizontal paging only.


##  Language

The language of the calendar is activated by setting **locale** in RKManager (default **Local.curent**) to display the months and weeks in the chosen language. 


##  Other options

The RKCalendar can be in two scrolling modes, a continuous mode to display a scrolling calendar of months, or a one month at a time (paging) scrolling view. This is activated by setting **isContinuous** in RKManager (default **true**). 

RKCalendar can prevent a user input for the current mode by setting **disabled=true** in RKManager (default **false**).

Various elements of **RKCalendar**, such as the monthly headings, can be colored. This is achieved by customising the relevent **RKManager.colors**.



# License

RKCalendar is available under the MIT license. See the LICENSE file for more info.
