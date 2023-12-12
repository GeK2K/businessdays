# =====================     Business day conventions     ===================== #

type
  qtBusinessDayConvention* = enum
    ## Business day conventions. Precise definitions and examples can be found here:
    ##
    ## - https://quant.opengamma.io/Interest-Rate-Instruments-and-Market-Conventions.pdf (p. 8)
    bdcFollowing = "next business day"
    bdcPredecing = "previous business day" 
    bdcModifFollowing = "modified next business day"
    bdcModifFollowingFornight = "next business day modified fornightly"
    bdcEndOfMonth = "business day at end of month"


# ===================     qtCalendar  (abstract class)     =================== #

type
  qtCalendar* {.inheritable.} = ref object
    ## In our computer modeling, calendars are objects of this type.


method  `$`*(calendar: qtCalendar): string  {.base.} =
  ## Returns a string representation of `calendar`.
  raise newMethodWoImplemDefect()


method  isweekend*(calendar: qtCalendar, dt: DateTime): ?bool  {.base.} = 
  ##[
  **Returns:**
    - `some(true)` if `dt` is a weekend in the `calendar` calendar.
    - `some(false)` if `dt` is not a weekend in the `calendar` calendar.
    - `none(bool)` if the system cannot answer the question.
  ]##
  raise newMethodWoImplemDefect()


method  isholiday*(calendar: qtCalendar, dt: DateTime): ?bool  {.base.} = 
  ##[
  **Returns:**
    - `some(true)` if `dt` is a holiday in the `calendar` calendar.
    - `some(false)` if `dt` is not a holiday in the `calendar` calendar.
    - `none(bool)` if the system cannot answer the question.
  ]##
  raise newMethodWoImplemDefect()


method  isbday*(calendar: qtCalendar, dt: DateTime): ?bool  {.base.} = 
  ##[
  **Returns:**
    - `some(true)` if `dt` is a business day in the `calendar` calendar.
    - `some(false)` if `dt` is not a business day in the `calendar` calendar.
    - `none(bool)` if the system cannot answer the question.
  
  **Implementation:**
    ```nim
    if dtIsholiday =? calendar.isholiday(dt) and dtIsweekend =? calendar.isweekend(dt):
        result = some(not (dtIsholiday or dtIsweekend))
    ```
  ]## 
  if dtIsholiday =? calendar.isholiday(dt) and dtIsweekend =? calendar.isweekend(dt):
    result = some(not (dtIsholiday or dtIsweekend))


method  info*(calendar: qtCalendar, dt: DateTime): string  {.base.} = 
  ## Returns all known information about `dt` as a string. 

  runnableExamples:
    let calendar = newCalendarUSNYSE()  # New York Stock Exchange (NYSE) calendar
    doAssert: calendar.info(dateTime(2015, mJan, 4)) == 
      "Sunday, January 4, 2015:  not a business day, not a holiday, weekend"

  let bDay = block:
    if isBDay =? calendar.isbday(dt):  (if isBDay:  "business day"  else:  "not a business day")
    else:  "business day?"
  let hDay = block:
    if isHDay =? calendar.isholiday(dt):  (if isHDay:  "holiday"  else:  "not a holiday")
    else:  "holiday?"
  let we = block:
    if isWE =? calendar.isweekend(dt):  (if isWE:  "weekend"  else:  "not a weekend")
    else:  "weekend?"
  result = fmt"""{dt.format("dddd, MMMM d, yyyy")}:  {bDay}, {hDay}, {we}"""


