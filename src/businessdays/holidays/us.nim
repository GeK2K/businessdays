# New Year’s Day (January 1st) observed in U.S.
defineProcHolidayXXXByAdjustingMmdParam(NewYearsDay, holidayUSNewYearsDay, nearestWeekday):
  runnableExamples:
    # The New Year’s Day observed in U.S. is calculated as follow:
    #  - Monday, January 2, if January 1 is a Sunday
    #  - Friday, December 31, if January 1 is a Saturday
    #  - January 1, in all other cases
    # The date of this public holiday can be obtained in two different but equivalent ways.
    doAssert:  !holidayUSNewYearsDay(2017) ==~ dateTime(2017, mJan, 2)  # Monday
    doAssert:  !holidayUSNewYearsDay(2022) ==~ dateTime(2021, mDec, 31) # Friday
    doAssert:  !holidayUSNewYearsDay(2020) ==~ dateTime(2020, mJan, 1)  # Wednesday
    doAssert:  !holiday(2017, hdayUSNewYearsDay) ==~ dateTime(2017, mJan, 2)  # Monday
    doAssert:  !holiday(2022, hdayUSNewYearsDay) ==~ dateTime(2021, mDec, 31) # Friday
    doAssert:  !holiday(2020, hdayUSNewYearsDay) ==~ dateTime(2020, mJan, 1)  # Wednesday


# New Year's Day (January 1st) observed on the NYSE
defineProcHolidayXXXByAdjustingMmdParam(NewYearsDay, holidayUSNYSENewYearsDay, nextMondayIfSunday):
  runnableExamples:
    # The New Year’s Day observed on the NYSE is calculated as follow:
    #   - Monday, January 2, if January 1 is a Sunday
    #   - January 1, in all other cases
    # The date of this public holiday can be obtained in two different but equivalent ways.
    doAssert:  !holidayUSNYSENewYearsDay(2017) ==~ dateTime(2017, mJan, 2)  # Monday
    doAssert:  !holidayUSNYSENewYearsDay(2022) ==~ dateTime(2022, mJan, 1)  # Saturday
    doAssert:  !holidayUSNYSENewYearsDay(2020) ==~ dateTime(2020, mJan, 1)  # Wednesday
    doAssert:  !holiday(2017, hdayUSNYSENewYearsDay) ==~ dateTime(2017, mJan, 2)  # Monday
    doAssert:  !holiday(2022, hdayUSNYSENewYearsDay) ==~ dateTime(2022, mJan, 1)  # Saturday
    doAssert:  !holiday(2020, hdayUSNYSENewYearsDay) ==~ dateTime(2020, mJan, 1)  # Wednesday


# Birthday of Martin Luther King (3rd Monday in January)
defineProcHolidayXXXUsingNthWeekdayOfMonth(holidayUSMartinLutherKingBirthday, mJan, dMon, 3, 0):
  runnableExamples:
    # The 'Birthday of Martin Luther King (3rd Monday in January)' of the year 
    # received as a parameter can be obtained in two different but equivalent ways.
    doAssert:  !holidayUSMartinLutherKingBirthday(2035) ==~ dateTime(2035, mJan, 15)
    doAssert:  !holiday(2035, hdayUSMartinLutherKingBirthday) ==~ dateTime(2035, mJan, 15)


# Washington’s Birthday (3rd Monday in February)
defineProcHolidayXXXUsingNthWeekdayOfMonth(holidayUSWashingtonBirthday, mFeb, dMon, 3, 0):
  runnableExamples:
    # The 'Washington’s Birthday (3rd Monday in February)' of the year received
    # as a parameter can be obtained in two different but equivalent ways.
    doAssert:  !holidayUSWashingtonBirthday(2035) ==~ dateTime(2035, mFeb, 19)
    doAssert:  !holiday(2035, hdayUSWashingtonBirthday) ==~ dateTime(2035, mFeb, 19)


# U.S. Memorial Day (last Monday in May)
defineProcHolidayXXXUsingNthWeekdayOfMonth(holidayUSMemorialDay, mMay, dMon, -1, 0):
  runnableExamples:
    # The 'U.S. Memorial Day (last Monday in May)' of the year received
    # as a parameter can be obtained in two different but equivalent ways.
    doAssert:  !holidayUSMemorialDay(2035) ==~ dateTime(2035, mMay, 28)
    doAssert:  !holiday(2035, hdayUSMemorialDay) ==~ dateTime(2035, mMay, 28)


