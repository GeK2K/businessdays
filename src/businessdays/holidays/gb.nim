# New Year’s Day (January 1st) observed in GB
defineProcHolidayXXXByAdjustingMmdParam(NewYearsDay, holidayGBNewYearsDay, nextMondayIfWeekend):
  runnableExamples:
    # The New Year’s Day observed in Great Britain is calculated as follow:
    #  - Monday, January 2, if January 1 is a Sunday
    #  - Monday, January 3, if January 1 is a Saturday
    #  - January 1, in all other cases
    # The date of this public holiday can be obtained in two different but equivalent ways.
    doAssert:  !holidayGBNewYearsDay(2023) ==~ dateTime(2023, mJan, 2)  # Monday
    doAssert:  !holidayGBNewYearsDay(2022) ==~ dateTime(2022, mJan, 3)  # Monday
    doAssert:  !holidayGBNewYearsDay(2021) ==~ dateTime(2021, mJan, 1)  # Friday
    doAssert:  !holiday(2023, hdayGBNewYearsDay) ==~ dateTime(2023, mJan, 2)  # Monday
    doAssert:  !holiday(2022, hdayGBNewYearsDay) ==~ dateTime(2022, mJan, 3)  # Monday
    doAssert:  !holiday(2021, hdayGBNewYearsDay) ==~ dateTime(2021, mJan, 1)  # Friday


# January 2 in Scotland
proc  holidayGBSctJanuary2*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                            second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                            zone: Timezone = local()): ?DateTime =
  ##[ 
  Returns the *first weekday after New Year's Day holiday* of the year received in parameter.
  ]##  
  runnableExamples:
    # The date of this public holiday can be obtained in two different but equivalent ways.
    doAssert:  !holidayGBSctJanuary2(2020) ==~ dateTime(2020, mJan, 2)  # Thursday
    doAssert:  !holidayGBSctJanuary2(2021) ==~ dateTime(2021, mJan, 4)  # Monday
    doAssert:  !holidayGBSctJanuary2(2022) ==~ dateTime(2022, mJan, 4)  # Tuesday
    doAssert:  !holiday(2020, hdayGBSctJanuary2) ==~ dateTime(2020, mJan, 2)  # Thursday
    doAssert:  !holiday(2021, hdayGBSctJanuary2) ==~ dateTime(2021, mJan, 4)  # Monday
    doAssert:  !holiday(2022, hdayGBSctJanuary2) ==~ dateTime(2022, mJan, 4)  # Tuesday
  result = holidayGBNewYearsDay(year, hour, minute, second, nanosecond, zone).?nextWeekday


# Saint Patrick’s Day (March 17) observed in Northern Ireland
defineProcHolidayXXXByAdjustingMmdParam(StPatricksDay, holidayGBNirStPatricksDay, nextMondayIfWeekend):
  runnableExamples:
    # The Saint Patrick’s Day observed in Northen Ireland is calculated as follow:
    #  - Monday, March 18, if March 17 is a Sunday
    #  - Monday, March 19, if March 17 is a Saturday
    #  - March 17, in all other cases
    # The date of this public holiday can be obtained in two different but equivalent ways.
    doAssert:  !holidayGBNirStPatricksDay(2019) ==~ dateTime(2019, mMar, 18)  # Monday
    doAssert:  !holidayGBNirStPatricksDay(2018) ==~ dateTime(2018, mMar, 19)  # Monday
    doAssert:  !holidayGBNirStPatricksDay(2020) ==~ dateTime(2020, mMar, 17)  # Tuesday
    doAssert:  !holiday(2019, hdayGBNirStPatricksDay) ==~ dateTime(2019, mMar, 18)  # Monday
    doAssert:  !holiday(2018, hdayGBNirStPatricksDay) ==~ dateTime(2018, mMar, 19)  # Monday
    doAssert:  !holiday(2020, hdayGBNirStPatricksDay) ==~ dateTime(2020, mMar, 17)  # Tuesday


