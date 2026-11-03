##[
=========
calendars
=========

The `calendars` module contains routines and types for dealing with calendars
(holidays, week-ends, businessdays, arithmetic with business days, etc.).
]##


# =========================     Imports / Exports     ======================== #

import  std/[algorithm, strformat], questionable
import  nimutils/[nuconstants, nuoop, nualgorithm], ./calendars/[holidays]
export  nuconstants, nuoop, nualgorithm, holidays


# ==============     Calendars  &  Business Day Conventions     ============== #

type
  bdCalendar* {.inheritable.} = ref object
    ## In an object-oriented approach to the system, calendars 
    ## must be objects of this type or objects of a derived type.
#
  bdCalendarId* = enum
    ## List of calendars natively supported by the system.
    klndrNoHolidayOrWeekend = "calendar without holidays or weekends"
    klndrWeekendsOnlyInTheWest = "calendars having weekends (Saturday and Sunday) but no holidays"
    klndrTARGET = "TARGET calendar"
    klndrUSFederalGovt = "U.S. Federal Government calendar"
    klndrUSBondMarket = "U.S. Bond Market calendar"
    klndrUSNYSE = "New York Stock Exchance (NYSE) calendar"
    klndrUKEngland = "English calendar"
    klndrUKScotland = "Scottish calendar"
    klndrUKNorthenIreland = "Northen Ireland calendar"

  bdBusinessDayConvention* = enum
    ## Business day conventions. Precise definitions and examples can be found here:
    ## - https://quant.opengamma.io/Interest-Rate-Instruments-and-Market-Conventions.pdf (p. 8)
    bdcFollowing = "next business day"
    bdcPredecing = "previous business day" 
    bdcModifFollowing = "modified next business day"
    bdcModifFollowingFornight = "next business day modified fornightly"
    bdcEndOfMonth = "business day at end of month"


# =========================     procs  &  methods     ======================== #

method `$`*(calendar: bdCalendar): string  {.base.} =
  ## Returns a string representation of `calendar`.
  raiseMethodNotImplemDefect()


proc isweekend*(calendar: bdCalendarId, dt: DateTime): bool = 
  ##[
  **Returns:**
    - `true` if `dt` is a weekend in the `calendar` calendar
    - `false` if `dt` is not a weekend in the `calendar` calendar
  ]##
  runnableExamples:
    let calendar = bdCalendarId.klndrUSFederalGovt
    doAssert:  not calendar.isweekend(dateTime(2015, mJan, 2))  # Friday
    doAssert:  calendar.isweekend(dateTime(2015, mJan, 4))  # Sunday
  case calendar
    of klndrNoHolidayOrWeekend:  return false
    else:  return dt.isWeekendDay


method isweekend*(calendar: bdCalendar, dt: DateTime): bool  {.base.} = 
  ##[
  **Returns:**
    - `true` if `dt` is a weekend in the `calendar` calendar
    - `false` if `dt` is not a weekend in the `calendar` calendar
  ]##
  raiseMethodNotImplemDefect()


proc isholiday*(calendar: bdCalendarId, dt: DateTime): bool = 
  ##[
  **Returns:**
    - `true` if `dt` is a holiday in the `calendar` calendar
    - `false` if `dt` is not a holiday in the `calendar` calendar
  ]##
  runnableExamples:
    let calendar = bdCalendarId.klndrUSFederalGovt
    doAssert:  calendar.isholiday(dateTime(2015, mJan, 1))  # New Year's Day
    doAssert:  not calendar.isholiday(dateTime(2015, mJan, 2))
  case calendar
    of klndrNoHolidayOrWeekend, klndrWeekendsOnlyInTheWest:  return false
    of klndrTARGET:  return dt.isholidayTARGET
    of klndrUSFederalGovt:  return dt.isholidayUSFederalGovt
    of klndrUSBondMarket:  return dt.isholidayUSBondMarket
    of klndrUSNYSE:  return dt.isholidayUSNYSE
    of klndrUKEngland:  return dt.isholidayUKEngland
    of klndrUKScotland:  return dt.isholidayUKScotland
    of klndrUKNorthenIreland:  return dt.isholidayUKNorthenIreland


method isholiday*(calendar: bdCalendar, dt: DateTime): bool  {.base.} = 
  ##[
  **Returns:**
    - `true` if `dt` is a holiday in the `calendar` calendar
    - `false` if `dt` is not a holiday in the `calendar` calendar
  ]##
  raiseMethodNotImplemDefect()


