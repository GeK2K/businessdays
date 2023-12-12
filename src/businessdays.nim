##[
============
businessdays
============
To value financial instruments or calculate accrued interest, it is 
essential to be able to calculate the duration between any two dates.

Counting the number of calendar days or the number of working days 
between any two dates is an important step in this calculation,
and this count must take very precise account of the calendars and 
conventions in force.

The `businessdays` module is intended to help the user in this delicate work.

The user will find here an overview of the functionalities available 
to him, but for a more complete view, he is invited to browse the 
submodules which are listed in the `Imports` section below.

But before starting it is appropriate to say a word 
about certain syntactic choices that were made.


Foreword
========

`times` module
--------------

Dates are handled with the `DateTime` type of the `times` 
module. But most of the time intraday information is not 
used (minutes, seconds, etc.).

Consequently we have defined comparison operators (`==~`, `!=~`, 
`<=~`, `<~`, `>=~`, `>~`) which do the same job as the original 
comparison operators (`==`, `!=`, `<=`, `<`, `>=`, `>`), but which 
do not take intraday information into account in their processing.

The user who wishes can however use the `cmpDate` 
procedure preferentially to these new operators.

The definitions of these operators and procedures are 
accessible from the links in the `Exports` section below.


`questionable` module
---------------------

To shorten certain parts of the code we have often favored the syntax 
of the `questionable` module over the syntax of the `options` module. 
Examples:  
  - `?T` instead of `Option[T]`
  - `!x` instead of `get(x)`
  - `y = x.?f` instead of `y = if x.isNone: none(U)  else:  get(x).f.some`
    1. `typeof(x) is Option[T]`
    2. `typeof(y) is Option[U]`
    3. `f: T -> U`(notation of the `sugar` module)


Feature overview
================
]##


## Using calendars
## ---------------

runnableExamples:

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
 
  # when necessary we can distinguish official and observed holidays; e.g.:
  #   - official Christmas Day 2021 = December 25 (Saturday)
  #   - observed Christmas Day 2021 = December 24 (Friday)
  doAssert: holidayChristmasDay(2021) ==~ dateTime(2021, mDec, 25)
  doAssert: holidayUSChristmasDayObs(2021) ==~ dateTime(2021, mDec, 24)
  doAssert: calendar.info(dateTime(2021, mDec, 25)) == "Saturday, December 25, 2021:  " & 
    "not a business day, not a holiday, weekend"
  doAssert: calendar.info(dateTime(2021, mDec, 24)) == "Friday, December 24, 2021:  " & 
    "not a business day, holiday, not a weekend"
  # it is therefore only December 24 which is considered a public holiday by the system

  # nearest business day (in the future or in the past)
  doAssert: !calendar.nextbday(dt1, forward = true) ==~ dt2
  doAssert: !calendar.nextbday(dt1, forward = false) ==~ dt0
 
  # you can shift by one or more business days (forward or backward)
  doAssert: !calendar.addbdays(dt0, 1) ==~ dt2
  doAssert: !calendar.addbdays(dt0, 2) ==~ dt5
  doAssert: !calendar.addbdays(dt6, -3) ==~ dt0
  
  # business day conventions are supported
  let dt11 = dateTime(2011, mApr, 29)  # Friday
  let dt12 = dateTime(2012, mMar, 28)  # Wednesday
  let dt13 = dateTime(2012, mMar, 30)  # Friday
  # 'bdcEndOfMonth' is an item of the 'qtBusinessDayConvention' enumeration
  doAssert: !calendar.bday(bdcEndOfMonth, dt11) ==~ dt11
  doAssert: !calendar.bday(bdcEndOfMonth, dt12) ==~ dt13
  
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
  doAssert: !bizDaysNYSE2025.nextbday(dt250117) ==~ dt250121 
  doAssert: !bizDaysNYSE2025.addbdays(dt250121, -1) ==~ dt250117
  doAssert: !bizDaysNYSE2025.addbdays(dt250117, 2) ==~ dt250122  


## Day counting
## ------------

runnableExamples:

  ## --------------------------------------------
  ## the user will find many more examples in the 
  ## 'daycount' module of the "Imports" section
  ## --------------------------------------------

  let utcZone = utc()  # the timezone we will use

  # Time interval 1:  from  31 January 2008  to  28 February 2008  (leap year)
  # --------------------------------------------------------------------------
  let startDate1 = dateTime(2008, mJan, 31, zone = utcZone)
  let endDate1 = dateTime(2008, mFeb, 28, zone = utcZone)

  doAssert: yearFraction(startDate1, endDate1, dccActual360) == 28.0/360.0
  doAssert: yearFraction(startDate1, endDate1, dccThirtyA360) == 28.0/360.0
  doAssert: yearFraction(startDate1, endDate1, dccThirtyU360) == 28.0/360.0
  doAssert: yearFraction(startDate1, endDate1, dccThirtyE360) == 28.0/360.0
  doAssert: yearFraction(startDate1, endDate1, dccThirtyEPlus360) == 28.0/360.0
  doAssert: yearFraction(startDate1, endDate1, dccThirtyG360) == 28.0/360.0

  # Day count is 28.0 for all considered day count conventions.

  # Time interval 2:  from  28 February 2007  to  31 March 2007  (non-leap year)
  # ----------------------------------------------------------------------------
  let startDate2 = dateTime(2007, mFeb, 28, zone = utcZone)
  let endDate2 = dateTime(2007, mMar, 31, zone = utcZone)

  doAssert: yearFraction(startDate2, endDate2, dccActual360) == 31.0/360.0
  doAssert: yearFraction(startDate2, endDate2, dccThirtyA360) == 33.0/360.0
  doAssert: yearFraction(startDate2, endDate2, dccThirtyU360) == 30.0/360.0
  doAssert: yearFraction(startDate2, endDate2, dccThirtyE360) == 32.0/360.0
  doAssert: yearFraction(startDate2, endDate2, dccThirtyEPlus360) == 33.0/360.0
  doAssert: yearFraction(startDate2, endDate2, dccThirtyG360) == 30.0/360.0

  # The actual number of days is 31.0. But depending on 
  # how the convention manages the end of the month, and 
  # the end of the month of February, we can also obtain 
  # 30.0, 32.0 or 33.0 days.


# =========================     Imports / Exports     ======================== #

import  ./businessdays/[businessdays_cache, calendars, daycount]
export  businessdays_cache, calendars, daycount