# Juneteenth National Independence Day (June 19) observed in U.S.
defineProcHolidayXXXByAdjustingMmdParam(USJuneteenthIndependenceDay, holidayUSJuneteenthIndependenceDay,  
                                        nearestWeekday):
  runnableExamples:
    # The Juneteenth National Independence Day observed in U.S. is calculated as follow:
    #  - Monday, June 20, if June 19 is a Sunday
    #  - Friday, June 18, if June 19 is a Saturday
    #  - June 19 in all other cases
    # The date of this public holiday can be obtained in two different but equivalent ways.
    doAssert:  !holidayUSJuneteenthIndependenceDay(2033) ==~ dateTime(2033, mJun, 20) # Monday
    doAssert:  !holidayUSJuneteenthIndependenceDay(2027) ==~ dateTime(2027, mJun, 18) # Friday
    doAssert:  !holidayUSJuneteenthIndependenceDay(2024) ==~ dateTime(2024, mJun, 19) # Wednesday
    doAssert:  !holiday(2033, hdayUSJuneteenthIndependenceDay) ==~ dateTime(2033, mJun, 20) # Monday
    doAssert:  !holiday(2027, hdayUSJuneteenthIndependenceDay) ==~ dateTime(2027, mJun, 18) # Friday
    doAssert:  !holiday(2024, hdayUSJuneteenthIndependenceDay) ==~ dateTime(2024, mJun, 19) # Wednesday


# Independence Day (July 4) observed in U.S.
defineProcHolidayXXXByAdjustingMmdParam(USIndependenceDay, holidayUSIndependenceDay, nearestWeekday):
  runnableExamples:
    # The Independence Day observed in U.S. is calculated as follow:
    #  - Monday, July 5, if July 4 is a Sunday
    #  - Friday, July 3, if July 4 is a Saturday
    #  - July 4, in all other cases
    # The date of this public holiday can be obtained in two different but equivalent ways.
    doAssert:  !holidayUSIndependenceDay(2021) ==~ dateTime(2021, mJul, 5) # Monday
    doAssert:  !holidayUSIndependenceDay(2020) ==~ dateTime(2020, mJul, 3) # Friday
    doAssert:  !holidayUSIndependenceDay(2019) ==~ dateTime(2019, mJul, 4) # Thursday
    doAssert:  !holiday(2021, hdayUSIndependenceDay) ==~ dateTime(2021, mJul, 5) # Monday
    doAssert:  !holiday(2020, hdayUSIndependenceDay) ==~ dateTime(2020, mJul, 3) # Friday
    doAssert:  !holiday(2019, hdayUSIndependenceDay) ==~ dateTime(2019, mJul, 4) # Thursday


# U.S. Labor Day
defineProcHolidayXXXUsingNthWeekdayOfMonth(holidayUSLaborDay, mSep, dMon, 1, 0):
  runnableExamples:
    # The 'U.S. Labor Day (1st Monday in September)' of the year received
    # as a parameter can be obtained in two different but equivalent ways.
    doAssert:  !holidayUSLaborDay(2035) ==~ dateTime(2035, mSep, 3)
    doAssert:  !holiday(2035, hdayUSLaborDay) ==~ dateTime(2035, mSep, 3)


# U.S. Columbus Day
defineProcHolidayXXXUsingNthWeekdayOfMonth(holidayUSColumbusDay, mOct, dMon, 2, 0):
  runnableExamples:
    # The 'U.S. Columbus Day (2nd Monday in October)' of the year received
    # as a parameter can be obtained in two different but equivalent ways.
    doAssert:  !holidayUSColumbusDay(2003) ==~ dateTime(2003, mOct, 13)
    doAssert:  !holiday(2003, hdayUSColumbusDay) ==~ dateTime(2003, mOct, 13)
  

# U.S. Election Day
defineProcHolidayXXXUsingNthWeekdayOfMonth(holidayUSNYSEElectionDay, mNov, dMon, 1, 1):
  runnableExamples:
    # The 'U.S. Election Day (the Tuesday next after the first Monday in November)' of the
    # year received as a parameter can be obtained in two different but equivalent ways.
    doAssert:  !holidayUSNYSEElectionDay(2035) ==~ dateTime(2035, mNov, 6)
    doAssert:  !holiday(2035, hdayUSNYSEElectionDay) ==~ dateTime(2035, mNov, 6)
  

# U.S. Thanksgiving Day
defineProcHolidayXXXUsingNthWeekdayOfMonth(holidayUSThanksgivingDay, mNov, dThu, 4, 0):
  runnableExamples:
    # The 'U.S. Thanksgiving Day (4th Thursday in November)' of the year received
    # as a parameter can be obtained in two different but equivalent ways.
    doAssert:  !holidayUSThanksgivingDay(2035) ==~ dateTime(2035, mNov, 22)
    doAssert:  !holiday(2035, hdayUSThanksgivingDay) ==~ dateTime(2035, mNov, 22)


# Veterans’ Day (November 11) observed in U.S.
defineProcHolidayXXXByAdjustingMmdParam(USVeteransDay, holidayUSVeteransDay, nearestWeekday):
  runnableExamples:
    # The Veterans’ Day observed in U.S. is calculated as follow:
    #  - Monday, November 12, if November 11 is a Sunday
    #  - Friday, November 10, if November 11 is a Saturday
    #  - November 11 in all other cases
    # The date of this public holiday can be obtained in two different but equivalent ways.
    doAssert:  !holidayUSVeteransDay(2018) ==~ dateTime(2018, mNov, 12) # Monday
    doAssert:  !holidayUSVeteransDay(2017) ==~ dateTime(2017, mNov, 10) # Friday
    doAssert:  !holidayUSVeteransDay(2014) ==~ dateTime(2014, mNov, 11) # Tuesday
    doAssert:  !holiday(2018, hdayUSVeteransDay) ==~ dateTime(2018, mNov, 12) # Monday
    doAssert:  !holiday(2017, hdayUSVeteransDay) ==~ dateTime(2017, mNov, 10) # Friday
    doAssert:  !holiday(2014, hdayUSVeteransDay) ==~ dateTime(2014, mNov, 11) # Tuesday