template holidaysStmts[T: bdCalendar | bdCalendarId](calendar: T; 
           fromDate, toDate: DateTime; ignoreWeekend = false): untyped =
  doAssert: fromDate.timeZone == toDate.timeZone
  doAssert: fromDate <= toDate
  # limit case:  fromDate ==~ toDate
  if fromDate ==~ toDate:
    if calendar.isholiday(fromDate) and not (calendar.isweekend(fromDate) and ignoreWeekend):  
      return @[fromDate]
    else:
      return @[]
  # general case:  fromDate << toDate
  let maxNumDays = diffDays(toDate, fromDate) + 1  # int64
  result = newSeqOfCap[DateTime](maxNumDays)
  var dt = fromDate
  for i in 1..maxNumDays:
    if calendar.isholiday(dt) and not (calendar.isweekend(dt) and ignoreWeekend):  result.add(dt)
    dt = dt + 1.days


proc holidays*(calendar: bdCalendarId; fromDate, toDate: DateTime; ignoreWeekend = false): seq[DateTime] =
  ##[
  Returns the list of public holidays between `fromDate` and `toDate` (both included).
  
  If `ignoreWeekend` is `true`, public holidays falling on a weekend will be excluded from the list.

  **Assertions:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `fromDate.timeZone == toDate.timeZone`
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `fromDate <= toDate`
  ]##
  holidaysStmts(calendar, fromDate, toDate, ignoreWeekend)


method holidays*(calendar: bdCalendar; fromDate, toDate: DateTime; ignoreWeekend = false): seq[DateTime] {.base.} =
  ##[
  Returns the list of public holidays between `fromDate` and `toDate` (both included).

  **Default operating mode:**
    - See `holidays <#holidays,bdCalendarId,DateTime,DateTime>`_ `proc`.
  ]##
  holidaysStmts(calendar, fromDate, toDate, ignoreWeekend)


template holidays*[T: bdCalendar | bdCalendarId](calendar: T; year: int, month: Month; 
                                                 ignoreWeekend = false): seq[DateTime] = 
  ##[
  Returns the list of public holidays during the month defined by `<year>` and `<month>` parameters.

  **See also:**
    - `holidays <#holidays,bdCalendarId,DateTime,DateTime>`_ `proc`.
  ]##
  runnableExamples:
    # 2 holidays observed in January 2024 in the NYSE calendar
    doAssert: bdCalendarId.klndrUSNYSE.holidays(2024, mJan) == @[
      dateTime(2024, mJan, 1),   # New Year's day
      dateTime(2024, mJan, 15)]  # Birthday of Martin Luther King
  let fromDate = dateTime(year, month, 1)
  let toDate = dateTime(year, month, getDaysInMonth(month, year))
  calendar.holidays(fromDate, toDate, ignoreWeekend)


template holidays*[T: bdCalendar | bdCalendarId](calendar: T; year: int; ignoreWeekend = false): seq[DateTime] =
  ##[
  Returns the list of public holidays during the year `<year>`.

  **See also:**
    - `holidays <#holidays,bdCalendarId,DateTime,DateTime>`_ `proc`.
  ]##
  runnableExamples:
    # 10 holidays observed in 2025 in the NYSE calendar
    doAssert: bdCalendarId.klndrUSNYSE.holidays(2025) == @[
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
  let fromDate = dateTime(year, mJan, 1)
  let toDate = dateTime(year, mDec, 31)
  calendar.holidays(fromDate, toDate, ignoreWeekend)


proc isbday*(calendar: bdCalendarId, dt: DateTime): bool = 
  ##[
  **Returns:**
    - `true` if `dt` is a business day in the `calendar` calendar
    - `false` if `dt` is not a business day in the `calendar` calendar
  ]##
  runnableExamples:
    let calendar = bdCalendarId.klndrUSFederalGovt
    doAssert:  not calendar.isbday(dateTime(2015, mJan, 1))  # New Year's Day
    doAssert:  calendar.isbday(dateTime(2015, mJan, 2))  # Friday
  case calendar
    of klndrNoHolidayOrWeekend:  return true
    of klndrWeekendsOnlyInTheWest:  return not calendar.isweekend(dt)
    of klndrTARGET:  return dt.isbdayTARGET
    else:  return not (calendar.isweekend(dt) or calendar.isholiday(dt))


method isbday*(calendar: bdCalendar, dt: DateTime): bool {.base.} = 
  ##[
  **Returns:**
    - `true` if `dt` is a business day in the `calendar` calendar
    - `false` if `dt` is not a business day in the `calendar` calendar

  *Default implementation:* `not (calendar.isweekend(dt) or calendar.isholiday(dt))`.
  ]##
  not (calendar.isweekend(dt) or calendar.isholiday(dt))


