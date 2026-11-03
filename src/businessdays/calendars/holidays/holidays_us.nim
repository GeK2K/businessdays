##[
===========
holidays_us
===========

Public holidays in the United States.
]##

# =========================     Imports / Exports     ======================== #

import  questionable, nimutils/[nutimes], ./private/[easter_days]
export  questionable, nutimes


# =============================     Includes     ============================= #

include  ./private/[useful_templates]


# ================     Public holidays in enumerated form     ================ #

type
  bdHolidayUSFederalGovt* = enum
    ## U.S. federal holidays.
    hdayUSFedGovtNewYearsDay, hdayUSFedGovtMartinLutherKingBirthday, 
    hdayUSFedGovtWashingtonBirthday, hdayUSFedGovtMemorialDay,
    hdayUSFedGovtJuneteenthIndependenceDay, hdayUSFedGovtIndependenceDay,
    hdayUSFedGovtLaborDay, hdayUSFedGovtColumbusDay, hdayUSFedGovtThanksgivingDay,
    hdayUSFedGovtVeteransDay, hdayUSFedGovtChristmasDay, hdayUSFedGovtInaugurationDay

  bdHolidayUSBondMarket* = enum
    ## Public holidays on the U.S. Bond Market.
    hdayUSBondMrktNewYearsDay, hdayUSBondMrktMartinLutherKingBirthday, 
    hdayUSBondMrktWashingtonBirthday, hdayUSBondMrktGoodFriday, hdayUSBondMrktMemorialDay,
    hdayUSBondMrktJuneteenthIndependenceDay, hdayUSBondMrktIndependenceDay,
    hdayUSBondMrktLaborDay, hdayUSBondMrktColumbusDay, hdayUSBondMrktThanksgivingDay,
    hdayUSBondMrktVeteransDay, hdayUSBondMrktChristmasDay

  bdHolidayUSNYSE* = enum
    ## New York Stock Exchange holidays.
    hdayUSNYSENewYearsDay, hdayUSNYSEMartinLutherKingBirthday, 
    hdayUSNYSEWashingtonBirthday, hdayUSNYSEGoodFriday, hdayUSNYSEMemorialDay,
    hdayUSNYSEJuneteenthIndependenceDay, hdayUSNYSEIndependenceDay, 
    hdayUSNYSELaborDay, hdayUSNYSEThanksgivingDay, hdayUSNYSEChristmasDay


# ===========================     Special dates     ========================== #

# New Year’s Day, January 1st
defineSpecialDate(NewYearsDay, newYearsDay, mJan, 1):
  runnableExamples:
    # the 'New Year’s Day (January 1st)' of the year received as a parameter
    doAssert:  newYearsDay(2016) ==~ dateTime(2016, mJan, 1)

# U.S. Juneteenth Independence Day, June 19
defineSpecialDate(USJuneteenthIndependenceDay, usJuneteenthIndependenceDay, mJun, 19):
  runnableExamples:
    # the 'U.S. Juneteenth Independence Day (June 19)' of the year received as a parameter
    doAssert:  usJuneteenthIndependenceDay(2016) ==~ dateTime(2016, mJun, 19)

# U.S. Independence Day, July 4
defineSpecialDate(USIndependenceDay, usIndependenceDay, mJul, 4):
  runnableExamples:
    # the 'U.S. Independence Day (July 4)' of the year received as a parameter
    doAssert:  usIndependenceDay(2016) ==~ dateTime(2016, mJul, 4)

# U.S. Veterans’ Day, November 11
defineSpecialDate(USVeteransDay, usVeteransDay, mNov, 11):
  runnableExamples:
    # the 'U.S. Veterans’ Day (November 11)' of the year received as a parameter
    doAssert:  usVeteransDay(2016) ==~ dateTime(2016, mNov, 11)

# Christmas Day, December 25th
defineSpecialDate(ChristmasDay, christmasDay, mDec, 25):
  runnableExamples:
    # the 'Christmas Day (December 25)' of the year received as a parameter
    doAssert:  christmasDay(2016) ==~ dateTime(2016, mDec, 25)


# =========================     holidayXXX  procs     ======================== #

# New Year’s Day (January 1st)
# ----------------------------

proc holidayUSFedGovtNewYearsDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                  second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                  zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the U.S. Federal *New Year’s Day* for the year 
  received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSFedGovtNewYearsDay(2017) ==~ dateTime(2017, mJan, 2)  # Monday
    doAssert:  !holidayUSFedGovtNewYearsDay(2022) ==~ dateTime(2021, mDec, 31) # Friday
    doAssert:  !holidayUSFedGovtNewYearsDay(2020) ==~ dateTime(2020, mJan, 1)  # Wednesday
    doAssert:  !holiday(2017, hdayUSFedGovtNewYearsDay) ==~ dateTime(2017, mJan, 2)  # Monday
    doAssert:  !holiday(2022, hdayUSFedGovtNewYearsDay) ==~ dateTime(2021, mDec, 31) # Friday
    doAssert:  !holiday(2020, hdayUSFedGovtNewYearsDay) ==~ dateTime(2020, mJan, 1)  # Wednesday
  dateTime(year, NewYearsDay.month, NewYearsDay.monthday, 
           hour, minute, second, nanosecond, zone).nearestWorkday.some


proc holidayUSBondMrktNewYearsDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                   second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                   zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *New Year’s Day* on the U.S. Bond Market for the 
  year received in parameter (desired time can be specified).

  **Notes:**
    - The `isholidayUSBondMarket <#isholidayUSBondMarket,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSBondMrktNewYearsDay(2017) ==~ dateTime(2017, mJan, 2)  # Monday
    doAssert:  !holidayUSBondMrktNewYearsDay(2020) ==~ dateTime(2020, mJan, 1)  # Wednesday
    doAssert:  !holiday(2017, hdayUSBondMrktNewYearsDay) ==~ dateTime(2017, mJan, 2)  # Monday
    doAssert:  !holiday(2020, hdayUSBondMrktNewYearsDay) ==~ dateTime(2020, mJan, 1)  # Wednesday
  dateTime(year, NewYearsDay.month, NewYearsDay.monthday, 
           hour, minute, second, nanosecond, zone).nextMondayIfSunday.some


proc holidayUSNYSENewYearsDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                               second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                               zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *New Year’s Day* on the New York Stock Exchange for 
  the year received in parameter (desired time can be specified).

  **Notes:**
    - The `isholidayUSNYSE <#isholidayUSNYSE,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSNYSENewYearsDay(2017) ==~ dateTime(2017, mJan, 2)  # Monday
    doAssert:  !holidayUSNYSENewYearsDay(2022) ==~ dateTime(2022, mJan, 1)  # Saturday
    doAssert:  !holidayUSNYSENewYearsDay(2020) ==~ dateTime(2020, mJan, 1)  # Wednesday
    doAssert:  !holiday(2017, hdayUSNYSENewYearsDay) ==~ dateTime(2017, mJan, 2)  # Monday
    doAssert:  !holiday(2022, hdayUSNYSENewYearsDay) ==~ dateTime(2022, mJan, 1)  # Saturday
    doAssert:  !holiday(2020, hdayUSNYSENewYearsDay) ==~ dateTime(2020, mJan, 1)  # Wednesday
  dateTime(year, NewYearsDay.month, NewYearsDay.monthday, 
           hour, minute, second, nanosecond, zone).nextMondayIfSunday.some