method  nextbday*(calendar: qtCalendar, dt: DateTime, forward = true, 
                  searchIntervalLength = 60.Natural, 
                  startSearchOnDt = false): ?DateTime {.base.} = 
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
    let dt1 = dateTime(2015, mJan, 1)  # Thursday - New Year's Day
    let dt2 = dateTime(2015, mJan, 2)  # Friday
    let dt3 = dateTime(2015, mJan, 3)  # Saturday
    let dt4 = dateTime(2015, mJan, 4)  # Sunday
    let dt5 = dateTime(2015, mJan, 5)  # Monday
    let dt6 = dateTime(2015, mJan, 6)  # Tuesday
  
    let calendar = newCalendarUSFederalGovt()

    doAssert: not !calendar.isbday(dt1)
    doAssert: !calendar.nextbday(dt1, startSearchOnDt = true) ==~ dt2
    doAssert: !calendar.nextbday(dt1, startSearchOnDt = false) ==~ dt2
    doAssert: !calendar.nextbday(dt2, startSearchOnDt = true) ==~ dt2
    doAssert: !calendar.nextbday(dt2, startSearchOnDt = false) ==~ dt5
    doAssert: !calendar.nextbday(dt3, startSearchOnDt = true) ==~ dt5
    doAssert: !calendar.nextbday(dt3, startSearchOnDt = false) ==~ dt5
    doAssert: !calendar.nextbday(dt4, startSearchOnDt = false) ==~ dt5
    doAssert: !calendar.nextbday(dt5, startSearchOnDt = false) ==~ dt6

  doAssert: searchIntervalLength > 0
  if dtIsBday =? calendar.isbday(dt) and dtIsBday and startSearchOnDt:  
    return some(dt)
  let oneDay = if forward: 1.days else: -1.days
  var dayToTest = dt
  for i in 1..searchIntervalLength:
    dayToTest = dayToTest + oneDay
    if dayToTestIsBday =? calendar.isbday(dayToTest) and dayToTestIsBday:  
      return some(dayToTest)
  return none(DateTime)


method  bdays*(calendar: qtCalendar; fromDate, toDate: DateTime; 
               dateInterval: BoundedRealInterval): seq[DateTime] {.base.} = 
  ##[
  Returns all business days between `fromDate` and `toDate`.
  
  **Notes:**
    - The `dateInterval` parameter allows you to include/exclude `<fromDate>`
      or `<toDate>` from the result (if they are business days). 

  **Assertions:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `fromDate.timeZone == toDate.timeZone`
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `fromDate <= toDate`
    - `assert <https://nim-lang.org/docs/assertions.html#assert.t,untyped,string>`_:  
      the values in the `result` sequence are in strictly ascending order.
      - `result.isSorted(cmpDateStrict)`
  ]##

  runnableExamples:
    let dt0 = dateTime(2014, mDec, 31)  # Monday
    let dt1 = dateTime(2015, mJan, 1)  # Thursday
    let dt2 = dateTime(2015, mJan, 2)  # Friday
    # let dt3 = dateTime(2015, mJan, 3)  # Saturday  ('dt3' is not used here)
    let dt4 = dateTime(2015, mJan, 4)  # Sunday
    let dt5 = dateTime(2015, mJan, 5)  # Monday
    let dt6 = dateTime(2015, mJan, 6)  # Tuesday
  
    let calendar = newCalendarUSFederalGovt()

    doAssert: calendar.bdays(dt1, dt1, BoundedClosed) == @[]
    doAssert: calendar.bdays(dt1, dt2, BoundedClosed) == @[dt2]
    doAssert: calendar.bdays(dt1, dt2, BoundedRightOpen) == @[]
    doAssert: calendar.bdays(dt1, dt2, BoundedLeftOpen) == @[dt2]
    doAssert: calendar.bdays(dt1, dt4, BoundedClosed) == @[dt2]
    doAssert: calendar.bdays(dt1, dt4, BoundedRightOpen) == @[dt2]
    doAssert: calendar.bdays(dt1, dt4, BoundedLeftOpen) == @[dt2]
    doAssert: calendar.bdays(dt1, dt4, BoundedOpen) == @[dt2]
    doAssert: calendar.bdays(dt2, dt2, BoundedClosed) == @[dt2]
    doAssert: calendar.bdays(dt2, dt2, BoundedRightOpen) == @[]
    doAssert: calendar.bdays(dt2, dt2, BoundedLeftOpen) == @[]
    doAssert: calendar.bdays(dt2, dt2, BoundedOpen) == @[]
    doAssert: calendar.bdays(dt0, dt6, BoundedClosed) == @[dt0, dt2, dt5, dt6]
    doAssert: calendar.bdays(dt0, dt6, BoundedOpen) == @[dt2, dt5]
    doAssert: calendar.bdays(dt0, dt6, BoundedLeftOpen) == @[dt2, dt5, dt6]
    doAssert: calendar.bdays(dt0, dt6, BoundedRightOpen) == @[dt0, dt2, dt5]

  doAssert: fromDate.timeZone == toDate.timeZone
  doAssert: fromDate <=~ toDate

  if fromDate ==~ toDate:  # case #1:  fromDate == toDate
    case dateInterval:
      of BoundedOpen, BoundedRightOpen, BoundedLeftOpen, 
          BoundedLeftClosed, BoundedRightClosed:  return @[]
      of BoundedClosed:  # [fromDate; toDate] = {fromDate}
        if fromDateIsBDay =? calendar.isbday(fromDate) and fromDateIsBDay:  return @[fromDate]
        else:  return @[]

  # case #2:  fromDate != toDate
  # 'fromDate' and 'toDate' are recalculated depending on '<dateInterval>'
  let (fromDt, toDt) = block:
    var (fromDt, toDt) =
      case dateInterval:
        of BoundedClosed:  (fromDate, toDate)
        of BoundedOpen:  (fromDate+1.days, toDate-1.days)
        of BoundedRightOpen, BoundedLeftClosed:  (fromDate, toDate-1.days)
        of BoundedLeftOpen, BoundedRightClosed:  (fromDate+1.days, toDate)
    # if `fromDt > toDt`, the result is empty
    if fromDt >~ toDt:  return @[]
    (fromDt, toDt)

  # search for business days one after the other
  let maxNumDays = (toDt-fromDt).inDays + 1  # int64
  result = newSeqOfCap[DateTime](maxNumDays)
  var dt = fromDt
  while true:
    if dt >~ toDt:  
      assert: result.isSorted(cmpDateStrict)
      return result
    if dtIsBDay =? calendar.isbday(dt) and dtIsBDay:  result.add(dt)
    dt = dt + 1.days