# Christmas Day (December 25) observed in U.S.
defineProcHolidayXXXByAdjustingMmdParam(ChristmasDay, holidayUSChristmasDay, nearestWeekday):
  runnableExamples:
    # The Christmas Day observed in U.S. is calculated as follow:
    #  - Monday, December 26, if December 25 is a Sunday
    #  - Friday, December 24, if December 25 is a Saturday
    #  - December 25, in all other cases
    # The date of this public holiday can be obtained in two different but equivalent ways.
    doAssert:  !holidayUSChristmasDay(2022) ==~ dateTime(2022, mDec, 26) # Monday
    doAssert:  !holidayUSChristmasDay(2021) ==~ dateTime(2021, mDec, 24) # Friday
    doAssert:  !holidayUSChristmasDay(2019) ==~ dateTime(2019, mDec, 25) # Tuesday
    doAssert:  !holiday(2022, hdayUSChristmasDay) ==~ dateTime(2022, mDec, 26) # Monday
    doAssert:  !holiday(2021, hdayUSChristmasDay) ==~ dateTime(2021, mDec, 24) # Friday
    doAssert:  !holiday(2019, hdayUSChristmasDay) ==~ dateTime(2019, mDec, 25) # Tuesday


# US Inauguration Day
proc  usInaugurationDay*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                         second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                         zone: Timezone = local()): ?DateTime =
  ##[ 
  Returns the *U.S. Inauguration Day* of the year received in parameter, that is:
    - April 30 for the year 1789 (1st presidential election);
    - March 4, every presidential election year, from 1793 to 1933;
    - January 20, every presidential election year, since 1937;
    - `none(DateTime)` for all other years.

  **References:**
    - https://en.wikipedia.org/wiki/United_States_presidential_inauguration
  ]##  
  runnableExamples:
    doAssert:  usInaugurationDay(1512).isNone # 1st presidential election in 1789
    doAssert:  usInaugurationDay(2019).isNone # no presidential election in 2019
    doAssert:  !usInaugurationDay(1789) ==~ dateTime(1789, mApr, 30)
    doAssert:  !usInaugurationDay(1917) ==~ dateTime(1917, mMar, 4)
    doAssert:  !usInaugurationDay(2013) ==~ dateTime(2013, mJan, 20)
  if year < 1789:
    return none(DateTime)
  elif year == 1789:
    return dateTime(1789, mApr, 30, hour, minute, second, nanosecond, zone).some
  elif year > 1789 and year <= 1933:
    if (year-1789).mod(4) != 0:  return none(DateTime)
    else:  return dateTime(year, mMar, 4, hour, minute, second, nanosecond, zone).some
  else:
    if (year-1933).mod(4) != 0:  return none(DateTime)  
    else:  return dateTime(year, mJan, 20, hour, minute, second, nanosecond, zone).some


# Inauguration Day observed in U.S.
defineProcHolidayXXXFromAnAdjustProc(holidayUSInaugurationDay, usInaugurationDay, nextMondayIfSunday):
  runnableExamples:
    # The U.S. Inauguration Day observed in U.S. is calculated as follow:
    #  - Next Monday, if U.S. Inauguration Day is a Sunday
    #  - U.S. Inauguration Day in all other cases
    # The date of this public holiday can be obtained in two different but equivalent ways.
    doAssert:  holidayUSInaugurationDay(1512).isNone # 1st presidential election in 1789
    doAssert:  holidayUSInaugurationDay(2019).isNone # no presidential election in 2019
    doAssert:  !holidayUSInaugurationDay(1789) ==~ dateTime(1789, mApr, 30) # Thursday
    doAssert:  !holidayUSInaugurationDay(1813) ==~ dateTime(1813, mMar, 4) # Thursday
    doAssert:  !holidayUSInaugurationDay(1917) ==~ dateTime(1917, mMar, 5) # Monday
    doAssert:  !holidayUSInaugurationDay(2013) ==~ dateTime(2013, mJan, 21) # Monday
    doAssert:  !holidayUSInaugurationDay(2021) ==~ dateTime(2021, mJan, 20) # Wednesday
    doAssert:  holiday(1512, hdayUSInaugurationDay).isNone
    doAssert:  holiday(2019, hdayUSInaugurationDay).isNone
    doAssert:  !holiday(1789, hdayUSInaugurationDay) ==~ dateTime(1789, mApr, 30) # Thursday
    doAssert:  !holiday(2013, hdayUSInaugurationDay) ==~ dateTime(2013, mJan, 21) # Monday
    doAssert:  !holiday(2021, hdayUSInaugurationDay) ==~ dateTime(2021, mJan, 20) # Wednesday