# Birthday of Martin Luther King (3rd Monday in January)
# ------------------------------------------------------

proc holidayUSMartinLutherKingBirthday(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                       second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                       zone: Timezone = local()): ?DateTime =
  let n = 3
  let weekday = dMon
  let month = mJan
  let monthday = nthWeekday(n=n, weekday=weekday, month=month, year=year)
  assert: monthday.isSome
  dateTime(year, month, !monthday, hour, minute, second, nanosecond, zone).some


proc holidayUSFedGovtMartinLutherKingBirthday*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                               second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                               zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Birthday of Martin Luther King (3rd Monday in January)*
  for the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSFedGovtMartinLutherKingBirthday(2035) ==~ dateTime(2035, mJan, 15)
    doAssert:  !holiday(2035, hdayUSFedGovtMartinLutherKingBirthday) ==~ dateTime(2035, mJan, 15)
  if year < 1986:  return none(DateTime)  # before start year
  holidayUSMartinLutherKingBirthday(year, hour, minute, second, nanosecond, zone)


proc holidayUSBondMrktMartinLutherKingBirthday*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                                second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                                zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Birthday of Martin Luther King (3rd Monday in January)*
  for the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSBondMarket <#isholidayUSBondMarket,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSBondMrktMartinLutherKingBirthday(2035) ==~ dateTime(2035, mJan, 15)
    doAssert:  !holiday(2035, hdayUSBondMrktMartinLutherKingBirthday) ==~ dateTime(2035, mJan, 15)
  if year < 1986:  return none(DateTime)  # before start year
  holidayUSMartinLutherKingBirthday(year, hour, minute, second, nanosecond, zone)


proc holidayUSNYSEMartinLutherKingBirthday*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                            second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                            zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Birthday of Martin Luther King (3rd Monday in January)*
  for the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSNYSE <#isholidayUSNYSE,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSNYSEMartinLutherKingBirthday(2035) ==~ dateTime(2035, mJan, 15)
    doAssert:  !holiday(2035, hdayUSNYSEMartinLutherKingBirthday) ==~ dateTime(2035, mJan, 15)
  if year < 1998:  return none(DateTime)  # before start year
  holidayUSMartinLutherKingBirthday(year, hour, minute, second, nanosecond, zone)


# Washington’s Birthday (3rd Monday in February)
# ----------------------------------------------

proc holidayUSWashingtonBirthday(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                 second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                 zone: Timezone = local()): ?DateTime =
  let n = 3
  let weekday = dMon
  let month = mFeb
  let monthday = nthWeekday(n=n, weekday=weekday, month=month, year=year)
  assert: monthday.isSome
  dateTime(year, month, !monthday, hour, minute, second, nanosecond, zone).some


proc holidayUSFedGovtWashingtonBirthday*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                         second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                         zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Washington’s Birthday (3rd Monday in February)* for
  the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSFedGovtWashingtonBirthday(2035) ==~ dateTime(2035, mFeb, 19)
    doAssert:  !holiday(2035, hdayUSFedGovtWashingtonBirthday) ==~ dateTime(2035, mFeb, 19)
  if year < 1880:  return none(DateTime)  # before start year
  holidayUSWashingtonBirthday(year, hour, minute, second, nanosecond, zone)


proc holidayUSBondMrktWashingtonBirthday*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                          second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                          zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Washington’s Birthday (3rd Monday in February)* for
  the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSBondMarket <#isholidayUSBondMarket,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSBondMrktWashingtonBirthday(2035) ==~ dateTime(2035, mFeb, 19)
    doAssert:  !holiday(2035, hdayUSBondMrktWashingtonBirthday) ==~ dateTime(2035, mFeb, 19)
  if year < 1880:  return none(DateTime)  # before start year
  holidayUSWashingtonBirthday(year, hour, minute, second, nanosecond, zone)


proc holidayUSNYSEWashingtonBirthday*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                      second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                      zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Washington’s Birthday (3rd Monday in February)* for
  the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSNYSE <#isholidayUSNYSE,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSNYSEWashingtonBirthday(2035) ==~ dateTime(2035, mFeb, 19)
    doAssert:  !holiday(2035, hdayUSNYSEWashingtonBirthday) ==~ dateTime(2035, mFeb, 19)
  if year < 1971:  return none(DateTime)  # before start year
  holidayUSWashingtonBirthday(year, hour, minute, second, nanosecond, zone)


# Good Friday
# -----------

proc holidayUSBondMrktGoodFriday*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                  second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                  zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Good Friday* of the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSBondMrktGoodFriday(2018) ==~ dateTime(2018, mMar, 30)
    doAssert:  !holiday(2018, hdayUSBondMrktGoodFriday) ==~ dateTime(2018, mMar, 30)
  if year < 1887:  return none(DateTime)  # before start year
  holidayGoodFriday(year, hour, minute, second, nanosecond, zone)


proc holidayUSNYSEGoodFriday*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                              second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                              zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Good Friday* of the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSNYSE <#isholidayUSNYSE,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSNYSEGoodFriday(2018) ==~ dateTime(2018, mMar, 30)
    doAssert:  !holiday(2018, hdayUSNYSEGoodFriday) ==~ dateTime(2018, mMar, 30)
  # the only years that Good Friday has not been celebrated are 1898, 1906, 1907
  if year == 1898 or year == 1906 or year == 1907:  return none(DateTime)
  holidayGoodFriday(year, hour, minute, second, nanosecond, zone)


# U.S. Memorial Day (last Monday in May)
# --------------------------------------

proc holidayUSMemorialDay(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                          second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                          zone: Timezone = local()): ?DateTime =
  let n = -1
  let weekday = dMon
  let month = mMay
  let monthday = nthWeekday(n=n, weekday=weekday, month=month, year=year)
  assert: monthday.isSome
  dateTime(year, month, !monthday, hour, minute, second, nanosecond, zone).some


proc holidayUSFedGovtMemorialDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                  second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                  zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *U.S. Memorial Day (last Monday in May)* for the
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSFedGovtMemorialDay(2035) ==~ dateTime(2035, mMay, 28)
    doAssert:  !holiday(2035, hdayUSFedGovtMemorialDay) ==~ dateTime(2035, mMay, 28)
  if year < 1969:  return none(DateTime)  # before start year
  holidayUSMemorialDay(year, hour, minute, second, nanosecond, zone)


proc holidayUSBondMrktMemorialDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                   second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                   zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *U.S. Memorial Day (last Monday in May)* for the
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSBondMarket <#isholidayUSBondMarket,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSBondMrktMemorialDay(2035) ==~ dateTime(2035, mMay, 28)
    doAssert:  !holiday(2035, hdayUSBondMrktMemorialDay) ==~ dateTime(2035, mMay, 28)
  if year < 1969:  return none(DateTime)  # before start year
  holidayUSMemorialDay(year, hour, minute, second, nanosecond, zone)


proc holidayUSNYSEMemorialDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                               second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *U.S. Memorial Day (last Monday in May)* for the
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSNYSE <#isholidayUSNYSE,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSNYSEMemorialDay(2035) ==~ dateTime(2035, mMay, 28)
    doAssert:  !holiday(2035, hdayUSNYSEMemorialDay) ==~ dateTime(2035, mMay, 28)
  if year < 1971:  return none(DateTime)  # before start year
  holidayUSMemorialDay(year, hour, minute, second, nanosecond, zone)


# Juneteenth National Independence Day (June 19)
# ----------------------------------------------

proc holidayUSFedGovtJuneteenthIndependenceDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                                second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                                zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the U.S. Federal *Juneteenth National Independence Day* 
  for the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSFedGovtJuneteenthIndependenceDay(2033) ==~ dateTime(2033, mJun, 20) # Monday
    doAssert:  !holidayUSFedGovtJuneteenthIndependenceDay(2027) ==~ dateTime(2027, mJun, 18) # Friday
    doAssert:  !holidayUSFedGovtJuneteenthIndependenceDay(2024) ==~ dateTime(2024, mJun, 19) # Wednesday
    doAssert:  !holiday(2033, hdayUSFedGovtJuneteenthIndependenceDay) ==~ dateTime(2033, mJun, 20) # Monday
    doAssert:  !holiday(2027, hdayUSFedGovtJuneteenthIndependenceDay) ==~ dateTime(2027, mJun, 18) # Friday
    doAssert:  !holiday(2024, hdayUSFedGovtJuneteenthIndependenceDay) ==~ dateTime(2024, mJun, 19) # Wednesday
  if year < 2021:  return none(DateTime)  # before start year
  dateTime(year, USJuneteenthIndependenceDay.month, USJuneteenthIndependenceDay.monthday, 
           hour, minute, second, nanosecond, zone).nearestWorkday.some


proc holidayUSBondMrktJuneteenthIndependenceDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                                 second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                                 zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Juneteenth National Independence Day* on the U.S. Bond Market
  for the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSBondMarket <#isholidayUSBondMarket,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSBondMrktJuneteenthIndependenceDay(2033) ==~ dateTime(2033, mJun, 20) # Monday
    doAssert:  !holidayUSBondMrktJuneteenthIndependenceDay(2027) ==~ dateTime(2027, mJun, 18) # Friday
    doAssert:  !holidayUSBondMrktJuneteenthIndependenceDay(2024) ==~ dateTime(2024, mJun, 19) # Wednesday
    doAssert:  !holiday(2033, hdayUSBondMrktJuneteenthIndependenceDay) ==~ dateTime(2033, mJun, 20) # Monday
    doAssert:  !holiday(2027, hdayUSBondMrktJuneteenthIndependenceDay) ==~ dateTime(2027, mJun, 18) # Friday
    doAssert:  !holiday(2024, hdayUSBondMrktJuneteenthIndependenceDay) ==~ dateTime(2024, mJun, 19) # Wednesday
  if year < 2022:  return none(DateTime)  # before start year
  dateTime(year, USJuneteenthIndependenceDay.month, USJuneteenthIndependenceDay.monthday, 
           hour, minute, second, nanosecond, zone).nearestWorkday.some


proc holidayUSNYSEJuneteenthIndependenceDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                             second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                             zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Juneteenth National Independence Day* on the New York Stock Exchange
  for the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSNYSE <#isholidayUSNYSE,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSNYSEJuneteenthIndependenceDay(2033) ==~ dateTime(2033, mJun, 20) # Monday
    doAssert:  !holidayUSNYSEJuneteenthIndependenceDay(2027) ==~ dateTime(2027, mJun, 18) # Friday
    doAssert:  !holidayUSNYSEJuneteenthIndependenceDay(2024) ==~ dateTime(2024, mJun, 19) # Wednesday
    doAssert:  !holiday(2033, hdayUSNYSEJuneteenthIndependenceDay) ==~ dateTime(2033, mJun, 20) # Monday
    doAssert:  !holiday(2027, hdayUSNYSEJuneteenthIndependenceDay) ==~ dateTime(2027, mJun, 18) # Friday
    doAssert:  !holiday(2024, hdayUSNYSEJuneteenthIndependenceDay) ==~ dateTime(2024, mJun, 19) # Wednesday
  if year < 2023:  return none(DateTime)  # before start year
  dateTime(year, USJuneteenthIndependenceDay.month, USJuneteenthIndependenceDay.monthday, 
           hour, minute, second, nanosecond, zone).nearestWorkday.some


# Independence Day (July 4)
# -------------------------

proc holidayUSFedGovtIndependenceDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                      second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                      zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the U.S. Federal *Independence Day* for the year 
  received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSFedGovtIndependenceDay(2021) ==~ dateTime(2021, mJul, 5) # Monday
    doAssert:  !holidayUSFedGovtIndependenceDay(2020) ==~ dateTime(2020, mJul, 3) # Friday
    doAssert:  !holidayUSFedGovtIndependenceDay(2019) ==~ dateTime(2019, mJul, 4) # Thursday
    doAssert:  !holiday(2021, hdayUSFedGovtIndependenceDay) ==~ dateTime(2021, mJul, 5) # Monday
    doAssert:  !holiday(2020, hdayUSFedGovtIndependenceDay) ==~ dateTime(2020, mJul, 3) # Friday
    doAssert:  !holiday(2019, hdayUSFedGovtIndependenceDay) ==~ dateTime(2019, mJul, 4) # Thursday
  if year < 1871:  return none(DateTime)  # before start year
  dateTime(year, USIndependenceDay.month, USIndependenceDay.monthday, 
           hour, minute, second, nanosecond, zone).nearestWorkday.some


proc holidayUSBondMrktIndependenceDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                       second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                       zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Independence Day* on the U.S. Bond Market for the 
  year received in parameter (desired time can be specified).

  **Notes:**
    - The `isholidayUSBondMarket <#isholidayUSBondMarket,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSBondMrktIndependenceDay(2021) ==~ dateTime(2021, mJul, 5) # Monday
    doAssert:  !holidayUSBondMrktIndependenceDay(2020) ==~ dateTime(2020, mJul, 3) # Friday
    doAssert:  !holidayUSBondMrktIndependenceDay(2019) ==~ dateTime(2019, mJul, 4) # Thursday
    doAssert:  !holiday(2021, hdayUSBondMrktIndependenceDay) ==~ dateTime(2021, mJul, 5) # Monday
    doAssert:  !holiday(2020, hdayUSBondMrktIndependenceDay) ==~ dateTime(2020, mJul, 3) # Friday
    doAssert:  !holiday(2019, hdayUSBondMrktIndependenceDay) ==~ dateTime(2019, mJul, 4) # Thursday
  if year < 1871:  return none(DateTime)  # before start year
  dateTime(year, USIndependenceDay.month, USIndependenceDay.monthday, 
           hour, minute, second, nanosecond, zone).nearestWorkday.some


proc holidayUSNYSEIndependenceDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                   second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                   zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Independence Day* on the New York Stock Exchange for 
  the year received in parameter (desired time can be specified).

  **Notes:**
    - The `isholidayUSNYSE <#isholidayUSNYSE,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSNYSEIndependenceDay(2021) ==~ dateTime(2021, mJul, 5) # Monday
    doAssert:  !holidayUSNYSEIndependenceDay(2020) ==~ dateTime(2020, mJul, 3) # Friday
    doAssert:  !holidayUSNYSEIndependenceDay(2019) ==~ dateTime(2019, mJul, 4) # Thursday
    doAssert:  !holiday(2021, hdayUSNYSEIndependenceDay) ==~ dateTime(2021, mJul, 5) # Monday
    doAssert:  !holiday(2020, hdayUSNYSEIndependenceDay) ==~ dateTime(2020, mJul, 3) # Friday
    doAssert:  !holiday(2019, hdayUSNYSEIndependenceDay) ==~ dateTime(2019, mJul, 4) # Thursday
  dateTime(year, USIndependenceDay.month, USIndependenceDay.monthday, 
           hour, minute, second, nanosecond, zone).nearestWorkday.some


