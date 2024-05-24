proc  isweekendTARGETCalendar*(dt: DateTime): ?bool = 
  ##[
  **Returns:**
    - `none(bool)` if `dt.year < 1999` (the TARGET calendar came into force in 1999)
    - `some(true)` if `dt` is a Saturday or a Sunday
    - `some(false)` if `dt` is not a Saturday or a Sunday

  **See also:**
    - `isholidayTARGETCalendar <#isholidayTARGETCalendar,DateTime>`_
  ]##
  if dt.year < 1999:  return none(bool)
  else:  return isSaturdayOrSunday(dt).some

 

proc  isholidayTARGETCalendar*(dt: DateTime): ?bool = 
  ##[
  **Returns:**
    - `none(bool)` if `dt.year < 1999` (the TARGET calendar came into force in 1999)
    - `some(true)` if `dt` is a holiday in the TARGET calendar
    - `some(false)` if `dt` is not a holiday in the TARGET calendar

  **Business days and holidays:**

    In the TARGET calendar **all days are operating days except**:
    - Saturdays and Sundays (since 1999)
    - New Year's Day, January 1st (since 1999)
    - Christmas Day, December 25th (since 1999)
    - Good Friday (since 2000)
    - Easter Monday (since 2000)
    - Labour Day, May 1st (since 2000)
    - Boxing Day, December 26th (since 2000)
    - December 31st (1999, 2001)

  **References:**
    - https://www.ecb.europa.eu/press/pr/date/1999/html/pr990715_1.en.html
    - https://www.ecb.europa.eu/press/pr/date/2000/html/pr000525_2.en.html
    - https://www.ecb.europa.eu/press/pr/date/2000/html/pr001214_4.en.html
  ]##
  if dt.year < 1999:  return none(bool)
  # 1. New Year's Day, January 1st (since 1999)
  # 2. Christmas Day, December 25th (since 1999)
  # 3. December 31st (1999, 2001)
  # 4. Labour Day, May 1st (since 2000)
  # 5. Boxing Day, December 26th (since 2000)
  # 6. Good Friday (since 2000)  and  Easter Monday (since 2000)
  if dt.isholiday(hdayNewYearsDay):  return some(true)
  if dt.isholiday(hdayChristmasDay):  return some(true)
  if dt.isholiday(hdayDecember31):  return some(dt.year == 1999 or dt.year == 2001)
  if dt.isholiday(hdayLabourDay):  return some((dt.year >= 2000))
  if dt.isholiday(hdayBoxingDay):  return some((dt.year >= 2000))
  if dt.isholiday(holidays = {hdayEasterMonday, hdayGoodFriday}):
    return some((dt.year >= 2000))
  return some(false)
