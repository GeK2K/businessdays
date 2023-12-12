##[
=======
nudates
=======
Some useful tools when working with dates 
(the suffix `nu` stands for `Nim utils`).

The user is encouraged to browse the documentation 
for an overview of the available features.


`questionable` module
---------------------

To shorten certain parts of the code we have often favored the syntax 
of the `questionable` module over the syntax of the `options` module. 
Basic examples:
  - `?T` instead of `Option[T]`
  - `!x` instead of `get(x)`
]##


# =========================     Imports / Exports     ======================== #

import  std/[options, times], questionable
export  options, times, questionable


# ===========================     MonthMonthday     ========================== #

type 
  MonthMonthday* = tuple[month: Month, monthday: MonthdayRange]
    ##[
    Special dates that do not change from year 
    to year can be represented using this type. 
     
    **Examples:**
      - `(month: mJan, monthday: 1.MonthdayRange)` for *New Year's Day, January 1st*.
      - `(month: mMay, monthday: 1.MonthdayRange)` for *Labour Day, May 1st*.
      - `(month: mDec, monthday: 25.MonthdayRange)` for *Christmas Day, December 25th*.
     
    **Notes:**

      No validity check is performed when creating `MonthMonthday` type objects.
      So objects like `(month: mFeb, monthday: 30.MonthdayRange)` or 
      `(month: mApr, monthday: 31.MonthdayRange)` can be created (!).
    ]##


# =========================     Date comparisons     ========================= #

proc  cmpDate*(dt1, dt2: MonthMonthday): int = 
  ## Compares `dt1` and `dt2`.

  runnableExamples:
    let dt1 = (month: mMay, monthday: 15.MonthdayRange)
    let dt2 = (month: mMay, monthday: 20.MonthdayRange)
    let dt3 = (month: mOct, monthday: 5.MonthdayRange)

    doAssert:  dt1.cmpDate(dt1) ==  0   
    doAssert:  dt1.cmpDate(dt2) == -1
    doAssert:  dt2.cmpDate(dt1) ==  1
    doAssert:  dt2.cmpDate(dt3) == -1
    doAssert:  dt3.cmpDate(dt2) ==  1

  if  dt1.month.ord < dt2.month.ord:  return -1
  elif  dt1.month.ord > dt2.month.ord:  return 1
  # From now on:  dt1.month.ord == dt2.month.ord
  elif dt1.monthday < dt2.monthday:  return  -1
  elif dt1.monthday > dt2.monthday:  return 1
  # From now on:  dt1.monthday == dt2.monthday
  else:  return 0


proc  cmpDate*(dt1, dt2: DateTime): int = 
  ##[
  Compares `dt1` and `dt2` ignoring intraday information 
  (hours, minutes, seconds, etc.).

  **Assertions:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `dt1.timeZone == dt2.timeZone`
  ]##

  runnableExamples:
    let dt1 = dateTime(2011, mSep, 18, 2)  # 2011-09-18T:02:00:00
    let dt2 = dateTime(2011, mSep, 18, 5)  # 2011-09-18T:05:00:00
    let dt3 = dateTime(2011, mOct, 18, 1)  # 2011-10-18T:01:00:00

    doAssert:  dt1 == dt1  and  dt1.cmpDate(dt1) ==  0
    doAssert:  dt1 != dt2  and  dt1.cmpDate(dt2) ==  0
    doAssert:  dt1  < dt3  and  dt1.cmpDate(dt3) == -1
    doAssert:  dt3  > dt1  and  dt3.cmpDate(dt1) ==  1

  doAssert: dt1.timeZone == dt2.timeZone
  if (dt1.year, dt1.month.ord, dt1.monthday) == 
       (dt2.year, dt2.month.ord, dt2.monthday):  return 0
  elif  dt1 < dt2:  return -1
  else:  return 1


proc  cmpDate*(dt1: DateTime, dt2: MonthMonthday): int {.inline.} = 
  ##[ 
  Compares `dt1` and `dt2` ignoring `dt1.year` and
  intraday information (hours, minutes, seconds, etc.).

  **Implementation:**
    ```nim
    (month: dt1.month, monthday: dt1.monthday).cmpDate(dt2)
    ```

  **See also:**
    - `cmpDate <#cmpDate,MonthMonthday,MonthMonthday>`_
  ]##
  (month: dt1.month, monthday: dt1.monthday).cmpDate(dt2)