# U.S. Labor Day (first Monday in September)
# ------------------------------------------

proc holidayUSLaborDay(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                       second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                       zone: Timezone = local()): ?DateTime =
  let n = 1
  let weekday = dMon
  let month = mSep
  let monthday = nthWeekday(n=n, weekday=weekday, month=month, year=year)
  assert: monthday.isSome
  dateTime(year, month, !monthday, hour, minute, second, nanosecond, zone).some


proc holidayUSFedGovtLaborDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                               second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                               zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Labor Day (1st Monday in September)* for the
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSFedGovtLaborDay(2035) ==~ dateTime(2035, mSep, 3)
    doAssert:  !holiday(2035, hdayUSFedGovtLaborDay) ==~ dateTime(2035, mSep, 3)
  if year < 1895:  return none(DateTime)  # before start year
  holidayUSLaborDay(year, hour, minute, second, nanosecond, zone)


proc holidayUSBondMrktLaborDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Labor Day (1st Monday in September)* for the
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSBondMarket <#isholidayUSBondMarket,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSBondMrktLaborDay(2035) ==~ dateTime(2035, mSep, 3)
    doAssert:  !holiday(2035, hdayUSBondMrktLaborDay) ==~ dateTime(2035, mSep, 3)
  if year < 1895:  return none(DateTime)  # before start year
  holidayUSLaborDay(year, hour, minute, second, nanosecond, zone)


proc holidayUSNYSELaborDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                            second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                            zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Labor Day (1st Monday in September)* for the
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSNYSE <#isholidayUSNYSE,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSNYSELaborDay(2035) ==~ dateTime(2035, mSep, 3)
    doAssert:  !holiday(2035, hdayUSNYSELaborDay) ==~ dateTime(2035, mSep, 3)
  if year < 1888:  return none(DateTime)  # before start year
  holidayUSLaborDay(year, hour, minute, second, nanosecond, zone)


# U.S. Columbus Day (second Monday in October)
# --------------------------------------------

proc holidayUSColumbusDay(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                          second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                          zone: Timezone = local()): ?DateTime =
  let n = 2
  let weekday = dMon
  let month = mOct
  let monthday = nthWeekday(n=n, weekday=weekday, month=month, year=year)
  assert: monthday.isSome
  dateTime(year, month, !monthday, hour, minute, second, nanosecond, zone).some


proc holidayUSFedGovtColumbusDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                  second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                  zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *U.S. Columbus Day (2nd Monday in October)* for the
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSFedGovtColumbusDay(2003) ==~ dateTime(2003, mOct, 13)
    doAssert:  !holiday(2003, hdayUSFedGovtColumbusDay) ==~ dateTime(2003, mOct, 13)
  if year < 1969:  return none(DateTime)  # before start year
  holidayUSColumbusDay(year, hour, minute, second, nanosecond, zone)


proc holidayUSBondMrktColumbusDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                   second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                   zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *U.S. Columbus Day (2nd Monday in October)* for the
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSBondMarket <#isholidayUSBondMarket,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]## 
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSBondMrktColumbusDay(2003) ==~ dateTime(2003, mOct, 13)
    doAssert:  !holiday(2003, hdayUSBondMrktColumbusDay) ==~ dateTime(2003, mOct, 13)
  if year < 1969:  return none(DateTime)  # before start year
  holidayUSColumbusDay(year, hour, minute, second, nanosecond, zone)


# U.S. Election Day
# -----------------

proc holidayUSNYSEElectionDay(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                              second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                              zone: Timezone = local()): ?DateTime =
  ## Returns the *U.S. Election Day (Tuesday next after the first Monday in November)*
  ## for the year received in parameter (desired time can be specified).
  if year <= 1968 or year in [1972, 1976, 1980]:
    let n = 1
    let weekday = dMon
    let month = mNov
    let monthday = nthWeekday(n=n, weekday=weekday, month=month, year=year)
    assert: monthday.isSome
    return (dateTime(year, month, !monthday, hour, minute, second, nanosecond, zone) + 1.days).some
  else:
    return none(DateTime)


# U.S. Thanksgiving Day (fourth Thursday in November)
# ---------------------------------------------------

proc holidayUSThanksgivingDay(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                              second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                              zone: Timezone = local()): ?DateTime =
  let n = 4
  let weekday = dThu
  let month = mNov
  let monthday = nthWeekday(n=n, weekday=weekday, month=month, year=year)
  assert: monthday.isSome
  dateTime(year, month, !monthday, hour, minute, second, nanosecond, zone).some


proc holidayUSFedGovtThanksgivingDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                      second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                      zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Thanksgiving Day (4th Thursday in November)* for 
  the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSFedGovtThanksgivingDay(2035) ==~ dateTime(2035, mNov, 22)
    doAssert:  !holiday(2035, hdayUSFedGovtThanksgivingDay) ==~ dateTime(2035, mNov, 22)
  if year < 1942:  return none(DateTime)  # before start year
  holidayUSThanksgivingDay(year, hour, minute, second, nanosecond, zone)


proc holidayUSBondMrktThanksgivingDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                       second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                       zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Thanksgiving Day (4th Thursday in November)* for 
  the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSBondMarket <#isholidayUSBondMarket,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSBondMrktThanksgivingDay(2035) ==~ dateTime(2035, mNov, 22)
    doAssert:  !holiday(2035, hdayUSBondMrktThanksgivingDay) ==~ dateTime(2035, mNov, 22)
  if year < 1942:  return none(DateTime)  # before start year
  holidayUSThanksgivingDay(year, hour, minute, second, nanosecond, zone)


proc holidayUSNYSEThanksgivingDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                   second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                   zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Thanksgiving Day (4th Thursday in November)* for 
  the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSNYSE <#isholidayUSNYSE,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSNYSEThanksgivingDay(2035) ==~ dateTime(2035, mNov, 22)
    doAssert:  !holiday(2035, hdayUSNYSEThanksgivingDay) ==~ dateTime(2035, mNov, 22)
  holidayUSThanksgivingDay(year, hour, minute, second, nanosecond, zone)


# Veterans’ Day (November 11)
# ---------------------------

proc holidayUSFedGovtVeteransDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                  second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                  zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the U.S. Federal *Veterans’ Day* for the year
  received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSFedGovtVeteransDay(2018) ==~ dateTime(2018, mNov, 12) # Monday
    doAssert:  !holidayUSFedGovtVeteransDay(2017) ==~ dateTime(2017, mNov, 10) # Friday
    doAssert:  !holidayUSFedGovtVeteransDay(2014) ==~ dateTime(2014, mNov, 11) # Tuesday
    doAssert:  !holiday(2018, hdayUSFedGovtVeteransDay) ==~ dateTime(2018, mNov, 12) # Monday
    doAssert:  !holiday(2017, hdayUSFedGovtVeteransDay) ==~ dateTime(2017, mNov, 10) # Friday
    doAssert:  !holiday(2014, hdayUSFedGovtVeteransDay) ==~ dateTime(2014, mNov, 11) # Tuesday
  if year < 1939:  return none(DateTime)  # before start year
  dateTime(year, USVeteransDay.month, USVeteransDay.monthday, 
           hour, minute, second, nanosecond, zone).nearestWorkday.some


proc holidayUSBondMrktVeteransDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                   second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                   zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Veterans’ Day* on the U.S. Bond Market for the 
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSBondMarket <#isholidayUSBondMarket,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSBondMrktVeteransDay(2018) ==~ dateTime(2018, mNov, 12) # Monday
    doAssert:  !holidayUSBondMrktVeteransDay(2017) ==~ dateTime(2017, mNov, 11) # Saturday
    doAssert:  !holidayUSBondMrktVeteransDay(2023) ==~ dateTime(2023, mNov, 11) # Saturday
    doAssert:  !holiday(2018, hdayUSBondMrktVeteransDay) ==~ dateTime(2018, mNov, 12) # Monday
    doAssert:  !holiday(2017, hdayUSBondMrktVeteransDay) ==~ dateTime(2017, mNov, 11) # Saturday
    doAssert:  !holiday(2023, hdayUSBondMrktVeteransDay) ==~ dateTime(2023, mNov, 11) # Saturday
  if year < 1939:  return none(DateTime)  # before start year
  dateTime(year, USVeteransDay.month, USVeteransDay.monthday, 
           hour, minute, second, nanosecond, zone).nextMondayIfSunday.some


# Christmas Day (December 25)
# ---------------------------

proc holidayUSFedGovtChristmasDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                   second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                   zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the U.S. Federal *Christmas Day* for the year
  received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSFedGovtChristmasDay(2022) ==~ dateTime(2022, mDec, 26) # Monday
    doAssert:  !holidayUSFedGovtChristmasDay(2021) ==~ dateTime(2021, mDec, 24) # Friday
    doAssert:  !holidayUSFedGovtChristmasDay(2019) ==~ dateTime(2019, mDec, 25) # Tuesday
    doAssert:  !holiday(2022, hdayUSFedGovtChristmasDay) ==~ dateTime(2022, mDec, 26) # Monday
    doAssert:  !holiday(2021, hdayUSFedGovtChristmasDay) ==~ dateTime(2021, mDec, 24) # Friday
    doAssert:  !holiday(2019, hdayUSFedGovtChristmasDay) ==~ dateTime(2019, mDec, 25) # Tuesday
  if year < 1871:  return none(DateTime)  # before start year
  dateTime(year, ChristmasDay.month, ChristmasDay.monthday, 
           hour, minute, second, nanosecond, zone).nearestWorkday.some


proc holidayUSBondMrktChristmasDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                    second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                    zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Christmas Day* on the U.S. Bond Market for the 
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSBondMarket <#isholidayUSBondMarket,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSBondMrktChristmasDay(2022) ==~ dateTime(2022, mDec, 26) # Monday
    doAssert:  !holidayUSBondMrktChristmasDay(2021) ==~ dateTime(2021, mDec, 24) # Friday
    doAssert:  !holidayUSBondMrktChristmasDay(2019) ==~ dateTime(2019, mDec, 25) # Tuesday
    doAssert:  !holiday(2022, hdayUSBondMrktChristmasDay) ==~ dateTime(2022, mDec, 26) # Monday
    doAssert:  !holiday(2021, hdayUSBondMrktChristmasDay) ==~ dateTime(2021, mDec, 24) # Friday
    doAssert:  !holiday(2019, hdayUSBondMrktChristmasDay) ==~ dateTime(2019, mDec, 25) # Tuesday
  dateTime(year, ChristmasDay.month, ChristmasDay.monthday, 
           hour, minute, second, nanosecond, zone).nearestWorkday.some


proc holidayUSNYSEChristmasDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Christmas Day* on the New York Stock Exchange for 
  the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSNYSE <#isholidayUSNYSE,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUSNYSEChristmasDay(2022) ==~ dateTime(2022, mDec, 26) # Monday
    doAssert:  !holidayUSNYSEChristmasDay(2021) ==~ dateTime(2021, mDec, 24) # Friday
    doAssert:  !holidayUSNYSEChristmasDay(2019) ==~ dateTime(2019, mDec, 25) # Tuesday
    doAssert:  !holiday(2022, hdayUSNYSEChristmasDay) ==~ dateTime(2022, mDec, 26) # Monday
    doAssert:  !holiday(2021, hdayUSNYSEChristmasDay) ==~ dateTime(2021, mDec, 24) # Friday
    doAssert:  !holiday(2019, hdayUSNYSEChristmasDay) ==~ dateTime(2019, mDec, 25) # Tuesday
  dateTime(year, ChristmasDay.month, ChristmasDay.monthday, 
           hour, minute, second, nanosecond, zone).nearestWorkday.some


# U.S. Inauguration Day
# ---------------------

proc usInaugurationDay*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
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
    doAssert:  usInaugurationDay(2019).isNone # no presidential election in 2019
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


proc holidayUSFedGovtInaugurationDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                      second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                      zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the U.S. Federal *Inauguration Day* for the year
  received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  holidayUSFedGovtInaugurationDay(2019).isNone # no presidential election in 2019
    doAssert:  !holidayUSFedGovtInaugurationDay(2013) ==~ dateTime(2013, mJan, 21) # Monday
    doAssert:  !holidayUSFedGovtInaugurationDay(2021) ==~ dateTime(2021, mJan, 20) # Wednesday
    doAssert:  holiday(2019, hdayUSFedGovtInaugurationDay).isNone
    doAssert:  !holiday(2013, hdayUSFedGovtInaugurationDay) ==~ dateTime(2013, mJan, 21) # Monday
    doAssert:  !holiday(2021, hdayUSFedGovtInaugurationDay) ==~ dateTime(2021, mJan, 20) # Wednesday
  let inaugurationDay = usInaugurationDay(year, hour, minute, second, nanosecond, zone)
  if inaugurationDay.isNone:  return none(DateTime)
  else:  return (!inaugurationDay).nextMondayIfSunday.some


# ==========================     holiday  procs     ========================== #