method  bday*(calendar: qtCalendar,
              bdayConv: qtBusinessDayConvention,
              dt: DateTime,
              startSearchOnDt = true,
              searchIntervalLength = 60.Natural): 
             ?DateTime {.base.} =
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
    let calendar = newCalendarWeekendsOnly()
  
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

  case bdayConv
    of bdcFollowing:
      return  calendar.nextbday(dt = dt, forward = true, 
                                startSearchOnDt = startSearchOnDt,  
                                searchIntervalLength = searchIntervalLength)
    of bdcPredecing:  
      return  calendar.nextbday(dt = dt, forward = false, 
                                startSearchOnDt = startSearchOnDt,  
                                searchIntervalLength = searchIntervalLength)
    of bdcModifFollowing:
      if tmpResult =? calendar.nextbday(dt = dt, forward = true, 
                                        startSearchOnDt = startSearchOnDt,  
                                        searchIntervalLength = searchIntervalLength):
        if tmpResult.month == dt.month:  return  some(tmpResult)
        else:  return calendar.nextbday(dt = tmpResult, forward = false, 
                                        startSearchOnDt = false,
                                        searchIntervalLength = searchIntervalLength)
      else:  return  none(DateTime)
    of bdcModifFollowingFornight:
      if tmpResult =? calendar.bday(bdcModifFollowing, dt, 
                                    startSearchOnDt = startSearchOnDt,  
                                    searchIntervalLength = searchIntervalLength):
        if dt.monthday > 15:  return  some(tmpResult)
        elif tmpResult.monthday > 15:
          return  calendar.bday(bdcPredecing, tmpResult, 
                                startSearchOnDt = false,
                                searchIntervalLength = searchIntervalLength)
      else:  return  none(DateTime)
    of bdcEndOfMonth:
      let lastDayOfMonth = getDaysInMonth(year = dt.year, month = dt.month)
      let tmpResult = dateTime(year = dt.year, month = dt.month, monthday = lastDayOfMonth)
      if tmpResultIsBDay =? calendar.isbday(tmpResult) and tmpResultIsBDay:
        return some(tmpResult)
      else:  
        return  calendar.bday(bdcPredecing, tmpResult, startSearchOnDt = false,
                              searchIntervalLength = searchIntervalLength)


