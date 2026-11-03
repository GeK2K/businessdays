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
let calendar = bdCalendarId.klndrUSNYSE  # New York Stock Exchange (NYSE) calendar

# some arbitrary dates
let 
  dt0 = dateTime(2014, mDec, 31)  # Wednesday  
  dt1 = dateTime(2015, mJan, 1)   # Thursday  
  dt2 = dateTime(2015, mJan, 2)   # Friday  
  dt3 = dateTime(2015, mJan, 3)   # Saturday 
  #dt4 = dateTime(2015, mJan, 4)  # Sunday  ('dt4' is not used here)
  dt5 = dateTime(2015, mJan, 5)   # Monday  
  dt6 = dateTime(2015, mJan, 6)   # Tuesday

# 'dt1' (resp. 'dt2', 'dt3') is a holiday (resp. business day, weekend)
doAssert:  calendar.isholiday(dt1) 
doAssert:  calendar.isbday(dt2)
doAssert:  calendar.isweekend(dt3)
 
# all known information about a date can be grouped into a string
doAssert:  calendar.info(dateTime(2021, mDec, 25)) == "Saturday, December 25, 2021:  weekend"
doAssert:  calendar.info(dateTime(2021, mDec, 24)) == "Friday, December 24, 2021:  public holiday"
# In 2021, Christmas Day was celebrated on Friday December 24 
# on the New York Stock Exchange; it is this day that is 
# considered a public holiday by the system, not December 25.

# nearest business day (in the future or in the past)
doAssert:  !calendar.nextbday(dt1, forward = true) ==~ dt2
doAssert:  !calendar.nextbday(dt1, forward = false) ==~ dt0
 
# you can shift by one or more business days (forward or backward)
doAssert:  !calendar.addbdays(dt0, 1) ==~ dt2
doAssert:  !calendar.addbdays(dt0, 2) ==~ dt5
doAssert:  !calendar.addbdays(dt6, -3) ==~ dt0
 
# business day conventions are supported
let 
  dt11 = dateTime(2011, mApr, 29)  # Friday
  dt12 = dateTime(2012, mMar, 28)  # Wednesday
  dt13 = dateTime(2012, mMar, 30)  # Friday
# 'bdcEndOfMonth' is an item of the 'bdBusinessDayConvention' enumeration
doAssert:  !calendar.bday(bdcEndOfMonth, dt11) ==~ dt11
doAssert:  !calendar.bday(bdcEndOfMonth, dt12) ==~ dt13
 
# business days between two dates
let bizDays = calendar.bdays(fromDate = dt0, toDate = dt6)
doAssert:  bizdays == @[dt0, dt2, dt5, dt6]
  
# 2 public holidays observed in January 2024
doAssert: calendar.holidays(2024, mJan) == @[
  dateTime(2024, mJan, 1),   # New Year's day
  dateTime(2024, mJan, 15)]  # Birthday of Martin Luther King
  
# 10 public holidays observed in 2025
doAssert: calendar.holidays(2025) == @[
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
let bizDaysNYSE2025 = calendar.bdays(fromDate = dateTime(2025, mJan, 1), 
      toDate = dateTime(2025, mDec, 31))
# 365 calendar days - 104 weekends - 10 observed holidays  =  251 business days
doAssert:  bizDaysNYSE2025.len == 251
 
# some calculations with the above sequence
let dt250117 = dateTime(2025, mJan, 17)  # Friday
# January 18-19:  weekend
# January 20:  Birthday of Martin Luther King (holiday)
let dt250121 = dateTime(2025, mJan, 21)  # Tuesday (business day)
let dt250122 = dateTime(2025, mJan, 22)  # Wednesday (business day)
doAssert:  !bizDaysNYSE2025.nextbday(dt250117) ==~ dt250121 
doAssert:  !bizDaysNYSE2025.addbdays(dt250121, -1) ==~ dt250117
doAssert:  !bizDaysNYSE2025.addbdays(dt250117, 2) ==~ dt250122    
```

The reader is encouraged to consult the module documentation 
for an overview of other features made available.


## Some similar works

Similar modules have been developed in other programming languages:
  - [BusinessDays](https://juliafinance.github.io/BusinessDays.jl/stable/)
  - [bizdays](https://cran.r-project.org/web/packages/bizdays/index.html)


## businessdays.nim vs. BusinessDays.jl

The time it takes to generate the holiday calendar for 
the US Bond Market from 2015 to 2100 is comparable 
(approximately 0.2 seconds).

The holiday dates also coincide, with the exception 
of Veterans Day when November 11 falls on a Saturday. 
In this case, the Julia package lists Friday, November 10, 
as a holiday, even though no holiday should be included.

For example, the Julia package lists November 10, 2017, as a 
holiday, even though it is not on the list of holidays available 
[here] (https://www.sifma.org/resources/general/us-holiday-archive/).


## Documentation
  - [API Reference](https://gek2k.github.io/businessdays/businessdays.html)
  - [Index](https://gek2k.github.io/businessdays)
  




 

  
 
