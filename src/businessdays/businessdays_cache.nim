##[
==================
businessdays_cache
==================
Routines for working with precalculated business days.
]##


# =========================     Imports / Exports     ======================== #

import  std/[algorithm, sequtils]
import  calendars
import  ./private/[commonmath, nudates]
export  calendars, commonmath, nudates


# ===============================     Procs     ============================== #

proc  bdays*(bizdays: seq[DateTime]; fromDate, toDate: DateTime;
             dateInterval: BoundedRealInterval): seq[DateTime] = 
  ##[
  Returns all business days between `fromDate` and `toDate`.
  
  **Notes:**
    - The `dateInterval` parameter allows you to include/exclude `<fromDate>`
      and `<toDate>` from the result (if they are business days). 

  **Assertions:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `fromDate.timeZone == toDate.timeZone`
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `fromDate <= toDate`
    - `assert <https://nim-lang.org/docs/assertions.html#assert.t,untyped,string>`_:  
      the values in the `bizdays` and `result` sequences are in strictly ascending order.
      - `bizdays.isSorted(cmpDateNoZero)`
      - `result.isSorted(cmpDateNoZero)`
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

    let bizdays = calendar.bdays(dt0, dt6, BoundedClosed)
    doAssert: bizdays == @[dt0, dt2, dt5, dt6]
    doAssert: bizdays.bdays(dt0, dt6, BoundedClosed) == bizdays
    doAssert: bizdays.bdays(dt1, dt1, BoundedClosed) == @[]
    doAssert: bizdays.bdays(dt1, dt2, BoundedClosed) == @[dt2]
    doAssert: bizdays.bdays(dt1, dt2, BoundedRightOpen) == @[]
    doAssert: bizdays.bdays(dt1, dt2, BoundedLeftOpen) == @[dt2]
    doAssert: bizdays.bdays(dt1, dt4, BoundedClosed) == @[dt2]
    doAssert: bizdays.bdays(dt1, dt4, BoundedRightOpen) == @[dt2]
    doAssert: bizdays.bdays(dt1, dt4, BoundedLeftOpen) == @[dt2]
    doAssert: bizdays.bdays(dt1, dt4, BoundedOpen) == @[dt2]
    doAssert: bizdays.bdays(dt2, dt2, BoundedClosed) == @[dt2]
    doAssert: bizdays.bdays(dt2, dt2, BoundedRightOpen) == @[]
    doAssert: bizdays.bdays(dt2, dt2, BoundedLeftOpen) == @[]
    doAssert: bizdays.bdays(dt2, dt2, BoundedOpen) == @[]
    doAssert: bizdays.bdays(dt0, dt6, BoundedClosed) == @[dt0, dt2, dt5, dt6]
    doAssert: bizdays.bdays(dt0, dt6, BoundedOpen) == @[dt2, dt5]
    doAssert: bizdays.bdays(dt0, dt6, BoundedLeftOpen) == @[dt2, dt5, dt6]
    doAssert: bizdays.bdays(dt0, dt6, BoundedRightOpen) == @[dt0, dt2, dt5]

  doAssert: fromDate.timeZone == toDate.timeZone
  doAssert: fromDate <<= toDate
  assert: bizdays.isSorted(cmpDateNoZero)
  result = bizdays.intersection(fromDate, toDate, dateInterval, cmpDate)
  assert: result.isSorted(cmpDateNoZero)