proc  cmpDateStrict*(dt1, dt2: DateTime): int = 
  ##[
  **Returns:**
    - `-1` if `dt1.cmpDate(dt2) == -1`
    - `1` else

  **Notes:**

    With this routine equality between two dates is excluded. It 
    may be surprising but this can for example help to differentiate 
    between sequences of increasing dates (`dt1 <= dt2`) and sequences 
    of strictly increasing dates (`dt1 < dt2`).

  **Assertions:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `dt1.timeZone == dt2.timeZone`

  **See also:**
    - `cmpDate <#cmpDate,DateTime,DateTime>`_
  ]##

  runnableExamples:
    let dt1 = dateTime(2011, mSep, 18, 2)  # 2011-09-18T:02:00:00
    let dt2 = dateTime(2011, mSep, 18, 5)  # 2011-09-18T:05:00:00
    let dt3 = dateTime(2011, mOct, 18, 1)  # 2011-10-18T:01:00:00

    doAssert:  dt1 == dt1  and  dt1.cmpDate(dt1) ==  0  and  dt1.cmpDateStrict(dt1) ==  1
    doAssert:  dt1 != dt2  and  dt1.cmpDate(dt2) ==  0  and  dt1.cmpDateStrict(dt2) ==  1
    doAssert:  dt1  < dt3  and  dt1.cmpDate(dt3) == -1  and  dt1.cmpDateStrict(dt3) == -1
    doAssert:  dt3  > dt1  and  dt3.cmpDate(dt1) ==  1  and  dt3.cmpDateStrict(dt1) ==  1


    let oa1 = [dt2, dt3]  # ascending and strictly ascending array
    let oa2 = [dt2, dt2, dt3]  # ascending (but not strictly ascending) array

    import algorithm
    doAssert:  oa1.isSorted(cmpDate)
    doAssert:  oa1.isSorted(cmpDateStrict)
    doAssert:  oa2.isSorted(cmpDate)
    doAssert:  not oa2.isSorted(cmpDateStrict)  # duplicates

  doAssert: dt1.timeZone == dt2.timeZone
  result = if dt1.cmpDate(dt2) == -1: -1  else: 1


# shortcuts for  `dt1.cmpDate(dt2) == 0`
template  `==`*(dt1: DateTime | MonthMonthday, dt2: MonthMonthday): untyped =
  ## A shortcut for `dt1.cmpDate(dt2) == 0`.
  dt1.cmpDate(dt2) == 0

template  `==~`*(dt1, dt2: DateTime): untyped = dt1.cmpDate(dt2) == 0
  ## A shortcut for `dt1.cmpDate(dt2) == 0`.

template  `!=~`*(dt1, dt2: DateTime): untyped = dt1.cmpDate(dt2) != 0
  ## A shortcut for `dt1.cmpDate(dt2) != 0`.

# shortcuts for  `dt1.cmpDate(dt2) == -1`
template  `<`*(dt1: DateTime | MonthMonthday, dt2: MonthMonthday): untyped =
  ## A shortcut for `dt1.cmpDate(dt2) == -1`.
  dt1.cmpDate(dt2) == -1

template  `<~`*(dt1, dt2: DateTime): untyped = dt1.cmpDate(dt2) == -1
  ## A shortcut for `dt1.cmpDate(dt2) == -1`.

# shortcuts for  `dt1.cmpDate(dt2) == 1`
template  `>`*(dt1: DateTime | MonthMonthday, dt2: MonthMonthday): untyped =
  ## A shortcut for `dt1.cmpDate(dt2) == 1`.
  dt1.cmpDate(dt2) == 1

template  `>~`*(dt1, dt2: DateTime): untyped = dt1.cmpDate(dt2) == 1
  ## A shortcut for `dt1.cmpDate(dt2) == 1`.

# shortcuts for  `dt1.cmpDate(dt2) <= 0`
template  `<=`*(dt1: DateTime | MonthMonthday, dt2: MonthMonthday): untyped =
  ## A shortcut for `dt1.cmpDate(dt2) <= 0`.
  dt1.cmpDate(dt2) <= 0

template  `<=~`*(dt1, dt2: DateTime): untyped = dt1.cmpDate(dt2) <= 0
  ## A shortcut for `dt1.cmpDate(dt2) <= 0`.

# shortcuts for  `dt1.cmpDate(dt2) >= 0`
template  `>=`*(dt1: DateTime | MonthMonthday, dt2: MonthMonthday): untyped =
  ## A shortcut for `dt1.cmpDate(dt2) >= 0`.
  dt1.cmpDate(dt2) >= 0

