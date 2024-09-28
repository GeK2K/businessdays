proc  holiday*(year: int, holiday: bdHoliday, hour: HourRange = 0, 
               minute: MinuteRange = 0, second: SecondRange = 0, 
               nanosecond: NanosecondRange = 0, zone: TimeZone = local()): ?DateTime =
  ## Returns the holiday corresponding to the `<year>` and `<holiday>` parameters.
  runnableExamples:
    doAssert:  !holiday(2022, hdayUSNewYearsDay) ==~ dateTime(2021, mDec, 31)
    doAssert:  !holiday(2020, hdayTargetBoxingDay) ==~ dateTime(2020, mDec, 26)
    doAssert:  !holiday(2019, hdayGBEarlyMay) ==~ dateTime(2019, mMay, 6)
  case holiday.bdHoliday
    # Easter and Co
    of hdayEasterMonday, hdayEasterSunday, hdayGoodFriday,
         hdayAscension, hdayWhitSunday, hdayWhitMonday:
      let easterNCo = holidayEasterNCo(year, hour, minute, second, nanosecond, zone)
      if easterNCo.len == 0:  result = none(DateTime)
      else:  result = easterNCo[holiday].some
    # TARGET calendar
    of hdayTargetNewYearsDay: 
      result = holidayTargetNewYearsDay(year, hour, minute, second, nanosecond, zone)
    of hdayTargetLabourDay:
      result = holidayTargetLabourDay(year, hour, minute, second, nanosecond, zone)
    of hdayTargetChristmasDay:
      result = holidayTargetChristmasDay(year, hour, minute, second, nanosecond, zone)
    of hdayTargetBoxingDay:
      result = holidayTargetBoxingDay(year, hour, minute, second, nanosecond, zone)
    of hdayTargetDecember31:
      result = holidayTargetDecember31(year, hour, minute, second, nanosecond, zone)
    # US
    of hdayUSNewYearsDay:
      result = holidayUSNewYearsDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSNYSENewYearsDay:
      result = holidayUSNYSENewYearsDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSJuneteenthIndependenceDay:
      result = holidayUSJuneteenthIndependenceDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSIndependenceDay:
      result = holidayUSIndependenceDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSChristmasDay:
      result = holidayUSChristmasDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSVeteransDay:
      result = holidayUSVeteransDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSMartinLutherKingBirthday:
      result = holidayUSMartinLutherKingBirthday(year, hour, minute, second, nanosecond, zone)
    of hdayUSWashingtonBirthday:
      result = holidayUSWashingtonBirthday(year, hour, minute, second, nanosecond, zone)
    of hdayUSMemorialDay:
      result = holidayUSMemorialDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSLaborDay:
      result = holidayUSLaborDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSColumbusDay:
      result = holidayUSColumbusDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSThanksgivingDay:
      result = holidayUSThanksgivingDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSNYSEElectionDay:
      result = holidayUSNYSEElectionDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSInaugurationDay:
      result = holidayUSInaugurationDay(year, hour, minute, second, nanosecond, zone)
    # GB
    of hdayGBNewYearsDay:
      result = holidayGBNewYearsDay(year, hour, minute, second, nanosecond, zone)
    of hdayGBSctJanuary2:
      result = holidayGBSctJanuary2(year, hour, minute, second, nanosecond, zone)
    of hdayGBNirStPatricksDay:
      result = holidayGBNirStPatricksDay(year, hour, minute, second, nanosecond, zone)
    of hdayGBEarlyMay:
      result = holidayGBEarlyMay(year, hour, minute, second, nanosecond, zone)
    of hdayGBSpring:
      result = holidayGBSpring(year, hour, minute, second, nanosecond, zone)
    of hdayGBSctOrangemensDay:
      result = holidayGBSctOrangemensDay(year, hour, minute, second, nanosecond, zone)
    of hdayGBEngNirWlsSummer:
      result = holidayGBEngNirWlsSummer(year, hour, minute, second, nanosecond, zone)
    of hdayGBSctSummer:
      result = holidayGBSctSummer(year, hour, minute, second, nanosecond, zone)
    of hdayGBSctStAndrewsDay:
      result = holidayGBSctStAndrewsDay(year, hour, minute, second, nanosecond, zone)
    of hdayGBChristmasDay:
      result = holidayGBChristmasDay(year, hour, minute, second, nanosecond, zone)
    of hdayGBBoxingDay:
      result = holidayGBBoxingDay(year, hour, minute, second, nanosecond, zone)


proc  isholiday*(dt: DateTime, holidays: set[bdHoliday]): bool =
  ## Tests if `dt` is one of the holidays listed in the `holidays` parameter.
  runnableExamples:
    doAssert:  dateTime(2018, mMay, 20).isholiday({hdayWhitSunday, hdayUSNewYearsDay})
    doAssert:  not dateTime(2018, mMay, 20).isholiday({hdayUSNewYearsDay, hdayUSChristmasDay})
  for holiday in holidays:
    if holiday =? holiday(year = dt.year, holiday = holiday, zone = dt.timeZone) and 
       dt ==~ holiday:
      return true
    # New Year's Day is a special case 
    elif holiday == hdayUSNewYearsDay and 
         holiday =? holiday(year = dt.year+1, holiday = holiday, zone = dt.timeZone) and 
         dt ==~ holiday:  
      return true
  return false  


template  isholiday*(dt: DateTime, holiday: bdHoliday): bool =
  ##[ 
  Shortcut for `dt.isholiday({holiday})`.

  **See also:**
    - `isholiday <#isholiday,DateTime,set[bdHoliday]>`_
  ]##
  dt.isholiday({holiday})