# Early May bank holiday, 1st Monday in May
proc  holidayGBEarlyMay*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                        second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                        zone: Timezone = local()): ?DateTime =
  ##[
  The 'Early May bank holiday (1st Monday in May)' of the year received 
  as a parameter can be obtained in two distinct but equivalent ways.
  ]##
  runnableExamples:
    doAssert:  !holidayGBEarlyMay(2019) ==~ dateTime(2019, mMay, 6)
    doAssert:  !holiday(2019, hdayGBEarlyMay) ==~ dateTime(2019, mMay, 6)
  if year == 2020:  # 75th anniversary of victory in europe
    result = dateTime(2020, mMay, 8, hour, minute, second, nanosecond, zone).some
  else:
    let monthday = nthWeekday(1, dMon, mMay, year)
    assert: monthday.isSome
    result = dateTime(year, mMay, !monthday, hour, minute, second, nanosecond, zone).some


# Spring bank holiday, last Monday in May
proc  holidayGBSpring*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                       second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                       zone: Timezone = local()): ?DateTime =
  ##[
  The 'Spring bank holiday (last Monday in May)' of the year received 
  as a parameter can be obtained in two distinct but equivalent ways.
  ]##
  runnableExamples:
    doAssert:  !holidayGBSpring(2020) ==~ dateTime(2020, mMay, 25)
    doAssert:  !holiday(2020, hdayGBSpring) ==~ dateTime(2020, mMay, 25)
  if year == 2022:  # day before the Platinum Jubilee bank holiday
    result = dateTime(2022, mJun, 2, hour, minute, second, nanosecond, zone).some
  else:
    let monthday = nthWeekday(-1, dMon, mMay, year)
    assert: monthday.isSome
    result = dateTime(year, mMay, !monthday, hour, minute, second, nanosecond, zone).some


# Orangemen’s Day observed in GB, July 12
defineProcHolidayXXXByAdjustingMmdParam(OrangemensDay, holidayGBSctOrangemensDay, nextMondayIfWeekend):
  runnableExamples:
    # The Orangemen’s Day observed in Scotland is calculated as follow:
    #  - Monday, July 13, if July 12 is a Sunday
    #  - Monday, July 14, if July 12 is a Saturday
    #  - July 12, in all other cases
    # The date of this public holiday can be obtained in two different but equivalent ways.
    doAssert:  !holidayGBSctOrangemensDay(2026) ==~ dateTime(2026, mJul, 13)  # Monday
    doAssert:  !holidayGBSctOrangemensDay(2025) ==~ dateTime(2025, mJul, 14)  # Monday
    doAssert:  !holidayGBSctOrangemensDay(2024) ==~ dateTime(2024, mJul, 12)  # Friday
    doAssert:  !holiday(2026, hdayGBSctOrangemensDay) ==~ dateTime(2026, mJul, 13)  # Monday
    doAssert:  !holiday(2025, hdayGBSctOrangemensDay) ==~ dateTime(2025, mJul, 14)  # Monday
    doAssert:  !holiday(2024, hdayGBSctOrangemensDay) ==~ dateTime(2024, mJul, 12)  # Friday


# Summer bank holiday in Scotland: first Monday in August
defineProcHolidayXXXUsingNthWeekdayOfMonth(holidayGBSctSummer, mAug, dMon, 1, 0):
  runnableExamples:
    # The 'Summer bank holiday (first Monday in August)' of the year received 
    # as a parameter can be obtained in two distinct but equivalent ways.
    doAssert:  !holidayGBSctSummer(2018) ==~ dateTime(2018, mAug, 6)
    doAssert:  !holiday(2018, hdayGBSctSummer) ==~ dateTime(2018, mAug, 6)


# Summer bank holiday in England, Wales and Northen Ireland: last Monday in August
defineProcHolidayXXXUsingNthWeekdayOfMonth(holidayGBEngNirWlsSummer, mAug, dMon, -1, 0):
  runnableExamples:
    # The 'Summer bank holiday (last Monday in August)' of the year received 
    # as a parameter can be obtained in two distinct but equivalent ways.
    doAssert:  !holidayGBEngNirWlsSummer(2018) ==~ dateTime(2018, mAug, 27)
    doAssert:  !holiday(2018, hdayGBEngNirWlsSummer) ==~ dateTime(2018, mAug, 27)