proc info*[T: bdCalendar | bdCalendarId](calendar: T, dt: DateTime): string =
  ## Returns all known information about `dt`.
  runnableExamples:
    let calendar = bdCalendarId.klndrUSNYSE  # New York Stock Exchange (NYSE) calendar
    doAssert:  calendar.info(dateTime(2015, mJan, 1)) == "Thursday, January 1, 2015:  public holiday"
    doAssert:  calendar.info(dateTime(2022, mJan, 1)) == "Saturday, January 1, 2022:  weekend, public holiday"
    doAssert:  calendar.info(dateTime(2015, mJan, 2)) == "Friday, January 2, 2015:  business day"
    doAssert:  calendar.info(dateTime(2015, mJan, 3)) == "Saturday, January 3, 2015:  weekend"
  let isWE = calendar.isweekend(dt)
  let isHD = calendar.isholiday(dt)
  if isWE:  
    if isHD:  fmt"""{dt.format("dddd, MMMM d, yyyy")}:  weekend, public holiday"""
    else:  fmt"""{dt.format("dddd, MMMM d, yyyy")}:  weekend"""
  else:
    if isHD:  fmt"""{dt.format("dddd, MMMM d, yyyy")}:  public holiday"""
    else:  fmt"""{dt.format("dddd, MMMM d, yyyy")}:  business day"""


template nextbdayStmts[T: bdCalendar | bdCalendarId](calendar: T, dt: DateTime, forward = true, 
           searchIntervalLength = 60.Natural, startSearchOnDt = false): untyped = 
  doAssert: searchIntervalLength > 0
  if calendar.isbday(dt) and startSearchOnDt:  return some(dt)
  let oneDay = if forward: 1.days else: -1.days
  var dayToTest = dt
  for i in 1..searchIntervalLength:
    dayToTest = dayToTest + oneDay
    if calendar.isbday(dayToTest):  return some(dayToTest)
  return none(DateTime)


proc nextbday*(calendar: bdCalendarId, dt: DateTime, forward = true, 
               searchIntervalLength = 60.Natural, startSearchOnDt = false): ?DateTime = 
  ##[
  **Returns:**
    - The next business day looking forward (`forward` parameter
      is `true`) or looking back (`forward` parameter is `false`).
    - `some(dt)` if and only if `startSearchOnDt` 
      is `true` and `dt` is a business day. 
    - `none(DateTime)` if no business day was found.

  **Notes:**
    - As a precaution we impose a maximum length 
      (in calendar days) for the search interval 
      of the next business day (`searchIntervalLength` parameter).
    - If no business day was found in the above interval, 
      the result is `none(DateTime)`.
  
  **Assertion:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `searchIntervalLength > 0`
  ]##
  runnableExamples:
    let 
      calendar = bdCalendarId.klndrUSFederalGovt
      dt0 = dateTime(2014, mDec, 31)  # Wednesday
      dt1 = dateTime(2015, mJan, 2)  # Friday
      dt2 = dateTime(2015, mJan, 5)  # Monday  
      # January 1:  New Year's Day
      # January 3-4:  weekend
    doAssert:  !calendar.nextbday(dt0) ==~ dt1
    doAssert:  !calendar.nextbday(dt1) ==~ dt2
    doAssert:  !calendar.nextbday(dt1, forward = false) ==~ dt0
    doAssert:  !calendar.nextbday(dt1, forward = false, startSearchOnDt = true) ==~ dt1
  nextbdayStmts(calendar, dt, forward, searchIntervalLength, startSearchOnDt)


method nextbday*(calendar: bdCalendar, dt: DateTime, forward = true, 
                 searchIntervalLength = 60.Natural, startSearchOnDt = false): ?DateTime {.base.} = 
  ##[
  Returns the next business day looking forward (`forward` parameter
  is `true`) or looking back (`forward` parameter is `false`).

  **Default operating mode:**
    - See `nextbday <#nextbday,bdCalendarId,DateTime>`_ `proc`.
  ]##
  nextbdayStmts(calendar, dt, forward, searchIntervalLength, startSearchOnDt)


