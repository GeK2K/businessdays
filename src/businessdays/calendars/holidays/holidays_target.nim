##[
===============
holidays_target
===============

Public holidays in the TARGET calendar.
]##

# =========================     Imports / Exports     ======================== #

import  questionable, nimutils/[nutimes], ./private/[easter_days]
export  questionable, nutimes


# ===========================     Special dates     ========================== #

# New Year’s Day, January 1st
let NewYearsDay = newMonthMonthday(mJan, 1)

# Labour Day, May 1st
let LabourDay = newMonthMonthday(mMay, 1)

# Christmas Day, December 25th
let ChristmasDay = newMonthMonthday(mDec, 25)

# Boxing Day, December 26th
let BoxingDay = newMonthMonthday(mDec, 26)


# ====================     isholiday  &  isbday  procs     =================== #

proc isholidayTARGET*(dt: DateTime): bool =
  ##[
  **Returns:**
    - `true` if `dt` is a holiday in the TARGET calendar
    - `false` if `dt` is not a holiday in the TARGET calendar

  **Business days and holidays:**
 
    In the TARGET calendar *all days are business days except*:
    - Saturdays and Sundays (weekends)
    - New Year's Day, January 1st (since 1999)
    - Good Friday (since 2000)
    - Easter Monday (since 2000)
    - Labour Day, May 1st (since 2000)
    - Christmas Day, December 25th (since 1999)
    - Boxing Day, December 26th (since 2000)
    - December 31st (1999 and 2001)

  **References:**
    - https://www.ecb.europa.eu/press/pr/date/1999/html/pr990715_1.en.html
    - https://www.ecb.europa.eu/press/pr/date/2000/html/pr000525_2.en.html
    - https://www.ecb.europa.eu/press/pr/date/2000/html/pr001214_4.en.html
  ]##
  runnableExamples:
    doAssert:  isholidayTARGET(dateTime(2024, mJan, 1)) # New Year's Day
    doAssert:  isholidayTARGET(dateTime(2024, mMar, 29)) # Good Friday
    doAssert:  isholidayTARGET(dateTime(2024, mApr, 1)) # Easter Monday
    doAssert:  isholidayTARGET(dateTime(2024, mMay, 1)) # Labour Day
    doAssert:  isholidayTARGET(dateTime(2024, mDec, 25)) # Christmas Day
    doAssert:  isholidayTARGET(dateTime(2024, mDec, 26)) # Boxing Day
  let yy = dt.year
  if yy < 1999:  return false  # the TARGET calendar came into force in 1999
  let mm = dt.month
  let tz = dt.timezone
  case mm
    of mJan..mMay:
      if dt ==~ NewYearsDay:  return true
      if dt ==~ LabourDay and yy > 1999:  return true
      if hday =? holidayGoodFriday(year = yy, zone = tz) and dt ==~ hday and yy > 1999:  return true
      if hday =? holidayEasterMonday(year = yy, zone = tz) and dt ==~ hday and yy > 1999:  return true
    of mJun..mNov:
      return false
    of mDec:
      if dt ==~ ChristmasDay:  return true
      if dt ==~ BoxingDay and yy > 1999:  return true
      if (yy == 1999 or yy == 2001) and dt.monthday == 31:  return true
  return false


proc isbdayTARGET*(dt: DateTime): bool =
  ##[
  **Returns:**
    - `true` if `dt` is a business day in the TARGET calendar
    - `false` if `dt` is not a business day in the TARGET calendar

  **See also:**
    - `isholidayTARGET <#isholidayTARGET,DateTime>`_
  ]##
  if dt.year < 1999:  return false  # the TARGET calendar came into force in 1999
  if dt.getDayOfWeek in {dSat,dSun}:  return false  # weekend
  return not dt.isholidayTARGET