# St Andrew’s Day observed in Scotland, November 30
defineProcHolidayXXXByAdjustingMmdParam(StAndrewsDay, holidayGBSctStAndrewsDay, nextMondayIfWeekend):
  runnableExamples:
    # The Saint Andrew’s Day observed in Scotland is calculated as follow:
    #  - Monday, December 1, if November 30 is a Sunday
    #  - Monday, December 2, if November 30 is a Saturday
    #  - November 30, in all other cases
    # The date of this public holiday can be obtained in two different but equivalent ways.
    doAssert:  !holidayGBSctStAndrewsDay(2025) ==~ dateTime(2025, mDec, 1)  # Monday
    doAssert:  !holidayGBSctStAndrewsDay(2019) ==~ dateTime(2019, mDec, 2)  # Monday
    doAssert:  !holidayGBSctStAndrewsDay(2018) ==~ dateTime(2018, mNov, 30)  # Friday
    doAssert:  !holiday(2025, hdayGBSctStAndrewsDay) ==~ dateTime(2025, mDec, 1)  # Monday
    doAssert:  !holiday(2019, hdayGBSctStAndrewsDay) ==~ dateTime(2019, mDec, 2)  # Monday
    doAssert:  !holiday(2018, hdayGBSctStAndrewsDay) ==~ dateTime(2018, mNov, 30)  # Friday


# Christmas Day, December 25
proc  holidayGBChristmasDay*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                             second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                             zone: Timezone = local()): ?DateTime =
  ##[ 
  Returns the *Christmas Day observed in Great Britain* of the year received in parameter, that is:
    - Monday, December 27, if December 25 is a Saturday;
    - Tuesday, December 27, if December 25 is a Sunday;
    - December 25, in all other cases
  ]##  
  runnableExamples:
    # The date of this public holiday can be obtained in two different but equivalent ways.
    doAssert:  !holidayGBChristmasDay(2021) ==~ dateTime(2021, mDec, 27)  # Monday
    doAssert:  !holidayGBChristmasDay(2022) ==~ dateTime(2022, mDec, 27)  # Tuesday
    doAssert:  !holidayGBChristmasDay(2023) ==~ dateTime(2023, mDec, 25)  # Monday
    doAssert:  !holiday(2021, hdayGBChristmasDay) ==~ dateTime(2021, mDec, 27)  # Monday
    doAssert:  !holiday(2022, hdayGBChristmasDay) ==~ dateTime(2022, mDec, 27)  # Tuesday
    doAssert:  !holiday(2023, hdayGBChristmasDay) ==~ dateTime(2023, mDec, 25)  # Monday	
  let dayOfWeek = getDayOfWeek(christmasDay(year))
  if dayOfWeek in {dSat, dSun}:  
    result = dateTime(year, mDec, 27, hour, minute, second, nanosecond, zone).some
  else:  
    result = dateTime(year, mDec, 25, hour, minute, second, nanosecond, zone).some


# Boxing Day, December 26
proc  holidayGBBoxingDay*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                          second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                          zone: Timezone = local()): ?DateTime =
  ##[ 
  Returns the *Christmas Day observed in Great Britain* of the year received in parameter, that is:
    - Tuesday, December 28, if December 26 is a Sunday
    - Monday, December 28, if December 26 is a Saturday
    - December 26, in all other cases
  ]##  
  runnableExamples:
    # The date of this public holiday can be obtained in two different but equivalent ways.
    doAssert:  !holidayGBBoxingDay(2021) ==~ dateTime(2021, mDec, 28)  # Tuesday
    doAssert:  !holidayGBBoxingDay(2026) ==~ dateTime(2026, mDec, 28)  # Monday
    doAssert:  !holidayGBBoxingDay(2023) ==~ dateTime(2023, mDec, 26)  # Tuesday
    doAssert:  !holiday(2021, hdayGBBoxingDay) ==~ dateTime(2021, mDec, 28)  # Tuesday
    doAssert:  !holiday(2026, hdayGBBoxingDay) ==~ dateTime(2026, mDec, 28)  # Monday
    doAssert:  !holiday(2023, hdayGBBoxingDay) ==~ dateTime(2023, mDec, 26)  # Tuesday
  let dayOfWeek = getDayOfWeek(boxingDay(year))
  if dayOfWeek in {dSat, dSun}:  
    result = dateTime(year, mDec, 28, hour, minute, second, nanosecond, zone).some
  else:  
    result = dateTime(year, mDec, 26, hour, minute, second, nanosecond, zone).some