proc nextbday*(bizdays: seq[DateTime], dt: DateTime, forward = true,
               startSearchOnDt = false): ?DateTime = 
  ##[
  **Returns:**
    - The next business day looking forward (`forward` parameter
      is `true`) or looking back (`forward` parameter is `false`).
    - `some(dt)` if and only if `startSearchOnDt` 
      is `true` and `dt` is a business day. 
    - `none(DateTime)` if `dt < min(bizdays) or max(bizdays) < dt`.
    - `none(DateTime)` if no business day was found.
  
  **Assertions:**
    - `assert <https://nim-lang.org/docs/assertions.html#assert.t,untyped,string>`_:  
      the values in the `bizdays` sequence are in strictly ascending order.
      - `bizdays.isSortedUnique(cmpDate)`
  
  **See also:**
    - `cmpDate <dateutils.html#cmpDateNoZero,DateTime,DateTime>`_
  ]##

  runnableExamples:
    let
      calendar = bdCalendarId.klndrUSFederalGovt
      dt1 = dateTime(2015, mJan, 1)  # Thursday
      dt2 = dateTime(2015, mJan, 2)  # Friday
      dt3 = dateTime(2015, mJan, 3)  # Saturday
      #dt4 = dateTime(2015, mJan, 4) # Sunday  ('dt4' is not used here)
      dt5 = dateTime(2015, mJan, 5)  # Monday
      dt6 = dateTime(2015, mJan, 6)  # Tuesday
      bizdays = calendar.bdays(dt1, dt6)
    doAssert: bizdays == @[dt2, dt5, dt6]
    # dt1 < min(bizdays) = dt2  =>  the next working day after dt1 is unknown
    doAssert: bizdays.nextbday(dt1, startSearchOnDt = true).isNone
    doAssert: bizdays.nextbday(dt1, startSearchOnDt = false).isNone
    doAssert: !bizdays.nextbday(dt2, startSearchOnDt = true) ==~ dt2
    doAssert: !bizdays.nextbday(dt2, startSearchOnDt = false) ==~ dt5
    doAssert: !bizdays.nextbday(dt3, startSearchOnDt = true) ==~ dt5
    doAssert: !bizdays.nextbday(dt3, startSearchOnDt = false) ==~ dt5
    doAssert: !bizdays.nextbday(dt6, startSearchOnDt = true) ==~ dt6
    doAssert: bizdays.nextbday(dt6, startSearchOnDt = false).isNone

  assert: bizdays.isSortedUnique(cmpDate)
  
  # limit cases:  dt < min(bizdays)  or  max(bizdays) < dt
  if dt << bizdays[0]:  return none(DateTime)
  if bizdays[^1] << dt:  return none(DateTime)
  # from now on    min(bizdays) <= dt <= max(bizdays)
  let lowerIdx = bizdays.lowerBound(dt, cmpDate)
  let lowerVal = bizdays[lowerIdx]
  if forward:   # looking forward
    if dt !==~ lowerVal:  return some(lowerVal)
    if startSearchOnDt:  return some(dt)
    if lowerIdx < high(bizdays):  return some(bizdays[lowerIdx+1])
    return none(DateTime)
  else:   # looking back
    # It is necessary to distinguish 2 scenarios:
    # 1) 'dt' belongs to 'bizdays'     2) 'dt' does not belong to 'bizdays'
    if dt ==~ lowerVal:  # 1) 'dt' belongs to 'bizdays'
      if startSearchOnDt:  return some(dt)  # borderline case No1
      elif lowerIdx == 0:  return none(DateTime)  # borderline case No2
      # in all other cases, including when 'dt' does not belong to 'bizdays' 
      # result = bizdays[lowerIdx-1]
    return some(bizdays[lowerIdx-1])


template bdaysStmts[T: bdCalendar | bdCalendarId](calendar: T; fromDate, toDate: DateTime; 
                                                  fromDateIncl, toDateIncl: YesNo): untyped = 
  doAssert: fromDate.timeZone == toDate.timeZone
  doAssert: fromDate <<==~ toDate

  if fromDate ==~ toDate:  # case #1:  fromDate == toDate
    if fromDateIncl == ynNo or toDateIncl == ynNo:
      return @[]
    else:  # [fromDate; toDate] = {fromDate}
      if calendar.isbday(fromDate):
        return @[fromDate]
      else:
        return @[]

  # case #2:  fromDate != toDate
  # 'fromDate' and 'toDate' are recalculated depending on '<dateInterval>'
  let (fromDt, toDt) = block:
    var fromDt, toDt: DateTime
    if fromDateIncl == ynYes and toDateIncl == ynYes:
      fromDt = fromDate
      toDt = toDate
    elif fromDateIncl == ynNo and toDateIncl == ynNo:
      fromDt = fromDate + 1.days
      toDt = toDate - 1.days
    elif fromDateIncl == ynYes and toDateIncl == ynNo:
      fromDt = fromDate
      toDt = toDate - 1.days
    elif fromDateIncl == ynNo and toDateIncl == ynYes:
      fromDt = fromDate + 1.days
      toDt = toDate
    if fromDt >> toDt:
      return @[]  # limit case
    (fromDt, toDt)

  # search for business days one after the other
  let maxNumDays = diffDays(toDt, fromDt) + 1  # int64
  result = newSeqOfCap[DateTime](maxNumDays)
  var dt = fromDt
  for i in 1..maxNumDays:
    if calendar.isbday(dt):  result.add(dt)
    dt = dt + 1.days