proc holiday*(year: int, hday: bdHolidayUSFederalGovt, hour: HourRange = 0, 
              minute: MinuteRange = 0, second: SecondRange = 0, 
              nanosecond: NanosecondRange = 0, zone: TimeZone = local()): ?DateTime =
  ## Returns the holiday corresponding to the `<year>` and `<hday>` parameters (desired time can be specified).
  # 1st objective of this function: to guarantee that a procedure has been 
  # implemented for each item in the 'bdHolidayUSFederalGovt' enumeration.
  runnableExamples:
    doAssert:  !holiday(2022, hdayUSFedGovtNewYearsDay) ==~ dateTime(2021, mDec, 31)
    doAssert:  !holiday(2035, hdayUSFedGovtMartinLutherKingBirthday) ==~ dateTime(2035, mJan, 15)
  case hday
    of hdayUSFedGovtNewYearsDay:
      result = holidayUSFedGovtNewYearsDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSFedGovtMartinLutherKingBirthday:
      result = holidayUSFedGovtMartinLutherKingBirthday(year, hour, minute, second, nanosecond, zone)
    of hdayUSFedGovtWashingtonBirthday:
      result = holidayUSFedGovtWashingtonBirthday(year, hour, minute, second, nanosecond, zone)
    of hdayUSFedGovtMemorialDay:
      result = holidayUSFedGovtMemorialDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSFedGovtJuneteenthIndependenceDay:
      result = holidayUSFedGovtJuneteenthIndependenceDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSFedGovtIndependenceDay:
      result = holidayUSFedGovtIndependenceDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSFedGovtLaborDay:
      result = holidayUSFedGovtLaborDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSFedGovtColumbusDay:
      result = holidayUSFedGovtColumbusDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSFedGovtThanksgivingDay:
      result = holidayUSFedGovtThanksgivingDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSFedGovtVeteransDay:
      result = holidayUSFedGovtVeteransDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSFedGovtChristmasDay:
      result = holidayUSFedGovtChristmasDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSFedGovtInaugurationDay:
      result = holidayUSFedGovtInaugurationDay(year, hour, minute, second, nanosecond, zone)


proc holiday*(year: int, hday: bdHolidayUSBondMarket, hour: HourRange = 0, 
              minute: MinuteRange = 0, second: SecondRange = 0, 
              nanosecond: NanosecondRange = 0, zone: TimeZone = local()): ?DateTime =
  ## Returns the holiday corresponding to the `<year>` and `<hday>` parameters (desired time can be specified).
  # 1st objective of this function: to guarantee that a procedure has been 
  # implemented for each item in the 'bdHolidayUSBondMarket' enumeration.
  runnableExamples:
    doAssert:  !holiday(2023, hdayUSBondMrktNewYearsDay) ==~ dateTime(2023, mJan, 2)
    doAssert:  !holiday(2035, hdayUSBondMrktMartinLutherKingBirthday) ==~ dateTime(2035, mJan, 15)
  case hday
    of hdayUSBondMrktNewYearsDay:
      result = holidayUSBondMrktNewYearsDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSBondMrktMartinLutherKingBirthday:
      result = holidayUSBondMrktMartinLutherKingBirthday(year, hour, minute, second, nanosecond, zone)
    of hdayUSBondMrktWashingtonBirthday:
      result = holidayUSBondMrktWashingtonBirthday(year, hour, minute, second, nanosecond, zone)
    of hdayUSBondMrktGoodFriday:
      result = holidayUSBondMrktGoodFriday(year, hour, minute, second, nanosecond, zone)
    of hdayUSBondMrktMemorialDay:
      result = holidayUSBondMrktMemorialDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSBondMrktJuneteenthIndependenceDay:
      result = holidayUSBondMrktJuneteenthIndependenceDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSBondMrktIndependenceDay:
      result = holidayUSBondMrktIndependenceDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSBondMrktLaborDay:
      result = holidayUSBondMrktLaborDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSBondMrktColumbusDay:
      result = holidayUSBondMrktColumbusDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSBondMrktThanksgivingDay:
      result = holidayUSBondMrktThanksgivingDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSBondMrktVeteransDay:
      result = holidayUSBondMrktVeteransDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSBondMrktChristmasDay:
      result = holidayUSFedGovtChristmasDay(year, hour, minute, second, nanosecond, zone)


proc holiday*(year: int, hday: bdHolidayUSNYSE, hour: HourRange = 0, 
              minute: MinuteRange = 0, second: SecondRange = 0, 
              nanosecond: NanosecondRange = 0, zone: TimeZone = local()): ?DateTime =
  ## Returns the holiday corresponding to the `<year>` and `<hday>` parameters (desired time can be specified).
  # 1st objective of this function: to guarantee that a procedure has been 
  # implemented for each item in the 'bdHolidayUSNYSE' enumeration.
  runnableExamples:
    doAssert:  !holiday(2022, hdayUSNYSENewYearsDay) ==~ dateTime(2022, mJan, 1)
    doAssert:  !holiday(2035, hdayUSNYSEMartinLutherKingBirthday) ==~ dateTime(2035, mJan, 15)
  case hday
    of hdayUSNYSENewYearsDay:
      result = holidayUSNYSENewYearsDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSNYSEMartinLutherKingBirthday:
      result = holidayUSNYSEMartinLutherKingBirthday(year, hour, minute, second, nanosecond, zone)
    of hdayUSNYSEWashingtonBirthday:
      result = holidayUSNYSEWashingtonBirthday(year, hour, minute, second, nanosecond, zone)
    of hdayUSNYSEGoodFriday:
      result = holidayUSNYSEGoodFriday(year, hour, minute, second, nanosecond, zone)
    of hdayUSNYSEMemorialDay:
      result = holidayUSNYSEMemorialDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSNYSEJuneteenthIndependenceDay:
      result = holidayUSNYSEJuneteenthIndependenceDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSNYSEIndependenceDay:
      result = holidayUSNYSEIndependenceDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSNYSELaborDay:
      result = holidayUSNYSELaborDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSNYSEThanksgivingDay:
      result = holidayUSNYSEThanksgivingDay(year, hour, minute, second, nanosecond, zone)
    of hdayUSNYSEChristmasDay:
      result = holidayUSNYSEChristmasDay(year, hour, minute, second, nanosecond, zone)


# =========================     isholiday  procs     ========================= #