template  `>=~`*(dt1, dt2: DateTime): untyped = dt1.cmpDate(dt2) >= 0
  ## A shortcut for `dt1.cmpDate(dt2) >= 0`.


# ==============================     Useful     ============================== #

func  isLastDayOfFebruary*(dt: DateTime): bool =
  ## Tests if `dt` is the last day of Frebruary.

  runnableExamples:
    let dt1 = dateTime(2023, mFeb, 28)
    let dt2 = dateTime(2024, mFeb, 28)
    let dt3 = dateTime(2024, mFeb, 29)

    doAssert:  dt1.isLastDayOfFebruary
    doAssert:  not dt2.isLastDayOfFebruary
    doAssert:  dt3.isLastDayOfFebruary

  if dt.month != mFeb:  return false
  elif dt.year.isLeapYear:  return (dt.monthday == 29)
  else:  return (dt.monthday == 28)


proc  getDayOfWeek*(dt: DateTime): WeekDay {.inline.} =
  ## Returns the day of the week of `dt`.
  getDayOfWeek(year = dt.year, month = dt.month, monthday = dt.monthday)


proc  isSaturdayOrSunday*(dt: DateTime): bool {.inline.} =
  ## Tests if `dt` is a Saturday or a Sunday.
  getDayOfWeek(dt) in {dSat, dSun}


func  searchMonthday*(year: int, month: Month, weekday: Weekday, 
                      nthOccurrence: int): ?MonthdayRange =
  ##[ 
  **Returns:** 
    - The n-th occurence of `<weekday>` in the month  
      that is defined by parameters `month` and `year`.
    - `none(MonthdayRange)` if the search is unsuccessful.

  **Notes:**
    - If `nthOccurrence > 0` then counting is performed from the beginning of the month.
    - If `nthOccurrence < 0` then counting is performed from the end of the month.
  
  **Assertions:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `0 < abs(nthOccurrence) < 6`
  ]##
  
  runnableExamples:
    # search from the beginning of the month
    doAssert:  !searchMonthday(2023, mAug, dMon, 1) == 7.MonthdayRange
    doAssert:  !searchMonthday(2023, mAug, dMon, 3) == 21.MonthdayRange
    doAssert:  searchMonthday(2023, mAug, dMon, 5).isNone
    doAssert:  !searchMonthday(2023, mAug, dTue, 5) == 29.MonthdayRange
    # search from the end of the month
    doAssert:  !searchMonthday(2023, mAug, dMon, -1) == 28.MonthdayRange
    doAssert:  !searchMonthday(2023, mAug, dMon, -3) == 14.MonthdayRange
    doAssert:  searchMonthday(2023, mAug, dMon, -5).isNone
    doAssert:  !searchMonthday(2023, mAug, dWed, -1) == 30.MonthdayRange
    doAssert:  !searchMonthday(2023, mAug, dThu, -5) == 3.MonthdayRange
    doAssert:  !searchMonthday(2023, mAug, dSat, -1) == 26.MonthdayRange
    doAssert:  !searchMonthday(2023, mAug, dSat, -3) == 12.MonthdayRange

  doAssert: nthOccurrence != 0 and abs(nthOccurrence) < 6

  let weekday1st = getDayOfWeek(1.MonthdayRange, month, year)
  let daysInMonth = getDaysInMonth(month, year)
  let weekdayLast = getDayOfWeek(daysInMonth.MonthdayRange, month, year)

  if nthOccurrence > 0:  # counting from the beginning of the month
    let deltaWeekday = weekday.ord - weekday1st.ord
    let monthday = block:
      if deltaWeekday >= 0:  deltaWeekday + 7 * (nthOccurrence - 1) + 1
      else:  deltaWeekday + 7 * nthOccurrence + 1
    if 1 <= monthday and monthday <= daysInMonth:  
      result = some(monthday.MonthdayRange)
    else:  
      result = none(MonthdayRange)
  else:  # counting from the end of the month
    let deltaWeekday = weekdayLast.ord - weekday.ord 
    let monthday = block:
      if deltaWeekday >= 0:  daysInMonth - deltaWeekday - 7 * (-nthOccurrence - 1)
      else:  daysInMonth - deltaWeekday - 7 * -nthOccurrence
    if 1 <= monthday and monthday <= daysInMonth:  
      result = some(monthday.MonthdayRange)
    else:  
      result = none(MonthdayRange)