proc bdays*(calendar: bdCalendarId; fromDate, toDate: DateTime; 
            fromDateIncl = ynYes, toDateIncl = ynYes): seq[DateTime] = 
  ##[
  Returns all business days between `fromDate` and `toDate`. 

  **Assertions:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `fromDate.timeZone == toDate.timeZone`
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `fromDate <= toDate`
    - `assert <https://nim-lang.org/docs/assertions.html#assert.t,untyped,string>`_:  
      the values in the `result` sequence are in strictly ascending order.
      - `result.isSortedUnique(cmpDate)`
  ]##
  runnableExamples:
    let 
      calendar = bdCalendarId.klndrUSFederalGovt
      dt0 = dateTime(2014, mDec, 31)  # Monday
      dt1 = dateTime(2015, mJan, 1)  # Thursday
      dt2 = dateTime(2015, mJan, 2)  # Friday
      # let dt3 = dateTime(2015, mJan, 3)  # Saturday  ('dt3' is not used here)
      dt4 = dateTime(2015, mJan, 4)  # Sunday
      dt5 = dateTime(2015, mJan, 5)  # Monday
      dt6 = dateTime(2015, mJan, 6)  # Tuesday
    doAssert:  calendar.bdays(dt1, dt1, ynYes, ynYes) == @[]
    doAssert:  calendar.bdays(dt1, dt2, ynYes, ynYes) == @[dt2]
    doAssert:  calendar.bdays(dt1, dt2, ynYes, ynNo) == @[]
    doAssert:  calendar.bdays(dt1, dt2, ynNo, ynYes) == @[dt2]
    doAssert:  calendar.bdays(dt1, dt4, ynYes, ynYes) == @[dt2]
    doAssert:  calendar.bdays(dt1, dt4, ynYes, ynNo) == @[dt2]
    doAssert:  calendar.bdays(dt1, dt4, ynNo, ynYes) == @[dt2]
    doAssert:  calendar.bdays(dt1, dt4, ynNo, ynNo) == @[dt2]
    doAssert:  calendar.bdays(dt2, dt2, ynYes, ynYes) == @[dt2]
    doAssert:  calendar.bdays(dt2, dt2, ynYes, ynNo) == @[]
    doAssert:  calendar.bdays(dt2, dt2, ynNo, ynYes) == @[]
    doAssert:  calendar.bdays(dt2, dt2, ynNo, ynNo) == @[]
    doAssert:  calendar.bdays(dt0, dt6, ynYes, ynYes) == @[dt0, dt2, dt5, dt6]
    doAssert:  calendar.bdays(dt0, dt6, ynNo, ynNo) == @[dt2, dt5]
    doAssert:  calendar.bdays(dt0, dt6, ynNo, ynYes) == @[dt2, dt5, dt6]
    doAssert:  calendar.bdays(dt0, dt6, ynYes, ynNo) == @[dt0, dt2, dt5]
  bdaysStmts(calendar, fromDate, toDate, fromDateIncl, toDateIncl)


method bdays*(calendar: bdCalendar; fromDate, toDate: DateTime; 
              fromDateIncl = ynYes, toDateIncl = ynYes): seq[DateTime] {.base.} = 
  ##[
  Returns all business days between `fromDate` and `toDate`.

  **Default operating mode:**
    - See `bdays <#bdays,bdCalendarId,DateTime,DateTime,BoundedInterval>`_ `proc`.
  ]##
  bdaysStmts(calendar, fromDate, toDate, fromDateIncl, toDateIncl)


proc bdays*(bizdays: seq[DateTime]; fromDate, toDate: DateTime;
            fromDateIncl = ynYes, toDateIncl = ynYes): seq[DateTime] = 
  ##[
  Returns all business days between `fromDate` and `toDate`.

  **Assertions:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `fromDate.timeZone == toDate.timeZone`
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `fromDate <= toDate`
    - `assert <https://nim-lang.org/docs/assertions.html#assert.t,untyped,string>`_:  
      the values in the `bizdays` and `result` sequences are in strictly ascending order.
      - `bizdays.isSortedUnique(cmpDate)`
      - `result.isSortedUnique(cmpDate)`
  ]##
  runnableExamples:
    let 
      calendar = bdCalendarId.klndrUSFederalGovt
      dt0 = dateTime(2014, mDec, 31)  # Monday
      dt1 = dateTime(2015, mJan, 1)  # Thursday
      dt2 = dateTime(2015, mJan, 2)  # Friday
      #dt3 = dateTime(2015, mJan, 3)  # Saturday  ('dt3' is not used here)
      dt4 = dateTime(2015, mJan, 4)  # Sunday
      dt5 = dateTime(2015, mJan, 5)  # Monday
      dt6 = dateTime(2015, mJan, 6)  # Tuesday
      bizdays = calendar.bdays(dt0, dt6, ynYes, ynYes)
    doAssert:  bizdays == @[dt0, dt2, dt5, dt6]
    doAssert:  bizdays.bdays(dt0, dt6, ynYes, ynYes) == bizdays
    doAssert:  bizdays.bdays(dt1, dt1, ynYes, ynYes) == @[]
    doAssert:  bizdays.bdays(dt1, dt2, ynYes, ynYes) == @[dt2]
    doAssert:  bizdays.bdays(dt1, dt2, ynYes, ynNo) == @[]
    doAssert:  bizdays.bdays(dt1, dt2, ynNo, ynYes) == @[dt2]
    doAssert:  bizdays.bdays(dt1, dt4, ynYes, ynYes) == @[dt2]
    doAssert:  bizdays.bdays(dt1, dt4, ynYes, ynNo) == @[dt2]
    doAssert:  bizdays.bdays(dt1, dt4, ynNo, ynYes) == @[dt2]
    doAssert:  bizdays.bdays(dt1, dt4, ynNo, ynNo) == @[dt2]
    doAssert:  bizdays.bdays(dt2, dt2, ynYes, ynYes) == @[dt2]
    doAssert:  bizdays.bdays(dt2, dt2, ynYes, ynNo) == @[]
    doAssert:  bizdays.bdays(dt2, dt2, ynNo, ynYes) == @[]
    doAssert:  bizdays.bdays(dt2, dt2, ynNo, ynNo) == @[]
    doAssert:  bizdays.bdays(dt0, dt6, ynYes, ynYes) == @[dt0, dt2, dt5, dt6]
    doAssert:  bizdays.bdays(dt0, dt6, ynNo, ynNo) == @[dt2, dt5]
    doAssert:  bizdays.bdays(dt0, dt6, ynNo, ynYes) == @[dt2, dt5, dt6]
    doAssert:  bizdays.bdays(dt0, dt6, ynYes, ynNo) == @[dt0, dt2, dt5]
  doAssert: fromDate.timeZone == toDate.timeZone
  doAssert: fromDate <<==~ toDate
  assert: bizdays.isSortedUnique(cmpDate)
  result = bizdays.between(fromDate, toDate, cmpDate, fromDateIncl, toDateIncl)
  assert: result.isSortedUnique(cmpDate)


