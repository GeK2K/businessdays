# ==================     holiday(int,bdHoliday,TimeZone)     ================= #

proc  holiday*(year: int, holiday: bdHoliday, zone: TimeZone = local()): 
              ?DateTime =
  ##[
  Returns the holiday corresponding to the `<year>` and `<holiday>` parameters.

  **Postconditions:**
    - `result.zone = zone`
  ]##

  #[
  runnableExamples:
    doAssert:  !holiday(2016, hdayNewYearsDay) ~== dateTime(2016, mJan, 1)
    doAssert:  !holiday(2022, hdayUSNewYearsDayObs) ~== dateTime(2021, mDec, 31)
    doAssert:  !holiday(2003, hdayUSThanksgivingDay) ~== dateTime(2003, mNov, 27)
    doAssert:  !holiday(1901, hdayLabourDay) ~== dateTime(1901, mMay, 1)
  ]#

  if holiday is bdHoliday:
    case holiday.bdHoliday
      of hdayNewYearsDay:  result = holidayNewYearsDay(year, zone).some
      of hdayChristmasDay:  result = holidayChristmasDay(year, zone).some
      of hdayLabourDay:  result = holidayLabourDay(year, zone).some
      of hdayBoxingDay:  result = holidayBoxingDay(year, zone).some
      of hdayDecember31:  result = holidayDecember31(year, zone).some
      of hdayUSNewYearsDayObs:  result = holidayUSNewYearsDayObs(year, zone).some
      of hdayUSNYSENewYearsDayObs:  result = holidayUSNYSENewYearsDayObs(year, zone).some
      of hdayUSChristmasDayObs:  result = holidayUSChristmasDayObs(year, zone).some
      of hdayUSJuneteenthIndependenceDay:  result = holidayUSJuneteenthIndependenceDay(year, zone).some
      of hdayUSJuneteenthIndependenceDayObs:  result = holidayUSJuneteenthIndependenceDayObs(year, zone).some
      of hdayUSIndependenceDay:  result = holidayUSIndependenceDay(year, zone).some
      of hdayUSIndependenceDayObs:  result = holidayUSIndependenceDayObs(year, zone).some
      of hdayUSVeteransDay:  result = holidayUSVeteransDay(year, zone).some
      of hdayUSVeteransDayObs:  result = holidayUSVeteransDayObs(year, zone).some
      of hdayUSInaugurationDay:  result = holidayUSInaugurationDay(year, zone)
      of hdayUSInaugurationDayObs:  result = holidayUSInaugurationDayObs(year, zone)
      of hdayUSMartinLutherKingBirthday:  result = holidayUSMartinLutherKingBirthday(year, zone).some
      of hdayUSWashingtonBirthday:  result = holidayUSWashingtonBirthday(year, zone).some
      of hdayUSMemorialDay:  result = holidayUSMemorialDay(year, zone).some
      of hdayUSLaborDay:  result = holidayUSLaborDay(year, zone).some
      of hdayUSColumbusDay:  result = holidayUSColumbusDay(year, zone).some
      of hdayUSThanksgivingDay:  result = holidayUSThanksgivingDay(year, zone).some
      of hdayUSNYSEElectionDay:  result = holidayUSNYSEElectionDay(year, zone).some
      of hdayEasterMonday, hdayEasterSunday, hdayGoodFriday,
           hdayAscension, hdayWhitSunday, hdayWhitMonday:
        let easterNCo = gregorianEasterSundayNCo(year, zone = zone)
        if easterNCo.len == 0:  result = none(DateTime)
        else:  result = easterNCo[holiday.bdHolidayEasterNCo].some


proc  isholiday*(dt: DateTime, holidays: set[bdHoliday]): bool =
  ##[
  Tests if `dt` is one of the holidays listed in the `holidays` parameter.
  ]##
  for holiday in holidays:
    if holiday =? holiday(dt.year, holiday, dt.timeZone) and dt ~== holiday:
      return true
    # New Year's Day is a special case 
    elif holiday == hdayUSNewYearsDayObs and 
        holiday =? holiday(dt.year+1, holiday, dt.timeZone) and dt ~== holiday:  
      return true
  return false  


template  isholiday*(dt: DateTime, holiday: bdHoliday): bool =
  ##[ 
  Shortcut for `dt.isholiday({holiday})`.

  **See also:**
    - `isholiday <#isholiday,DateTime,set[bdHoliday]>`_
  ]##
  dt.isholiday({holiday})
  
  
# ===================     Public holidays: Easter & Co     =================== #

proc  holidayEasterSunday*(year: int, zone: TimeZone = local()): ?DateTime =
  ##[ 
  Returns the *Easter Sunday* day
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayEasterSunday(2018) ~== dateTime(2018, mApr, 1)
    doAssert:  !holiday(2018, hdayEasterSunday) ~== dateTime(2018, mApr, 1)
  result = holiday(year, hdayEasterSunday, zone) 


proc  holidayEasterMonday*(year: int, zone: TimeZone = local()): ?DateTime =
  ##[ 
  Returns the *Easter Monday* 
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayEasterMonday(2018) ~== dateTime(2018, mApr, 2)
    doAssert:  !holiday(2018, hdayEasterMonday) ~== dateTime(2018, mApr, 2)
  result = holiday(year, hdayEasterMonday, zone) 


proc  holidayGoodFriday*(year: int, zone: TimeZone = local()): ?DateTime =
  ##[ 
  Returns the *Good Friday* 
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayGoodFriday(2018) ~== dateTime(2018, mMar, 30)
    doAssert:  !holiday(2018, hdayGoodFriday) ~== dateTime(2018, mMar, 30)
  result = holiday(year, hdayGoodFriday, zone) 


proc  holidayAscension*(year: int, zone: TimeZone = local()): ?DateTime =
  ##[ 
  Returns the *Ascension* day
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayAscension(2018) ~== dateTime(2018, mMay, 10)
    doAssert:  !holiday(2018, hdayAscension) ~== dateTime(2018, mMay, 10)
  result = holiday(year, hdayAscension, zone) 


proc  holidayWhitMonday*(year: int, zone: TimeZone = local()): ?DateTime =
  ##[ 
  Returns the *Whit Monday*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayWhitMonday(2018) ~== dateTime(2018, mMay, 21)
    doAssert:  !holiday(2018, hdayWhitMonday) ~== dateTime(2018, mMay, 21)
  result = holiday(year, hdayWhitMonday, zone) 


proc  holidayWhitSunday*(year: int, zone: TimeZone = local()): ?DateTime =
  ##[ 
  Returns the *Whit Sunday*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayWhitSunday(2018) ~== dateTime(2018, mMay, 20)
    doAssert:  !holiday(2018, hdayWhitSunday) ~== dateTime(2018, mMay, 20)
  result = holiday(year, hdayWhitSunday, zone)
