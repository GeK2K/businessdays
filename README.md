# businessdays

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)


## Introduction

To value financial instruments or calculate accrued interest 
(to take just these examples), it is essential to be able to 
calculate the duration between any two dates.

Counting the number of calendar days or the number of working days 
between any two dates is an important step in this calculation,
and this count must take very precise account of the calendars 
and conventions in force.

The `businessdays` module is intended to help the user in this delicate work.


## Compatibility

Nim +2.0.0


## Dependencies
  - [questionable](https://github.com/codex-storage/questionable)
  - [nimutils](https://github.com/GeK2K/nimutils)


## Getting started

Install `businessdays` using `nimble`:

```text
nimble install businessdays
```

or add a dependency to the `.nimble` file of your project:

```text
requires "businessdays >= 0.1.0"
```

and start using it:

```nim
# some calendars are natively supported by the system
let calendar = newCalendarUSNYSE()  # New York Stock Exchange (NYSE) calendar

# some arbitrary dates
let dt0 = dateTime(2014, mDec, 31)   # Wednesday  
let dt1 = dateTime(2015, mJan, 1)    # Thursday  
let dt2 = dateTime(2015, mJan, 2)    # Friday  
let dt3 = dateTime(2015, mJan, 3)    # Saturday  
let dt4 = dateTime(2015, mJan, 4)    # Sunday
let dt5 = dateTime(2015, mJan, 5)    # Monday  
let dt6 = dateTime(2015, mJan, 6)    # Tuesday

# 'dt1' (resp. 'dt2', 'dt3') is a holiday (resp. business day, weekend)
doAssert: !calendar.isholiday(dt1) 
doAssert: !calendar.isbday(dt2)
doAssert: !calendar.isweekend(dt3)
  
# all known information about a date can be grouped into a string
doAssert: calendar.info(dt4) == "Sunday, January 4, 2015:  " & 
  "not a business day, not a holiday, weekend"

# all known information about a date can be grouped into a string
doAssert:  calendar.info(dt4) == "Sunday, January 4, 2015:  " & 
  "not a business day, not a holiday, weekend"
doAssert:  calendar.info(dateTime(2021, mDec, 25)) == "Saturday, December 25, 2021:  " & 
  "not a business day, not a holiday, weekend"
doAssert:  calendar.info(dateTime(2021, mDec, 24)) == "Friday, December 24, 2021:  " & 
  "not a business day, holiday, not a weekend"
# In 2021, Christmas Day was celebrated on Friday December 24 
# on the New York Stock Exchange; it is this day that is 
# considered a public holiday by the system, not December 25.

# nearest business day (in the future or in the past)
doAssert: !calendar.nextbday(dt1, forward = true) ~== dt2
doAssert: !calendar.nextbday(dt1, forward = false) ~== dt0
 
# you can shift by one or more business days (forward or backward)
doAssert: !calendar.addbdays(dt0, 1) ~== dt2
doAssert: !calendar.addbdays(dt0, 2) ~== dt5
doAssert: !calendar.addbdays(dt6, -3) ~== dt0
  
# business day conventions are supported
let dt11 = dateTime(2011, mApr, 29)  # Friday
let dt12 = dateTime(2012, mMar, 28)  # Wednesday
let dt13 = dateTime(2012, mMar, 30)  # Friday
# 'bdcEndOfMonth' is an item of the 'bdBusinessDayConvention' enumeration
doAssert: !calendar.bday(bdcEndOfMonth, dt11) ~== dt11
doAssert: !calendar.bday(bdcEndOfMonth, dt12) ~== dt13
  
# business days between two dates (the 'dateInterval' parameter 
# allows you to include or exclude 'fromDate' or 'toDate')
let bizDays = calendar.bdays(fromDate = dt0, toDate = dt6, 
                             dateInterval = BoundedClosed)
doAssert: bizdays == @[dt0, dt2, dt5, dt6]  
doAssert: bizdays.len == 4  # number of business days
  
# 2 public holidays observed in January 2024
let obsHolidays2024January = calendar.observedHolidays(2024, mJan)
doAssert: obsHolidays2024January == @[
  dateTime(2024, mJan, 1),   # New Year's day
  dateTime(2024, mJan, 15)]  # Birthday of Martin Luther King
  
# 10 public holidays observed in 2025
let obsHolidays2025 = calendar.observedHolidays(2025)
doAssert: obsHolidays2025 == @[
  dateTime(2025, mJan, 1),   # New Year's day
  dateTime(2025, mJan, 20),  # Birthday of Martin Luther King
  dateTime(2025, mFeb, 17),  # Washington's Birthday
  dateTime(2025, mApr, 18),  # Good Friday
  dateTime(2025, mMay, 26),  # Memorial Day
  dateTime(2025, mJun, 19),  # Juneteenth National Independence Day
  dateTime(2025, mJul, 4),   # Independence Day
  dateTime(2025, mSep, 1),   # Labor Day
  dateTime(2025, mNov, 27),  # Thanksgiving Day
  dateTime(2025, mDec, 25)]  # Christmas Day

# to speed up subsequent calculations, business days can 
# be stored in a sequence that can be reused several times
let bizDaysNYSE2025 = 
      calendar.bdays(fromDate = dateTime(2025, mJan, 1),
                     toDate = dateTime(2025, mDec, 31),
                     dateInterval = BoundedClosed)
# 365 calendar days - 104 weekends - 10 observed holidays = 
#   251 business days
doAssert: bizDaysNYSE2025.len == 251
  
# some calculations with the above sequence
let dt250117 = dateTime(2025, mJan, 17)  # Friday
# January 18, 2025: Saturday (weekend)
# January 19, 2025: Sunday (weekend)
# January 20, 2025: Birthday of Martin Luther King (holiday)
let dt250121 = dateTime(2025, mJan, 21)  # Tuesday (business day)
let dt250122 = dateTime(2025, mJan, 22)  # Wednesday (business day)
doAssert: !bizDaysNYSE2025.nextbday(dt250117) ~== dt250121 
doAssert: !bizDaysNYSE2025.addbdays(dt250121, -1) ~== dt250117
doAssert: !bizDaysNYSE2025.addbdays(dt250117, 2) ~== dt250122  
```

The reader is encouraged to consult the module documentation 
for an overview of other features made available.


## Some similar works

Similar modules have been developed in other programming languages:
  - [BusinessDays](https://juliafinance.github.io/BusinessDays.jl/stable/)
  - [bizdays](https://cran.r-project.org/web/packages/bizdays/index.html)


## Documentation
  - [API Reference](https://gek2k.github.io/businessdays/businessdays.html)
  - [Index](https://gek2k.github.io/businessdays)