template bdayStmts[T: bdCalendar | bdCalendarId](calendar: T, bdayConv: bdBusinessDayConvention, 
           dt: DateTime, startSearchOnDt = true, searchIntervalLength = 60.Natural): untyped =
  case bdayConv
    of bdcFollowing:
      return  calendar.nextbday(dt = dt, forward = true, startSearchOnDt = startSearchOnDt,  
                                searchIntervalLength = searchIntervalLength)
    of bdcPredecing:  
      return  calendar.nextbday(dt = dt, forward = false, startSearchOnDt = startSearchOnDt,  
                                searchIntervalLength = searchIntervalLength)
    of bdcModifFollowing:
      let tmpResult = calendar.nextbday(dt = dt, forward = true, startSearchOnDt = startSearchOnDt,  
                                        searchIntervalLength = searchIntervalLength)
      if tmpResult.isNone:  return none(DateTime)
      if get(tmpResult).month == dt.month:
        return  tmpResult
      else:  
          return calendar.nextbday(dt = get(tmpResult), forward = false, startSearchOnDt = false,
                                   searchIntervalLength = searchIntervalLength)
    of bdcModifFollowingFornight:
      let tmpResult = calendar.bday(bdcModifFollowing, dt, startSearchOnDt = startSearchOnDt,  
                                    searchIntervalLength = searchIntervalLength)
      if tmpResult.isNone:  return none(DateTime)
      if dt.monthday > 15:  return  tmpResult
      elif get(tmpResult).monthday > 15:
        return  calendar.bday(bdcPredecing, get(tmpResult), startSearchOnDt = false,
                              searchIntervalLength = searchIntervalLength)
      else:  return  none(DateTime)
    of bdcEndOfMonth:
      let lastDayOfMonth = getDaysInMonth(year = dt.year, month = dt.month)
      let tmpResult = dateTime(year = dt.year, month = dt.month, monthday = lastDayOfMonth)
      if calendar.isbday(tmpResult):
        return some(tmpResult)
      else:  
        return  calendar.bday(bdcPredecing, tmpResult, startSearchOnDt = false,
                              searchIntervalLength = searchIntervalLength)


