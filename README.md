
### In addition to the original code
- Compatibility with xCode 11 beta 6
- Added multiple dates selection: *selectedDates: [Date] to RKManager*
- Added a new mode=3 for the multiple selectedDates
- Added disabled dates option: *disabledDates: [Date] to RKManager*
- Moved the mode variable to the RKManager to allow for dynamic setting.
- Updated the contiguous range of dates selection (mode=1). Start in mode=1 and mode=2 is set automatically internally. Note the start date must be greater than the end date.
- Updated the README.md file
- Plus some other bits

***
<br>

# RKCalendar
SwiftUI Simple Calendar / Date Picker for iOS

### Light Mode
<img src="https://github.com/RaffiKian/RKCalendar/blob/master/RKCalendar/Images/demo-app-light-mode-1.png" alt="demo app first screenshot" width="260"/> <img src="https://github.com/RaffiKian/RKCalendar/blob/master/RKCalendar/Images/demo-app-light-mode-2.png" alt="demo app first screenshot" width="260"/> 
### Dark Mode
<img src="https://github.com/RaffiKian/RKCalendar/blob/master/RKCalendar/Images/demo-app-dark-mode-1.png" alt="demo app first screenshot" width="260"/> <img src="https://github.com/RaffiKian/RKCalendar/blob/master/RKCalendar/Images/demo-app-dark-mode-2.png" alt="demo app first screenshot" width="260"/> 

**⚠️ WARNING ⚠️** This is an early version of this library that requires Swift 5.1 and Xcode 11 that are currently still in beta.

# Requirements
- iOS 13.0+
- Xcode 11+
- Swift 5.1+

# Installation

You can integrate RKCalendar into your project manually.

# Usage 

See **ContenView.swift** for some example usage. Typically create a **RKManager** and pass it to a **RKViewController**.

Customise the **RKManager** for the desired effects as follows:


## Calendar minimum and maximum date setting

Provide a calendar, minimum and maximum dates that can be selected.

    let minDate = Date()
    let maxDate = Date().addingTimeInterval(60*60*24*365)
    RKManager(calendar: Calendar.current, minimumDate: minDate, maximumDate: maxDate, mode: 0)

## Single date selection

Use mode 0 to select a single date.

    RKManager(calendar: Calendar.current, minimumDate: minDate, maximumDate: maxDate, mode: 0)

## Range of dates selection

Use mode 1 to select a contiguous range of dates, from a start date to an end date.

    RKManager(calendar: Calendar.current, minimumDate: minDate, maximumDate: maxDate, mode: 1)

Note mode 2 is automatically set internally.

## Multi-dates selection

Use mode 3 for selecting a number of dates.

    RKManager(calendar: Calendar.current, minimumDate: minDate, maximumDate: maxDate, mode: 3)

## Disabled-dates setting

Use any mode and set one or more dates to be disabled (un-selectable).

For example:

    var rkManager = RKManager(calendar: Calendar.current, minimumDate: minDate, maximumDate: maxDate, mode: 1)

    self.rkManager.disabledDates.append(contentsOf: [
        Date().addingTimeInterval(60*60*24*4),
        Date().addingTimeInterval(60*60*24*5),
        Date().addingTimeInterval(60*60*24*7)
    ])


# License
RKCalendar is available under the MIT license. See the LICENSE file for more info.
