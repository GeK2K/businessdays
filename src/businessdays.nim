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

`nudates` module
----------------

We systematically used the comparison operators of the 
`nudates <https://gek2k.github.io/nimutils/nimutils/nudates.html>`_ 
module. For example `==~` for equality test, `!==~` 
for non-equality test, and so on.


`questionable` module
---------------------

To shorten certain parts of the code we have often favored the syntax 
of the `questionable <https://github.com/codex-storage/questionable>`_ 
module over the syntax of the `options` module. Examples:  
  - `?T` instead of `Option[T]`
  - `!x` instead of `get(x)`
  - *Option binding* with the `=?` operator (see 
    the module documentation for more information)
  - *Option chaining* with the `.?` operator (see 
    the module documentation for more information)
    - `y = x.?f` can be seen as a shortcut for
      `y = if x.isNone: none(U)  else:  get(x).f.some`
    - Preconditions: `typeof(x) is Option[T]`, 
      `typeof(y) is Option[U]`, `f: T -> U` (notation of the 
      `sugar <https://nim-lang.org/docs/sugar.html>`_ module)


Feature overview
================
]##


## Using calendars
## ---------------

runnableExamples:

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


## Day counting
## ------------

runnableExamples:

  ## --------------------------------------------
  ## the user will find many more examples in the 
  ## 'daycount' module of the "Imports" section
  ## --------------------------------------------

  # Time interval 1:  from  31 January 2008  to  28 February 2008  (leap year)
  # --------------------------------------------------------------------------
  let startDate1 = dateTime(2008, mJan, 31)
  let endDate1 = dateTime(2008, mFeb, 28)
 
  doAssert:  yearFraction(dccActual360, startDate1, endDate1) == 28.0/360.0
  doAssert:  yearFraction(dccThirtyA360, startDate1, endDate1) == 28.0/360.0
  doAssert:  yearFraction(dccThirtyU360, startDate1, endDate1) == 28.0/360.0
  doAssert:  yearFraction(dccThirtyE360, startDate1, endDate1) == 28.0/360.0
  doAssert:  yearFraction(dccThirtyEPlus360, startDate1, endDate1) == 28.0/360.0
  doAssert:  yearFraction(dccThirtyG360, startDate1, endDate1) == 28.0/360.0

  # Day count is 28.0 for all considered day count conventions.

  # Time interval 2:  from  28 February 2007  to  31 March 2007  (non-leap year)
  # ----------------------------------------------------------------------------
  let startDate2 = dateTime(2007, mFeb, 28)
  let endDate2 = dateTime(2007, mMar, 31)

  doAssert:  yearFraction(dccActual360, startDate2, endDate2) == 31.0/360.0
  doAssert:  yearFraction(dccThirtyA360, startDate2, endDate2) == 33.0/360.0
  doAssert:  yearFraction(dccThirtyU360, startDate2, endDate2) == 30.0/360.0
  doAssert:  yearFraction(dccThirtyE360, startDate2, endDate2) == 32.0/360.0
  doAssert:  yearFraction(dccThirtyEPlus360, startDate2, endDate2) == 33.0/360.0
  doAssert:  yearFraction(dccThirtyG360, startDate2, endDate2) == 30.0/360.0

  # The actual number of days is 31.0. But depending on 
  # how the convention manages the end of the month, and 
  # the end of the month of February, we can also obtain 
  # 30.0, 32.0 or 33.0 days.


# =========================     Imports / Exports     ======================== #

import  ./businessdays/[calendars, daycount]
export  calendars, daycount