proc bday*(calendar: bdCalendarId, bdayConv: bdBusinessDayConvention, 
           dt: DateTime, startSearchOnDt = true, 
           searchIntervalLength = 60.Natural): ?DateTime =
  ##[
  **Returns:**
    - The business day of the `calendar` calendar which is obtained by
      applying the calculation convention `bdayConv` to the date `dt`.
    - `some(dt)` if and only if `startSearchOnDt` 
      is `true` and `dt` is a business day. 
    - `none(DateTime)` if no business day was found.

  **Notes:**
    - As a precaution we impose a maximum length 
      (in calendar days) for the search interval 
      of the business day (`searchIntervalLength` parameter).
    - If no business day was found in the above interval, 
      the result is `none(DateTime)`.
  ]##
  runnableExamples:
    let calendar = bdCalendarId.klndrWeekendsOnlyInTheWest
  
    # Most of the examples below can be found in 
    # https://quant.opengamma.io/Interest-Rate-Instruments-and-Market-Conventions.pdf (p. 8)
    let dt1 = dateTime(2011, mSep, 18)  # Sunday
    let dt2 = dateTime(2011, mSep, 19)  # Monday
    let dt3 = dateTime(2011, mSep, 16)  # Friday
    doAssert: !calendar.bday(bdcFollowing, dt1) ==~ dt2
    doAssert: !calendar.bday(bdcPredecing, dt1) ==~ dt3

    let dt4 = dateTime(2011, mJul, 30)  # Saturday
    let dt5 = dateTime(2011, mAug, 1)   # Monday
    let dt6 = dateTime(2011, mJul, 29)  # Friday
    doAssert: !calendar.bday(bdcFollowing, dt4) ==~ dt5
    doAssert: !calendar.bday(bdcModifFollowing, dt4) ==~ dt6
    doAssert: !calendar.bday(bdcModifFollowingFornight, dt4) ==~ dt6

    let dt7 = dateTime(2011, mOct, 15)  # Saturday
    let dt8 = dateTime(2011, mOct, 17)  # Monday
    let dt9 = dateTime(2011, mOct, 14)  # Friday 
    doAssert: !calendar.bday(bdcFollowing, dt7) ==~ dt8
    doAssert: !calendar.bday(bdcModifFollowing, dt7) ==~ dt8
    doAssert: !calendar.bday(bdcModifFollowingFornight, dt7) ==~ dt9

    let dt10 = dateTime(2011, mMar, 28)  # Monday
    let dt11 = dateTime(2011, mMar, 31)  # Wednesday
    let dt12 = dateTime(2011, mApr, 29)  # Friday
    let dt13 = dateTime(2012, mMar, 28)  # Wednesday
    let dt14 = dateTime(2012, mMar, 30)  # Friday
    doAssert: !calendar.bday(bdcEndOfMonth, dt10) ==~ dt11
    doAssert: !calendar.bday(bdcEndOfMonth, dt12) ==~ dt12
    doAssert: !calendar.bday(bdcEndOfMonth, dt13) ==~ dt14
  bdayStmts(calendar, bdayConv, dt, startSearchOnDt, searchIntervalLength)


method bday*(calendar: bdCalendar, bdayConv: bdBusinessDayConvention, 
             dt: DateTime, startSearchOnDt = true, 
             searchIntervalLength = 60.Natural): ?DateTime {.base.} =
  ##[
  **Returns:**
    - The business day of the `calendar` calendar which is obtained by
      applying the calculation convention `bdayConv` to the date `dt`.
    - `some(dt)` if and only if `startSearchOnDt` 
      is `true` and `dt` is a business day. 
    - `none(DateTime)` if no business day was found.

  **Default operating mode:**
    - See `bday <#bday,bdCalendarId,bdBusinessDayConvention,DateTime>`_ `proc`.
  ]##
  bdayStmts(calendar, bdayConv, dt, startSearchOnDt, searchIntervalLength)


template addbdaysStmts[T: bdCalendar | bdCalendarId](calendar: T, 
           dt: DateTime, nbdays: int64, startCountOnDt = false): untyped = 
  doAssert: nbdays!=0
  let goAhead = (nbdays > 0)
  result = calendar.nextbday(dt = dt, forward = goAhead, startSearchOnDt = startCountOnDt)
  if isNone(result):  return none(DateTime)
  if abs(nbdays) == 1:  return result
  for count in 2..abs(nbdays):
    let tempDt = get(result)
    result = calendar.nextbday(dt = tempDt, forward = goAhead, startSearchOnDt = false)
    if isNone(result): return none(DateTime)
  return result


proc addbdays*(calendar: bdCalendarId, dt: DateTime, nbdays: int64, 
               startCountOnDt = false): ?DateTime = 
  ##[
  Adds a number of business days (`nbdays` parameter) to `dt`.

  **Assertion:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `nbdays != 0`
  ]##
  runnableExamples:
    let 
      calendar = bdCalendarId.klndrUSFederalGovt
      dt1 = dateTime(2015, mJan, 1)  # Thursday
      dt2 = dateTime(2015, mJan, 2)  # Friday
      dt3 = dateTime(2015, mJan, 3)  # Saturday
      dt4 = dateTime(2015, mJan, 4)  # Sunday
      dt5 = dateTime(2015, mJan, 5)  # Monday
      dt6 = dateTime(2015, mJan, 6)  # Tuesday
    # business days shifted forward
    doAssert:  !calendar.addbdays(dt1, 1) ==~ dt2
    doAssert:  !calendar.addbdays(dt1, 2) ==~ dt5
    doAssert:  !calendar.addbdays(dt1, 3) ==~ dt6
    doAssert:  !calendar.addbdays(dt3, 1) ==~ dt5
    doAssert:  !calendar.addbdays(dt4, 1) ==~ dt5
    # business days shifted backward
    doAssert:  !calendar.addbdays(dt6, -1, true) ==~ dt6
    doAssert:  !calendar.addbdays(dt6, -1, false) ==~ dt5
    doAssert:  !calendar.addbdays(dt6, -2, true) ==~ dt5
    doAssert:  !calendar.addbdays(dt6, -2, false) ==~ dt2
  addbdaysStmts(calendar, dt, nbdays, startCountOnDt)


