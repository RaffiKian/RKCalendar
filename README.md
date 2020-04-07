### In addition to the original features

- added **RKTimeView** a time (hh:mm) selection option on a long press, see example 5 in **ContentView.swift**

   Time selection is activated by setting **displayTime=true** in RKManager (default **false**).
   
   On a long press, a time selection view will popup allowing hours and minutes to be selected.  
   
   Time selection is available for all modes. For mode 1, select the start and end dates as usual with a tap, then with a long press, select the time desired.  

   The default time picker is *DatePicker*, however you can easily use [**ClockPicker**](https://github.com/workingDog/ClockPicker) to display a nice clock with draggable hands. Just modify the **RKTimeView** and include the **ClockPicker** code.  

- added a  **horizontal view** of the calendar. 

   This is activated by setting **isVertical=false** in RKManager (default **true**). See example 7 in ContentView.

- added  **isContinuous** to display a continuous calendar of months or a one month view at a time. See example 6,7 in ContentView.

   This is activated by setting **isContinuous=false** in RKManager (default **true**). This is a workaround until SwiftUI ScrollView gain the capability to do paging.

- added a  **weekly view** of the calendar. See example 6 in ContentView.

   This is activated by setting **isWeeklyView=true** in RKManager (default **false**), see example 6. Note you must also set **isVertical=false**.

- added **RKMonthHeader** and separated the month headers from **RKMonth** to allow for better mix and match of week and month headers.

- added a **disabled** setting, to prevent any user input for the current mode.

   This is activated with **disabled=true** in RKManager (default **false**).

- added  **locale** in RKManager (default **Local.curent**) to display the months and weeks in the chosen language. See example 5 in ContentView.

- added the calendar scrolling to the current date when first displayed. Note, this is only available for horizontal and vertical continuous months displays.

- moved some date property functions from **RKMonth** to **RKManager**

- simplified **RKDate** construction.



#

# RKCalendar
**RKCalendar** is a SwiftUI Calendar / Date Picker for iOS.


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