proc  nextbday*(bizdays: seq[DateTime], dt: DateTime, forward = true,
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
      - `bizdays.isSorted(cmpDateNoZero)`
  
  **See also:**
    - `cmpDate <dateutils.html#cmpDateNoZero,DateTime,DateTime>`_
  ]##

  runnableExamples:
    let dt1 = dateTime(2015, mJan, 1)  # Thursday
    let dt2 = dateTime(2015, mJan, 2)  # Friday
    let dt3 = dateTime(2015, mJan, 3)  # Saturday
    # let dt4 = dateTime(2015, mJan, 4)  # Sunday  ('dt4' is not used here)
    let dt5 = dateTime(2015, mJan, 5)  # Monday
    let dt6 = dateTime(2015, mJan, 6)  # Tuesday
  
    let calendar = newCalendarUSFederalGovt()
    let bizdays = calendar.bdays(dt1, dt6, BoundedClosed)

    doAssert: bizdays == @[dt2, dt5, dt6]
    # dt1 < min(dizdays) = dt2  =>  the next working day after dt1 is unknown
    doAssert: bizdays.nextbday(dt1, startSearchOnDt = true).isNone
    doAssert: bizdays.nextbday(dt1, startSearchOnDt = false).isNone
    doAssert: !bizdays.nextbday(dt2, startSearchOnDt = true) === dt2
    doAssert: !bizdays.nextbday(dt2, startSearchOnDt = false) === dt5
    doAssert: !bizdays.nextbday(dt3, startSearchOnDt = true) === dt5
    doAssert: !bizdays.nextbday(dt3, startSearchOnDt = false) === dt5
    doAssert: !bizdays.nextbday(dt6, startSearchOnDt = true) === dt6
    doAssert: bizdays.nextbday(dt6, startSearchOnDt = false).isNone

  assert: bizdays.isSorted(cmpDateNoZero)
  
  # limit cases:  dt < min(bizdays)  or  max(bizdays) < dt
  if cmpDate(dt, bizdays[0]) < 0:   return none(DateTime)
  if cmpDate(bizdays[^1], dt) < 0:  return none(DateTime)
  # from now on    min(bizdays) <= dt <= max(bizdays)
  let lowerIdx = bizdays.lowerBound(dt, cmpDate)
  let lowerVal = bizdays[lowerIdx]
  if forward:   # looking forward
    if cmpDate(dt, lowerVal) != 0:  return some(lowerVal)
    if startSearchOnDt:  return some(dt)
    if lowerIdx < high(bizdays):  return some(bizdays[lowerIdx+1])
    return none(DateTime)
  else:   # looking back
    # It is necessary to distinguish 2 scenarios:
    # 1) 'dt' belongs to 'bizdays'     2) 'dt' does not belong to 'bizdays'
    if cmpDate(dt, lowerVal) == 0:  # 1) 'dt' belongs to 'bizdays'
      if startSearchOnDt:  return some(dt)  # borderline case No1
      elif lowerIdx == 0:  return none(DateTime)  # borderline case No2
      # in all other cases, including when 'dt' does not belong to 'bizdays' 
      # result = bizdays[lowerIdx-1]
    return some(bizdays[lowerIdx-1])


func  addbdays*(bizdays: seq[DateTime], dt: DateTime, 
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
      - `bizdays.isSorted(cmpDateNoZero)`
  ]##

  runnableExamples:
    let dt1 = dateTime(2015, mJan, 1)  # Thursday
    let dt2 = dateTime(2015, mJan, 2)  # Friday
    let dt3 = dateTime(2015, mJan, 3)  # Saturday
    let dt4 = dateTime(2015, mJan, 4)  # Sunday
    let dt5 = dateTime(2015, mJan, 5)  # Monday
    let dt6 = dateTime(2015, mJan, 6)  # Tuesday
  
    let calendar = newCalendarUSFederalGovt()

    let bizdays = calendar.bdays(dt1, dt6, BoundedClosed)
    doAssert: bizdays == @[dt2, dt5, dt6]
    
    # business days shifted forward
    doAssert: !bizdays.addbdays(dt2, 1, true) === dt2
    doAssert: !bizdays.addbdays(dt2, 1, false) === dt5
    doAssert: !bizdays.addbdays(dt2, 2, false) === dt6
    doAssert: !bizdays.addbdays(dt3, 1, true) === dt5
    doAssert: !bizdays.addbdays(dt3, 1, false) === dt5
    doAssert: !bizdays.addbdays(dt3, 2, false) === dt6
    doAssert: bizdays.addbdays(dt3, 3).isNone
    # business days shifted backward
    doAssert: !bizdays.addbdays(dt6, -1, true) === dt6
    doAssert: !bizdays.addbdays(dt6, -1, false) === dt5
    doAssert: !bizdays.addbdays(dt6, -2, false) === dt2
    doAssert: !bizdays.addbdays(dt4, -1, true) === dt2
    doAssert: bizdays.addbdays(dt4, -2, true).isNone

  doAssert: nbdays!=0
  doAssert:  (cmpDate(bizdays[0], dt) < 0 and cmpDate(dt, bizdays[^1]) < 0)  or 
    (cmpDate(bizdays[0], dt) == 0 and nbdays > 0) or
    (cmpDate(dt, bizdays[^1]) == 0 and nbdays < 0)
  assert: bizdays.isSorted(cmpDateNoZero)

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