method addbdays*(calendar: bdCalendar, dt: DateTime, nbdays: int64, 
                 startCountOnDt = false): ?DateTime {.base.} = 
  ##[
  **Returns:**
    - The business day of the `calendar` calendar which is obtained by
      applying the calculation convention `bdayConv` to the date `dt`.
    - `some(dt)` if and only if `startSearchOnDt` 
      is `true` and `dt` is a business day. 
    - `none(DateTime)` if no business day was found.

  **Default operating mode:**
    - See `addbdays <#addbdays,bdCalendarId,DateTime,int64>`_ `proc`.
  ]##
  addbdaysStmts(calendar, dt, nbdays, startCountOnDt)


func addbdays*(bizdays: seq[DateTime], dt: DateTime, 
               nbdays: int64, startCountOnDt = false): ?DateTime = 
  ##[
  Adds a number of business days (`nbdays` parameter) to `dt`.

  **Assertions:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `nbdays != 0`
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      at least one of the conditions below is satisfied:
      - `min(bizdays) < dt < max(bizdays)` 
      - `dt = min(bizdays)` and `nbdays > 0`
      - `dt = max(bizdays)` and `nbdays < 0`
    - `assert <https://nim-lang.org/docs/assertions.html#assert.t,untyped,string>`_:  
      the values in the `bizdays` sequence are in strictly ascending order.
      - `bizdays.isSortedUnique(cmpDate)`
  ]##

  runnableExamples:
    let
      calendar = bdCalendarId.klndrUSFederalGovt
      dt1 = dateTime(2015, mJan, 1)  # Thursday
      dt2 = dateTime(2015, mJan, 2)  # Friday
      dt3 = dateTime(2015, mJan, 3)  # Saturday
      dt4 = dateTime(2015, mJan, 4)  # Sunday
      dt5 = dateTime(2015, mJan, 5)  # Monday
      dt6 = dateTime(2015, mJan, 6)  # Tuesday
      bizdays = calendar.bdays(dt1, dt6)
    doAssert: bizdays == @[dt2, dt5, dt6]
    # business days shifted forward
    doAssert: !bizdays.addbdays(dt2, 1, true) ==~ dt2
    doAssert: !bizdays.addbdays(dt2, 1, false) ==~ dt5
    doAssert: !bizdays.addbdays(dt2, 2, false) ==~ dt6
    doAssert: !bizdays.addbdays(dt3, 1, true) ==~ dt5
    doAssert: !bizdays.addbdays(dt3, 1, false) ==~ dt5
    doAssert: !bizdays.addbdays(dt3, 2, false) ==~ dt6
    doAssert: bizdays.addbdays(dt3, 3).isNone
    # business days shifted backward
    doAssert: !bizdays.addbdays(dt6, -1, true) ==~ dt6
    doAssert: !bizdays.addbdays(dt6, -1, false) ==~ dt5
    doAssert: !bizdays.addbdays(dt6, -2, false) ==~ dt2
    doAssert: !bizdays.addbdays(dt4, -1, true) ==~ dt2
    doAssert: bizdays.addbdays(dt4, -2, true).isNone

  doAssert: nbdays!=0
  doAssert:  (cmpDate(bizdays[0], dt) < 0 and cmpDate(dt, bizdays[^1]) < 0)  or 
    (cmpDate(bizdays[0], dt) == 0 and nbdays > 0) or
    (cmpDate(dt, bizdays[^1]) == 0 and nbdays < 0)
  assert: bizdays.isSortedUnique(cmpDate)

  let lowerIdx = bizdays.lowerBound(dt, cmpDate)
  let lowerVal = bizdays[lowerIdx]
  let lowerIdxAdjustment = block:
    var lowerIdxAdjustment: int64
    if nbdays > 0 and cmpDate(dt, lowerVal) < 0:  lowerIdxAdjustment = -1
    if nbdays > 0 and cmpDate(dt, lowerVal) == 0 and startCountOnDt:  lowerIdxAdjustment = -1
    if nbdays > 0 and cmpDate(dt, lowerVal) == 0 and not startCountOnDt:  lowerIdxAdjustment = 0
    if nbdays < 0 and cmpDate(dt, lowerVal) < 0:  lowerIdxAdjustment = 0
    if nbdays < 0 and cmpDate(dt, lowerVal) == 0 and startCountOnDt:  lowerIdxAdjustment = 1
    if nbdays < 0 and cmpDate(dt, lowerVal) == 0 and not startCountOnDt:  lowerIdxAdjustment = 0
    lowerIdxAdjustment
  let idx = lowerIdx + lowerIdxAdjustment + nbdays
  if 0 <= idx and idx < bizdays.len:  return some(bizdays[idx])
  else:  return none(DateTime)
