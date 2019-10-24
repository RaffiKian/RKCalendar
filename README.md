
# RKCalendar
**RKCalendar** is a SwiftUI Calendar / Date Picker for iOS.


### In addition to the original features

- added a time (hh:mm) selection option on a long press, see example 5 in **ContentView.swift**

Time selection is available for single and multi-dates selections only (mode 0 and 3).
Time selection is activated by setting **displayTime** in RKManager (default **false**).
When set to **true** and there is a long press, a time selection view will popup allowing hours and minutes to be selected.



### Features include:

- minimum and maximum calendar dates selectable,
- single date selection, 
- range of dates selection, 
- multi-dates selection, 
- disabled dates setting.


### Light Mode
<img src="https://github.com/RaffiKian/RKCalendar/blob/master/RKCalendar/Images/demo-app-light-mode-1.png" alt="demo app first screenshot" width="260"/> <img src="https://github.com/RaffiKian/RKCalendar/blob/master/RKCalendar/Images/demo-app-light-mode-2.png" alt="demo app first screenshot" width="260"/> 
### Dark Mode
<img src="https://github.com/RaffiKian/RKCalendar/blob/master/RKCalendar/Images/demo-app-dark-mode-1.png" alt="demo app first screenshot" width="260"/> <img src="https://github.com/RaffiKian/RKCalendar/blob/master/RKCalendar/Images/demo-app-dark-mode-2.png" alt="demo app first screenshot" width="260"/> 

**⚠️ WARNING ⚠️** This is an early version of this library that requires Swift 5.1 and Xcode 11 

# Requirements
- iOS 13.0+
- Xcode 11+
- Swift 5.1+

# Installation

Integrate RKCalendar into your project by including the files in the "Manager" group.

# Usage 

See **ContenView.swift** for some examples. Typically create a **RKManager** and pass it to a **RKViewController**.

Customise the **RKManager** for the desired effects as follows:


## Calendar minimum and maximum date setting

Setting the calendar, minimum and maximum dates that can be selected.

    RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)

## Single date selection

Use mode 0 to select a single date.

    RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: maxDate, mode: 0)

## Range of dates selection

Use mode 1 to select a contiguous range of dates, from a start date to an end date.

    RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: maxDate, mode: 1)

Note, mode 2 is automatically toggled internally and the end date must be greater than the start date.

## Multi-dates selection

Use mode 3 for selecting a number of dates.

    RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: maxDate, mode: 3)

## Disabled-dates setting

Use any mode and set zero or more dates to be disabled (un-selectable).

For example:

    var rkManager = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: maxDate, mode: 0)

    rkManager.disabledDates.append(contentsOf: [
        Date().addingTimeInterval(60*60*24*4),
        Date().addingTimeInterval(60*60*24*5),
        Date().addingTimeInterval(60*60*24*7)
    ])

# License
RKCalendar is available under the MIT license. See the LICENSE file for more info.