method  addbdays*(calendar: qtCalendar, dt: DateTime, nbdays: int64, 
                  startCountOnDt = false): ?DateTime {.base.} = 
  ##[
  Adds a number of business days (`nbdays` parameter) to `dt`.

  **Assertion:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `nbdays != 0`
  ]##

  runnableExamples:
    let dt1 = dateTime(2015, mJan, 1)  # Thursday
    let dt2 = dateTime(2015, mJan, 2)  # Friday
    let dt3 = dateTime(2015, mJan, 3)  # Saturday
    let dt4 = dateTime(2015, mJan, 4)  # Sunday
    let dt5 = dateTime(2015, mJan, 5)  # Monday
    let dt6 = dateTime(2015, mJan, 6)  # Tuesday
  
    let calendar = newCalendarUSFederalGovt()

    # business days shifted forward
    doAssert: !calendar.addbdays(dt1, 1) ==~ dt2
    doAssert: !calendar.addbdays(dt1, 2) ==~ dt5
    doAssert: !calendar.addbdays(dt1, 3) ==~ dt6
    doAssert: !calendar.addbdays(dt3, 1) ==~ dt5
    doAssert: !calendar.addbdays(dt4, 1) ==~ dt5
    # business days shifted backward
    doAssert: !calendar.addbdays(dt6, -1, true) ==~ dt6
    doAssert: !calendar.addbdays(dt6, -1, false) ==~ dt5
    doAssert: !calendar.addbdays(dt6, -2, true) ==~ dt5
    doAssert: !calendar.addbdays(dt6, -2, false) ==~ dt2

  doAssert: nbdays!=0
  let goAhead = (nbdays > 0)
  var tmpResult = calendar.nextbday(dt = dt, forward = goAhead, 
                                    startSearchOnDt = startCountOnDt)
  if isNone(tmpResult):  return none(DateTime)
  if abs(nbdays) == 1:  return tmpResult
  for count in 2..abs(nbdays):
    let tempDt = get(tmpResult)
    tmpResult = calendar.nextbday(dt = tempDt, forward = goAhead, 
                                  startSearchOnDt = false)
    if isNone(tmpResult): return none(DateTime)
  return tmpResult


method  observedHolidays*(calendar: qtCalendar; fromDate, toDate: DateTime): 
                         seq[DateTime] {.base.} = 
  ##[
  Observed public holidays between `fromDate` and `toDate` (both included).

  **Assertions:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `fromDate.timeZone == toDate.timeZone`
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `fromDate <= toDate`
  ]##

  doAssert: fromDate.timeZone == toDate.timeZone
  doAssert: fromDate <= toDate

  let bdays = calendar.bdays(fromDate, toDate, BoundedClosed)
  if bdays.len == 0:  return @[]
  var dt = fromDate
  while true:
    if dt >~ toDate:  return result
    if dtIsWE =? calendar.isweekend(dt) and not dtIsWE and dt notin bdays:
      result.add(dt) 
    dt = dt + 1.days


method  observedHolidays*(calendar: qtCalendar; year: int, month: Month): 
                         seq[DateTime] {.base.} = 
  ##[
  Observed public holidays during the month 
  defined by `<year>` and `<month>` parameters.
  
  **See also:**
    - `observedHolidays <calendars.html#observedHolidays.e%2CqtCalendar%2CDateTime%2CDateTime>`_
  ]##

  runnableExamples:
    let calendar = newCalendarUSNYSE()  # New York Stock Exchange (NYSE) calendar
    # 2 public holidays observed in January 2024
    let obsHolidays2024January = calendar.observedHolidays(2024, mJan)
    doAssert: obsHolidays2024January == @[
      dateTime(2024, mJan, 1),   # New Year's day
      dateTime(2024, mJan, 15)]  # Birthday of Martin Luther King

  let fromDate = dateTime(year, month, 1)
  let toDate = dateTime(year, month, getDaysInMonth(month, year))
  result = calendar.observedHolidays(fromDate, toDate)


method  observedHolidays*(calendar: qtCalendar; year: int): 
                         seq[DateTime] {.base.} = 
  ##[
  Observed public holidays during the year `<year>`.
  
  **See also:**
    - `observedHolidays <calendars.html#observedHolidays.e%2CqtCalendar%2CDateTime%2CDateTime>`_
  ]##
  
  runnableExamples:
    let calendar = newCalendarUSNYSE()  # New York Stock Exchange (NYSE) calendar
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
  
  let fromDate = dateTime(year, mJan, 1)
  let toDate = dateTime(year, mDec, 31)
  result = calendar.observedHolidays(fromDate, toDate)