proc isholidayUSFederalGovt*(dt: DateTime): bool =
  ##[
  **Returns:**
    - `true` if `dt` is a U.S. Federal Government holiday
    - `false` if `dt` is not a U.S. Federal Government holiday

  **Business days and holidays:**

    In the U.S. Federal Government, all days are working  days, with the exception for:
    - Saturdays and Sundays (weekends)
    - Holidays that are moved to Monday if it is Sunday, or to Friday if it is Saturday:
      - New Year's Day, January 1st
      - Juneteenth National Independence Day, June 19th, since 2021
      - Independence Day, July 4th
      - Veterans' Day, November 11th 
      - Christmas Day, December 25th
    - Holidays that are moved to Monday if it is Sunday:
      - Inauguration Day, January 20th
    - Other holidays:
      - Martin Luther King's birthday, third Monday in January, since 1986
      - Washington's Birthday, 3rd Monday in February
      - Memorial Day, last Monday in May 
      - Labor Day, 1st Monday in September
      - Columbus Day, 2nd Monday in October
      - Thanksgiving Day, 4th Thursday in November

  **References:**
    - https://en.wikipedia.org/wiki/Federal_holidays_in_the_United_States#List_of_federal_holidays
    - https://en.wikipedia.org/wiki/United_States_presidential_inauguration
  ]##
  runnableExamples:
    doAssert:  isholidayUSFederalGovt(dateTime(2021, mJan, 1)) # New Year's Day
    doAssert:  isholidayUSFederalGovt(dateTime(2021, mJan, 18)) # Martin Luther King
    doAssert:  isholidayUSFederalGovt(dateTime(2021, mJan, 20)) # Inauguration Day
    doAssert:  isholidayUSFederalGovt(dateTime(2021, mFeb, 15)) # Washington’s Birthday
    doAssert:  isholidayUSFederalGovt(dateTime(2021, mMay, 31)) # Memorial Day
    doAssert:  isholidayUSFederalGovt(dateTime(2021, mJun, 18)) # Juneteenth National Independence Day
    doAssert:  isholidayUSFederalGovt(dateTime(2021, mJul, 5)) # Independence Day
    doAssert:  isholidayUSFederalGovt(dateTime(2021, mSep, 6)) # Labor Day
    doAssert:  isholidayUSFederalGovt(dateTime(2021, mOct, 11)) # Columbus Day
    doAssert:  isholidayUSFederalGovt(dateTime(2021, mNov, 11)) # Veterans Day
    doAssert:  isholidayUSFederalGovt(dateTime(2021, mNov, 25)) # Thanksgiving Day
    doAssert:  isholidayUSFederalGovt(dateTime(2021, mDec, 24)) # Christmas Day
  let yy = dt.year
  let mm = dt.month
  let dd = dt.monthday
  let tz = dt.timezone
  if mm == mDec and dd == 31:  # December 31 is a borderline case
    if hday =? holidayUSFedGovtNewYearsDay(year = yy+1, zone = tz) and dt ==~ hday:  return true
  case mm
    of mJan..mJun:  # dichotomy for speed up the algorithm
      if hday =? holidayUSFedGovtNewYearsDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSFedGovtMartinLutherKingBirthday(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSFedGovtInaugurationDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSFedGovtWashingtonBirthday(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSFedGovtMemorialDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSFedGovtJuneteenthIndependenceDay(year = yy, zone = tz) and dt ==~ hday:  return true
    else:
      if hday =? holidayUSFedGovtIndependenceDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSFedGovtLaborDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSFedGovtColumbusDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSFedGovtThanksgivingDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSFedGovtVeteransDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSFedGovtChristmasDay(year = yy, zone = tz) and dt ==~ hday:  return true
  return false
 

proc isholidayUSBondMarket*(dt: DateTime): bool =
  ##[
  **Returns:**
    - `true` if `dt` is a public holiday on the U.S. Bond Market
    - `false` if `dt` is not a public holiday on the U.S. Bond Market

  **Business days and holidays:**

    On the U.S. Bond Market, all days are business days, with the exception of:
    - Saturdays and Sundays (weekends)
    - Holidays that are moved to Monday if it is Sunday, or to Friday if it is Saturday:
      - Juneteenth National Independence Day, June 19th, since 2022
      - Independence Day, July 4th
      - Christmas Day, December 25th
    - Holidays that are moved to Monday if it is Sunday:
      - New Year's Day, January 1st
      - Veterans' Day, November 11th 
    - Other holidays:
      - Martin Luther King's birthday, third Monday in January, since 1986
      - Washington's Birthday, 3rd Monday in February 
      - Good Friday
      - Memorial Day, last Monday in May
      - Labor Day, 1st Monday in September
      - Columbus Day, 2nd Monday in October
      - Thanksgiving Day, 4th Thursday in November
    - Special closings
      - President George H.W. Bush's funeral, December 5, 2018
      - etc.
  ]##
  runnableExamples:
    doAssert:  isholidayUSBondMarket(dateTime(2023, mJan, 2)) # New Year's Day
    doAssert:  isholidayUSBondMarket(dateTime(2022, mJan, 17)) # Martin Luther King
    doAssert:  isholidayUSBondMarket(dateTime(2022, mFeb, 21)) # Washington’s Birthday
    doAssert:  isholidayUSBondMarket(dateTime(2022, mApr, 15)) # Good Friday
    doAssert:  isholidayUSBondMarket(dateTime(2022, mMay, 30)) # Memorial Day
    doAssert:  isholidayUSBondMarket(dateTime(2022, mJun, 20)) # Juneteenth National Independence Day
    doAssert:  isholidayUSBondMarket(dateTime(2022, mJul, 4)) # Independence Day
    doAssert:  isholidayUSBondMarket(dateTime(2022, mSep, 5)) # Labor Day
    doAssert:  isholidayUSBondMarket(dateTime(2022, mOct, 10)) # Columbus Day
    doAssert:  isholidayUSBondMarket(dateTime(2022, mNov, 11)) # Veterans Day
    doAssert:  isholidayUSBondMarket(dateTime(2022, mNov, 24)) # Thanksgiving Day
    doAssert:  isholidayUSBondMarket(dateTime(2022, mDec, 26)) # Christmas Day

  let yy = dt.year
  let mm = dt.month
  let dd = dt.monthday
  let tz = dt.timezone

  # Official Closings
  # -----------------
  if mm == mDec and dd == 31:  # December 31 is a borderline case
    if hday =? holidayUSBondMrktNewYearsDay(year = yy+1, zone = tz) and dt ==~ hday:  return true
  case mm
    of mJan..mJun:
      if hday =? holidayUSBondMrktNewYearsDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSBondMrktMartinLutherKingBirthday(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSBondMrktWashingtonBirthday(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSBondMrktGoodFriday(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSBondMrktMemorialDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSBondMrktJuneteenthIndependenceDay(year = yy, zone = tz) and dt ==~ hday:  return true
    else:
      if hday =? holidayUSBondMrktIndependenceDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSBondMrktLaborDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSBondMrktColumbusDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSBondMrktThanksgivingDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSBondMrktVeteransDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSBondMrktChristmasDay(year = yy, zone = tz) and dt ==~ hday:  return true
  
  # Special Closings
  # ----------------

  # President George H.W. Bush's funeral
  # <https://www.newyorkfed.org/markets/opolicy/operating_policy_181204>
  if dt ==~ dateTime(2018, mDec, 5.MonthdayRange):  return true

  return false


proc isholidayUSNYSE*(dt: DateTime): bool =
  ##[
  **Returns:**
    - `true` if `dt` is a New York Stock Exchange holiday
    - `false` if `dt` is not a New York Stock Exchange holiday

  **Business days and holidays:**

    On the New York Stock Exchange, all days are business days, with the exception of:
    - Saturdays and Sundays (weekends)
    - Holidays that are moved to Monday if it is Sunday:
      - New Year's Day, January 1st
    - Holidays that are moved to Monday if it is Sunday, or to Friday if it is Saturday:
      - Juneteenth National Independence Day, June 19th, since 2023
      - Independence Day, July 4th
      - Christmas Day, December 25th
    - Other holidays:
      - Martin Luther King's birthday, third Monday in January, since 1998
      - Washington's Birthday, 3rd Monday in February
      - Good Friday
      - Memorial Day, last Monday in May	  
      - Labor Day, 1st Monday in September
      - Thanksgiving Day, 4th Thursday in November
    - Special closings:
      - President George H.W. Bush's funeral, December 5, 2018
      - Hurricane Sandy, October 29-30, 2012
      - etc.
  ]##
  runnableExamples:    
    doAssert:  isholidayUSNYSE(dateTime(2023, mJan, 2)) # New Year's Day
    doAssert:  isholidayUSNYSE(dateTime(2023, mJan, 16)) # Martin Luther King
    doAssert:  isholidayUSNYSE(dateTime(2023, mFeb, 20)) # Washington’s Birthday
    doAssert:  isholidayUSNYSE(dateTime(2023, mApr, 7)) # Good Friday
    doAssert:  isholidayUSNYSE(dateTime(2023, mMay, 29)) # Memorial Day
    doAssert:  isholidayUSNYSE(dateTime(2023, mJun, 19)) # Juneteenth National Independence Day
    doAssert:  isholidayUSNYSE(dateTime(2023, mJul, 4)) # Independence Day
    doAssert:  isholidayUSNYSE(dateTime(2023, mSep, 4)) # Labor Day
    doAssert:  isholidayUSNYSE(dateTime(2023, mNov, 23)) # Thanksgiving Day
    doAssert:  isholidayUSNYSE(dateTime(2023, mDec, 25)) # Christmas Day

  if dt.year < 1970:  return false

  let yy = dt.year
  let mm = dt.month
  let dd = dt.monthday
  let tz = dt.timezone
  #let dayOfWeek = getDayOfWeek(dt)

  # Official Closings
  # -----------------
  case mm
    of mJan..mJun:
      if hday =? holidayUSNYSENewYearsDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSNYSEMartinLutherKingBirthday(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSNYSEWashingtonBirthday(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSNYSEGoodFriday(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSNYSEMemorialDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSNYSEJuneteenthIndependenceDay(year = yy, zone = tz) and dt ==~ hday:  return true
    else:
      if hday =? holidayUSNYSEIndependenceDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSNYSELaborDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSNYSEElectionDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSNYSEThanksgivingDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUSNYSEChristmasDay(year = yy, zone = tz) and dt ==~ hday:  return true

  # Special Closings
  # ----------------
  # President George H.W. Bush's funeral
  # <https://www.newyorkfed.org/markets/opolicy/operating_policy_181204>
  if yy == 2018:  return (mm == mDec and dd == 5)
  # Hurricane Sandy
  elif yy == 2012:  return (mm == mOct and (dd == 29 or dd == 30))
  # Predient Ford's funeral
  elif yy == 2007:  return (mm == mJan and dd == 2)
  # President Reagan's funeral
  elif yy == 2004:  return (mm == mJun and dd == 11)
  # Sep 11th, 2001
  elif yy == 2001:  return (mm == mSep and (11 <= dd and dd <= 14))
  # President Nixon's funeral
  elif yy == 1994: return (mm == mApr and dd == 27)
  # Hurricane Gloria
  elif yy == 1985:  return (mm == mSep and dd == 27) 
  # Election Day
  if yy <= 1968 or yy in [1972, 1976, 1980]:
    if electionDay =? holidayUSNYSEElectionDay(yy) and dt ==~ electionDay: return true 
  # 1977 Blackout
  elif yy == 1977:  return (mm == mJul and dd == 14)
  # Funeral of former President Lyndon B. Johnson
  elif yy == 1973:  return (mm == mJan and dd == 25)
  # Funeral of former President Harry S. Truman
  elif yy == 1972:  return (mm == mDec and dd == 28)
  
  return false
#[  
  if yy == 1969:
    return ( (mm == mJul and dd == 21) or # National Day of Participation for the lunar exploration
             (mm == mMar and dd == 31) or # Eisenhower's funeral
             (mm == mFeb and dd == 10)    # Heavy snow
           )
  # Day after Independence Day
  if yy == 1968 and mm == mJul and dd == 5:  return true
  # Paperwork Crisis
  if yy == 1968 and dayOfWeek == dWed and 
      (month: mJun, monthday: 12) <= (month: mm, monthday: dd):  
    return true
  # Mourning for Martin Luther King Jr
  if yy == 1968 and mm == mApr and dd == 9:  return true
  # Christmas Eve
  if mm == mDec and dd == 24 and yy in [1965, 1956, 1954, 1945, 1900]: 
    return true
  # President Kennedy's funeral
  if yy == 1963 and mm == mNov and dd == 25:  return true
  # Day before Decoration Day
  if yy == 1961 and mm == mMay and dd == 29:  return true
  # Day after Christmas
  if yy == 1958 and mm == mDec and dd == 26:  return true
  # Lincoln's Birthday
  if 1896 <= yy and yy <= 1953 and mm == mFeb and dd == 12:  return true
  # Columbus Day
  if 1909 <= yy and yy <= 1953 and mm == mOct and dd == 12:  return true
  # Veteran's Day
  if dd == 11 and mm == mNov and 
       (yy == 1918 or yy == 1921 or (1934 <= yy and yy <= 1953)):  return true
  # V-J Day. End of World War II.
  if yy == 1945 and mm == mAug and (dd == 15 or dd == 16):  return true
  # National banking holiday.
  if yy == 1933 and mm == mMar and 6 <= dd and dd <= 14:  return true  
  # Parade for Colonel Charles A. Lindbergh.
  if yy == 1927 and mm == mJun and dd == 13:  return true
  # Funeral of President Warren G. Harding at Marion, Ohio.
  # Death of President Warren G. Harding.
  if yy == 1923 and mm == mAug and (dd == 10 or dd == 3):  return true
  # Return of General John J. Pershing.
  if yy == 1919 and mm == mSep and dd == 10:  return true
  # Parade of 77th Division.
  if yy == 1919 and mm == mMay and dd == 6:  return true
  # Homecoming of 27th Division.
  if yy == 1919 and mm == mMar and dd == 25:  return true
  # Armistice signed.
  if yy == 1918 and mm == mNov and dd == 11:  return true
  # Draft registration day.
  if yy == 1918 and mm == mSep and dd == 12:  return true
  if yy == 1917 and mm == mJun and dd == 5:  return true
  # Heatless day.
  if yy == 1918:
    if mm == mJan and dd == 28:  return true
    if mm == mFeb and (dd == 4 or dd == 11):  return true
  # World War I
  # it is not easy to determine the exact days of closure, partial or total
  if yy == 1914 or yy == 1915:  return none(bool)
  # Opening of new NYSE building.
  if yy == 1903 and mm == mApr and dd == 22:  return true
  # Funeral of President William McKinley.
  if yy == 1901 and mm == mSep and dd == 19:  return true
  # Days after Independence Day.
  if yy == 1901 and mm == mJul and dd == 5:  return true
  # Admiral Dewey Celebration.
  if yy == 1899 and mm == mSep and dd == 29:  return true
  # Monday before Independence Day.
  if yy == 1899 and mm == mJul and dd == 3:  return true
  # Monday before Decoration Day.
  if yy == 1899 and mm == mMay and dd == 29:  return true
  # Charter Day.
  if yy == 1898 and mm == mMay and dd == 4:  return true
  # Grant's birthday.
  if yy == 1897 and mm == mApr and dd == 27:  return true
  # Columbian Celebration.
  if yy == 1892 and mm == mOct and dd in [12,21]:  return true
  if yy == 1893 and mm == mApr and dd == 27:  return true
  # Centennial celebration of Washington's inauguration.
  if yy == 1889:
    if mm == mApr and (dd == 30 or dd == 30):  return true
    if mm == mMay and dd == 1:  return true
  # 1888
  if yy == 1888: 
    # Friday after Thanksgiving Day.
    if mm == mNov and dd == 30:  return true
    # Blizzard of 1888.
    if mm == mMar and (dd == 12 or dd == 13):  return true
]#