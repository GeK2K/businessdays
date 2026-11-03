##[
===========
holidays_uk
===========

Holidays in the United Kingdom of Great Britain.
]##

# =========================     Imports / Exports     ======================== #

import  questionable, nimutils/[nutimes], ./private/[easter_days]
export  questionable, nutimes


# =============================     Includes     ============================= #

include  ./private/[useful_templates]


# ===========================     Enumerations     =========================== #

type
  bdHolidayUKEngland* = enum
    ## Holidays in England.
    hdayUKEngNewYearsDay, hdayUKEngGoodFriday, hdayUKEngEarlyMay, hdayUKEngEasterMonday,
    hdayUKEngSpringBank, hdayUKEngSummerBank, hdayUKEngChristmasDay, hdayUKEngBoxingDay,

  bdHolidayUKNorthenIreland* = enum
    ## Holidays in Northen Ireland.
    hdayUKNirNewYearsDay, hdayUKNirStPatricksDay, hdayUKNirGoodFriday, hdayUKNirEarlyMay,
    hdayUKNirEasterMonday, hdayUKNirSpringBank, hdayUKNirSummerBank, hdayUKNirOrangemensDay,
    hdayUKNirChristmasDay, hdayUKNirBoxingDay,

  bdHolidayUKScotland* = enum
    ## Holidays in Scotland.
    hdayUKSctNewYearsDay, hdayUKSctJanuary2, hdayUKSctGoodFriday, hdayUKSctEarlyMay,
    hdayUKSctSpringBank, hdayUKSctSummerBank, hdayUKSctStAndrewsDay, hdayUKSctChristmasDay, 
    hdayUKSctBoxingDay,


# ===========================     Special dates     ========================== #

# New Year’s Day, January 1st
defineSpecialDate(NewYearsDay, newYearsDay, mJan, 1):
  runnableExamples:
    # the 'New Year’s Day (January 1st)' of the year received as a parameter
    doAssert:  newYearsDay(2016) ==~ dateTime(2016, mJan, 1)

# Saint Patrick's Day, March 17
defineSpecialDate(StPatricksDay, stPatricksDay, mMar, 17):
  runnableExamples:
    # the 'Saint Patrick’s Day (March 17)' of the year received as a parameter
    doAssert:  stPatricksDay(2016) ==~ dateTime(2016, mMar, 17)

# Orangemens’ Day, July 12
defineSpecialDate(OrangemensDay, orangemensDay, mJul, 12):
  runnableExamples:
    # the 'Orangemens’ Day (July 12)' of the year received as a parameter
    doAssert:  orangemensDay(2016) ==~ dateTime(2016, mJul, 12)

# St Andrew’s Day, November 30
defineSpecialDate(StAndrewsDay, stAndrewsDay, mNov, 30):
  runnableExamples:
    # the 'St Andrew’s Day (November 30)' of the year received as a parameter
    doAssert:  stAndrewsDay(2016) ==~ dateTime(2016, mNov, 30)

# Christmas Day, December 25th
defineSpecialDate(ChristmasDay, christmasDay, mDec, 25):
  runnableExamples:
    # the 'Christmas Day (December 25)' of the year received as a parameter
    doAssert:  christmasDay(2016) ==~ dateTime(2016, mDec, 25)

# Boxing Day, December 26th
defineSpecialDate(BoxingDay, boxingDay, mDec, 26):
  runnableExamples:
    # the 'Boxing Day (December 26)' of the year received as a parameter
    doAssert:  boxingDay(2016) ==~ dateTime(2016, mDec, 26)


# =========================     holidayXXX  procs     ======================== #

# New Year’s Day (January 1st)
# ----------------------------

proc holidayUKEngNewYearsDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                              second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                              zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the English *New Year’s Day* of the year 
  received in parameter (desired time can be specified). 
  
  **Notes:**
    - The `isholidayUKEngland <#isholidayUKEngland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKEngNewYearsDay(2023) ==~ dateTime(2023, mJan, 2)  # Monday
    doAssert:  !holidayUKEngNewYearsDay(2022) ==~ dateTime(2022, mJan, 3)  # Monday
    doAssert:  !holidayUKEngNewYearsDay(2021) ==~ dateTime(2021, mJan, 1)  # Friday
    doAssert:  !holiday(2023, hdayUKEngNewYearsDay) ==~ dateTime(2023, mJan, 2)  # Monday
    doAssert:  !holiday(2022, hdayUKEngNewYearsDay) ==~ dateTime(2022, mJan, 3)  # Monday
    doAssert:  !holiday(2021, hdayUKEngNewYearsDay) ==~ dateTime(2021, mJan, 1)  # Friday
  dateTime(year, NewYearsDay.month, NewYearsDay.monthday, 
           hour, minute, second, nanosecond, zone).nextMondayIfWeekend.some


proc holidayUKNirNewYearsDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                              second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                              zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *New Year’s Day* in Northern Ireland for the year 
  received in parameter (desired time can be specified). 
  
  **Notes:**
    - The `isholidayUKNorthenIreland <#isholidayUKNorthenIreland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKNirNewYearsDay(2023) ==~ dateTime(2023, mJan, 2)  # Monday
    doAssert:  !holidayUKNirNewYearsDay(2022) ==~ dateTime(2022, mJan, 3)  # Monday
    doAssert:  !holidayUKNirNewYearsDay(2021) ==~ dateTime(2021, mJan, 1)  # Friday
    doAssert:  !holiday(2023, hdayUKNirNewYearsDay) ==~ dateTime(2023, mJan, 2)  # Monday
    doAssert:  !holiday(2022, hdayUKNirNewYearsDay) ==~ dateTime(2022, mJan, 3)  # Monday
    doAssert:  !holiday(2021, hdayUKNirNewYearsDay) ==~ dateTime(2021, mJan, 1)  # Friday
  dateTime(year, NewYearsDay.month, NewYearsDay.monthday, 
           hour, minute, second, nanosecond, zone).nextMondayIfWeekend.some


proc holidayUKSctNewYearsDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                              second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                              zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the Scottish *New Year’s Day* of the year 
  received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKScotland <#isholidayUKScotland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKSctNewYearsDay(2023) ==~ dateTime(2023, mJan, 2)  # Monday
    doAssert:  !holidayUKSctNewYearsDay(2022) ==~ dateTime(2022, mJan, 3)  # Monday
    doAssert:  !holidayUKSctNewYearsDay(2021) ==~ dateTime(2021, mJan, 1)  # Friday
    doAssert:  !holiday(2023, hdayUKSctNewYearsDay) ==~ dateTime(2023, mJan, 2)  # Monday
    doAssert:  !holiday(2022, hdayUKSctNewYearsDay) ==~ dateTime(2022, mJan, 3)  # Monday
    doAssert:  !holiday(2021, hdayUKSctNewYearsDay) ==~ dateTime(2021, mJan, 1)  # Friday
  dateTime(year, NewYearsDay.month, NewYearsDay.monthday, 
           hour, minute, second, nanosecond, zone).nextMondayIfWeekend.some


# January 2 in Scotland
# ---------------------

proc holidayUKSctJanuary2*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                           second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                           zone: Timezone = local()): ?DateTime {.inline.} =
  ## Returns the *first weekday after New Year's Day* of the 
  ## year received in parameter (desired time can be specified).  
  runnableExamples:
    # The date of this public holiday can be obtained in two different
    # but equivalent ways (the first one must be favored).
    doAssert:  !holidayUKSctJanuary2(2020) ==~ dateTime(2020, mJan, 2)  # Thursday
    doAssert:  !holidayUKSctJanuary2(2021) ==~ dateTime(2021, mJan, 4)  # Monday
    doAssert:  !holidayUKSctJanuary2(2022) ==~ dateTime(2022, mJan, 4)  # Tuesday
    doAssert:  !holiday(2020, hdayUKSctJanuary2) ==~ dateTime(2020, mJan, 2)  # Thursday
    doAssert:  !holiday(2021, hdayUKSctJanuary2) ==~ dateTime(2021, mJan, 4)  # Monday
    doAssert:  !holiday(2022, hdayUKSctJanuary2) ==~ dateTime(2022, mJan, 4)  # Tuesday
  holidayUKSctNewYearsDay(year, hour, minute, second, nanosecond, zone).?nextWorkday


# Saint Patrick’s Day (March 17) in Northern Ireland
# --------------------------------------------------

proc holidayUKNirStPatricksDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Saint Patrick’s Day* in Northern Ireland for the  
  year received in parameter (desired time can be specified). 
  
  **Notes:**
    - The `isholidayUKNorthenIreland <#isholidayUKNorthenIreland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKNirStPatricksDay(2019) ==~ dateTime(2019, mMar, 18)  # Monday
    doAssert:  !holidayUKNirStPatricksDay(2018) ==~ dateTime(2018, mMar, 19)  # Monday
    doAssert:  !holidayUKNirStPatricksDay(2020) ==~ dateTime(2020, mMar, 17)  # Tuesday
    doAssert:  !holiday(2019, hdayUKNirStPatricksDay) ==~ dateTime(2019, mMar, 18)  # Monday
    doAssert:  !holiday(2018, hdayUKNirStPatricksDay) ==~ dateTime(2018, mMar, 19)  # Monday
    doAssert:  !holiday(2020, hdayUKNirStPatricksDay) ==~ dateTime(2020, mMar, 17)  # Tuesday
  dateTime(year, StPatricksDay.month, StPatricksDay.monthday, 
           hour, minute, second, nanosecond, zone).nextMondayIfWeekend.some


# Good Friday
# -----------

# Good Friday observed in England
proc holidayUKEngGoodFriday*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                             second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                             zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Good Friday* of the year received
  in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKEngland <#isholidayUKEngland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKEngGoodFriday(2018) ==~ dateTime(2018, mMar, 30)
    doAssert:  !holiday(2018, hdayUKEngGoodFriday) ==~ dateTime(2018, mMar, 30)
  holidayGoodFriday(year, hour, minute, second, nanosecond, zone)


# Good Friday observed in Northen Ireland
proc holidayUKNirGoodFriday*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                             second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                             zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Good Friday* of the year received
  in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKNorthenIreland <#isholidayUKNorthenIreland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKNirGoodFriday(2018) ==~ dateTime(2018, mMar, 30)
    doAssert:  !holiday(2018, hdayUKNirGoodFriday) ==~ dateTime(2018, mMar, 30)
  holidayGoodFriday(year, hour, minute, second, nanosecond, zone)


# Good Friday observed in Scotland
proc holidayUKSctGoodFriday*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                             second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                             zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Good Friday* of the year received
  in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKScotland <#isholidayUKScotland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKSctGoodFriday(2018) ==~ dateTime(2018, mMar, 30)
    doAssert:  !holiday(2018, hdayUKSctGoodFriday) ==~ dateTime(2018, mMar, 30)
  holidayGoodFriday(year, hour, minute, second, nanosecond, zone)
 

# Easter Monday
# -------------

# Easter Monday observed in England
proc holidayUKEngEasterMonday*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                               second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                               zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Easter Monday* of the year received
  in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKEngland <#isholidayUKEngland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKEngEasterMonday(2018) ==~ dateTime(2018, mApr, 2)
    doAssert:  !holiday(2018, hdayUKEngEasterMonday) ==~ dateTime(2018, mApr, 2)
  holidayEasterMonday(year, hour, minute, second, nanosecond, zone)


# Easter Monday observed in Northen Ireland
proc holidayUKNirEasterMonday*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                               second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                               zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Easter Monday* of the year received
  in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKNorthenIreland <#isholidayUKNorthenIreland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKNirEasterMonday(2018) ==~ dateTime(2018, mApr, 2)
    doAssert:  !holiday(2018, hdayUKNirEasterMonday) ==~ dateTime(2018, mApr, 2)
  holidayEasterMonday(year, hour, minute, second, nanosecond, zone)


# Early May bank holiday, 1st Monday in May
# -----------------------------------------

proc holidayUKEarlyMay(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                       second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                       zone: Timezone = local()): ?DateTime =
  if year == 2020:  # 75th anniversary of victory in europe
    result = dateTime(2020, mMay, 8, hour, minute, second, nanosecond, zone).some
  else:
    let monthday = nthWeekday(1, dMon, mMay, year)
    assert: monthday.isSome
    result = dateTime(year, mMay, !monthday, hour, minute, second, nanosecond, zone).some


proc holidayUKEngEarlyMay*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                           second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                           zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Early May bank holiday (1st Monday in May)* of 
  the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKEngland <#isholidayUKEngland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKEngEarlyMay(2019) ==~ dateTime(2019, mMay, 6)
    doAssert:  !holiday(2019, hdayUKEngEarlyMay) ==~ dateTime(2019, mMay, 6)
  holidayUKEarlyMay(year, hour, minute, second, nanosecond, zone)


proc holidayUKNirEarlyMay*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                           second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                           zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Early May bank holiday (1st Monday in May)* of 
  the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKNorthenIreland <#isholidayUKNorthenIreland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKNirEarlyMay(2019) ==~ dateTime(2019, mMay, 6)
    doAssert:  !holiday(2019, hdayUKNirEarlyMay) ==~ dateTime(2019, mMay, 6)
  holidayUKEarlyMay(year, hour, minute, second, nanosecond, zone)


proc holidayUKSctEarlyMay*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                           second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                           zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Early May bank holiday (1st Monday in May)* of 
  the year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKScotland <#isholidayUKScotland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKSctEarlyMay(2019) ==~ dateTime(2019, mMay, 6)
    doAssert:  !holiday(2019, hdayUKSctEarlyMay) ==~ dateTime(2019, mMay, 6)
  holidayUKEarlyMay(year, hour, minute, second, nanosecond, zone)


# Spring bank holiday, last Monday in May
# ---------------------------------------

proc holidayUKSpringBank(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                         second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                         zone: Timezone = local()): ?DateTime =
  if year == 2022:  # day before the Platinum Jubilee bank holiday
    result = dateTime(2022, mJun, 2, hour, minute, second, nanosecond, zone).some
  else:
    let monthday = nthWeekday(-1, dMon, mMay, year)
    assert: monthday.isSome
    result = dateTime(year, mMay, !monthday, hour, minute, second, nanosecond, zone).some


proc holidayUKEngSpringBank*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                             second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                             zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Spring bank holiday (last Monday in May)* of the 
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKEngland <#isholidayUKEngland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different 
    # but equivalent ways (the first one must be favored).
    doAssert:  !holidayUKEngSpringBank(2020) ==~ dateTime(2020, mMay, 25)
    doAssert:  !holiday(2020, hdayUKEngSpringBank) ==~ dateTime(2020, mMay, 25)
  holidayUKSpringBank(year, hour, minute, second, nanosecond, zone)


proc holidayUKNirSpringBank*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                             second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                             zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Spring bank holiday (last Monday in May)* of the 
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKNorthenIreland <#isholidayUKNorthenIreland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different 
    # but equivalent ways (the first one must be favored).
    doAssert:  !holidayUKNirSpringBank(2020) ==~ dateTime(2020, mMay, 25)
    doAssert:  !holiday(2020, hdayUKNirSpringBank) ==~ dateTime(2020, mMay, 25)
  holidayUKSpringBank(year, hour, minute, second, nanosecond, zone)


proc holidayUKSctSpringBank*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                             second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                             zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Spring bank holiday (last Monday in May)* of the 
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKScotland <#isholidayUKScotland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different 
    # but equivalent ways (the first one must be favored).
    doAssert:  !holidayUKSctSpringBank(2020) ==~ dateTime(2020, mMay, 25)
    doAssert:  !holiday(2020, hdayUKSctSpringBank) ==~ dateTime(2020, mMay, 25)
  holidayUKSpringBank(year, hour, minute, second, nanosecond, zone)


# Orangemen’s Day observed in Northen Ireland, July 12
# ----------------------------------------------------

proc holidayUKNirOrangemensDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                                second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                                zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Orangemen’s Day* in Northern Ireland  of the 
  year received in parameter (desired time can be specified). 
  
  **Notes:**
    - The `isholidayUKNorthenIreland <#isholidayUKNorthenIreland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKNirOrangemensDay(2026) ==~ dateTime(2026, mJul, 13)  # Monday
    doAssert:  !holidayUKNirOrangemensDay(2025) ==~ dateTime(2025, mJul, 14)  # Monday
    doAssert:  !holidayUKNirOrangemensDay(2024) ==~ dateTime(2024, mJul, 12)  # Friday
    doAssert:  !holiday(2026, hdayUKNirOrangemensDay) ==~ dateTime(2026, mJul, 13)  # Monday
    doAssert:  !holiday(2025, hdayUKNirOrangemensDay) ==~ dateTime(2025, mJul, 14)  # Monday
    doAssert:  !holiday(2024, hdayUKNirOrangemensDay) ==~ dateTime(2024, mJul, 12)  # Friday
  dateTime(year, OrangemensDay.month, OrangemensDay.monthday, 
           hour, minute, second, nanosecond, zone).nextMondayIfWeekend.some


# Summer bank holiday
# -------------------

proc holidayUKEngSummerBank*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                             second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                             zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Summer bank holiday (last Monday in August)* of the 
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKEngland <#isholidayUKEngland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different 
    # but equivalent ways (the first one must be favored).
    doAssert:  !holidayUKEngSummerBank(2018) ==~ dateTime(2018, mAug, 27)
    doAssert:  !holiday(2018, hdayUKEngSummerBank) ==~ dateTime(2018, mAug, 27)
  let monthday = nthWeekday(-1, dMon, mAug, year)
  assert: monthday.isSome
  result = dateTime(year, mAug, !monthday, hour, minute, second, nanosecond, zone).some


proc holidayUKNirSummerBank*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                             second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                             zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Summer bank holiday (last Monday in August)* of the 
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKNorthenIreland <#isholidayUKNorthenIreland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different 
    # but equivalent ways (the first one must be favored).
    doAssert:  !holidayUKNirSummerBank(2018) ==~ dateTime(2018, mAug, 27)
    doAssert:  !holiday(2018, hdayUKNirSummerBank) ==~ dateTime(2018, mAug, 27)
  let monthday = nthWeekday(-1, dMon, mAug, year)
  assert: monthday.isSome
  result = dateTime(year, mAug, !monthday, hour, minute, second, nanosecond, zone).some


proc holidayUKSctSummerBank*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                             second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                             zone: Timezone = local()): ?DateTime =
  ##[
  Returns the *Summer bank holiday (first Monday in August)* of the 
  year received in parameter (desired time can be specified).
  
  **Notes:**
    - The `isholidayUKScotland <#isholidayUKScotland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different 
    # but equivalent ways (the first one must be favored).
    doAssert:  !holidayUKSctSummerBank(2018) ==~ dateTime(2018, mAug, 6)
    doAssert:  !holiday(2018, hdayUKSctSummerBank) ==~ dateTime(2018, mAug, 6)
  let monthday = nthWeekday(1, dMon, mAug, year)
  assert: monthday.isSome
  result = dateTime(year, mAug, !monthday, hour, minute, second, nanosecond, zone).some


# St Andrew’s Day observed in Scotland, November 30
# -------------------------------------------------

proc holidayUKSctStAndrewsDay*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                               second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                               zone: Timezone = local()): ?DateTime {.inline.} =
  ##[
  Returns the *Saint Andrew’s Day* of the year received 
  in parameter (desired time can be specified).

  **Notes:**
    - The `isholidayUKScotland <#isholidayUKScotland,DateTime>`_  
      `proc` contains some useful basic definitions.
  ]##
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKSctStAndrewsDay(2025) ==~ dateTime(2025, mDec, 1)  # Monday
    doAssert:  !holidayUKSctStAndrewsDay(2019) ==~ dateTime(2019, mDec, 2)  # Monday
    doAssert:  !holidayUKSctStAndrewsDay(2018) ==~ dateTime(2018, mNov, 30)  # Friday
    doAssert:  !holiday(2025, hdayUKSctStAndrewsDay) ==~ dateTime(2025, mDec, 1)  # Monday
    doAssert:  !holiday(2019, hdayUKSctStAndrewsDay) ==~ dateTime(2019, mDec, 2)  # Monday
    doAssert:  !holiday(2018, hdayUKSctStAndrewsDay) ==~ dateTime(2018, mNov, 30)  # Friday
  dateTime(year, StAndrewsDay.month, StAndrewsDay.monthday, 
           hour, minute, second, nanosecond, zone).nextMondayIfWeekend.some


# Christmas Day, December 25
# --------------------------

proc holidayUKChristmasDay(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                           second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                           zone: Timezone = local()): ?DateTime =
  let dayOfWeek = getDayOfWeek(christmasDay(year))
  if dayOfWeek in {dSat, dSun}:  
    result = dateTime(year, mDec, 27, hour, minute, second, nanosecond, zone).some
  else:  
    result = dateTime(year, mDec, 25, hour, minute, second, nanosecond, zone).some


proc holidayUKEngChristmasDay*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                               second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                               zone: Timezone = local()): ?DateTime {.inline.} =
  ##[ 
  Returns the *Christmas Day* of the year received in 
  parameter (desired time can be specified), that is:
    - December 27, if December 25 is a Saturday or Sunday;
    - December 25, in all other cases
  ]##  
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKEngChristmasDay(2021) ==~ dateTime(2021, mDec, 27)  # Monday
    doAssert:  !holidayUKEngChristmasDay(2023) ==~ dateTime(2023, mDec, 25)  # Monday
    doAssert:  !holiday(2021, hdayUKEngChristmasDay) ==~ dateTime(2021, mDec, 27)  # Monday
    doAssert:  !holiday(2023, hdayUKEngChristmasDay) ==~ dateTime(2023, mDec, 25)  # Monday	
  holidayUKChristmasDay(year, hour, minute, second, nanosecond, zone)


proc holidayUKNirChristmasDay*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                               second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                               zone: Timezone = local()): ?DateTime {.inline.} =
  ##[ 
  Returns the *Christmas Day* of the year received in 
  parameter (desired time can be specified), that is:
    - December 27, if December 25 is a Saturday or Sunday;
    - December 25, in all other cases
  ]##  
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKNirChristmasDay(2021) ==~ dateTime(2021, mDec, 27)  # Monday
    doAssert:  !holidayUKNirChristmasDay(2023) ==~ dateTime(2023, mDec, 25)  # Monday
    doAssert:  !holiday(2021, hdayUKNirChristmasDay) ==~ dateTime(2021, mDec, 27)  # Monday
    doAssert:  !holiday(2023, hdayUKNirChristmasDay) ==~ dateTime(2023, mDec, 25)  # Monday	
  holidayUKChristmasDay(year, hour, minute, second, nanosecond, zone)


proc holidayUKSctChristmasDay*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                               second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                               zone: Timezone = local()): ?DateTime {.inline.} =
  ##[ 
  Returns the *Christmas Day* of the year received in 
  parameter (desired time can be specified), that is:
    - December 27, if December 25 is a Saturday or Sunday;
    - December 25, in all other cases
  ]##  
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKSctChristmasDay(2021) ==~ dateTime(2021, mDec, 27)  # Monday
    doAssert:  !holidayUKSctChristmasDay(2023) ==~ dateTime(2023, mDec, 25)  # Monday
    doAssert:  !holiday(2021, hdayUKSctChristmasDay) ==~ dateTime(2021, mDec, 27)  # Monday
    doAssert:  !holiday(2023, hdayUKSctChristmasDay) ==~ dateTime(2023, mDec, 25)  # Monday	
  holidayUKChristmasDay(year, hour, minute, second, nanosecond, zone)


# Boxing Day, December 26
# -----------------------

proc holidayUKBoxingDay(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                        second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                        zone: Timezone = local()): ?DateTime =
  let dayOfWeek = getDayOfWeek(boxingDay(year))
  if dayOfWeek in {dSat, dSun}:  
    result = dateTime(year, mDec, 28, hour, minute, second, nanosecond, zone).some
  else:  
    result = dateTime(year, mDec, 26, hour, minute, second, nanosecond, zone).some


proc holidayUKEngBoxingDay*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                            second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                            zone: Timezone = local()): ?DateTime {.inline.} =
  ##[ 
  Returns the *Boxing Day* of the year received in 
  parameter (desired time can be specified), that is:
    - December 28, if December 26 is a Saturday or Sunday;
    - December 26, in all other cases
  ]##  
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKEngBoxingDay(2021) ==~ dateTime(2021, mDec, 28)  # Tuesday
    doAssert:  !holidayUKEngBoxingDay(2023) ==~ dateTime(2023, mDec, 26)  # Tuesday
    doAssert:  !holiday(2021, hdayUKEngBoxingDay) ==~ dateTime(2021, mDec, 28)  # Tuesday
    doAssert:  !holiday(2023, hdayUKEngBoxingDay) ==~ dateTime(2023, mDec, 26)  # Tuesday
  holidayUKBoxingDay(year, hour, minute, second, nanosecond, zone)


proc holidayUKNirBoxingDay*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                            second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                            zone: Timezone = local()): ?DateTime {.inline.} =
  ##[ 
  Returns the *Boxing Day* of the year received in 
  parameter (desired time can be specified), that is:
    - December 28, if December 26 is a Saturday or Sunday;
    - December 26, in all other cases
  ]##  
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKNirBoxingDay(2021) ==~ dateTime(2021, mDec, 28)  # Tuesday
    doAssert:  !holidayUKNirBoxingDay(2023) ==~ dateTime(2023, mDec, 26)  # Tuesday
    doAssert:  !holiday(2021, hdayUKNirBoxingDay) ==~ dateTime(2021, mDec, 28)  # Tuesday
    doAssert:  !holiday(2023, hdayUKNirBoxingDay) ==~ dateTime(2023, mDec, 26)  # Tuesday
  holidayUKBoxingDay(year, hour, minute, second, nanosecond, zone)


proc holidayUKSctBoxingDay*(year: int; hour: HourRange = 0;  minute: MinuteRange = 0;
                            second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                            zone: Timezone = local()): ?DateTime {.inline.} =
  ##[ 
  Returns the *Boxing Day* of the year received in 
  parameter (desired time can be specified), that is:
    - December 28, if December 26 is a Saturday or Sunday;
    - December 26, in all other cases
  ]##  
  runnableExamples:
    # This public holiday can be obtained in two different but
    # equivalent ways (the former should often be preferred).
    doAssert:  !holidayUKSctBoxingDay(2021) ==~ dateTime(2021, mDec, 28)  # Tuesday
    doAssert:  !holidayUKSctBoxingDay(2023) ==~ dateTime(2023, mDec, 26)  # Tuesday
    doAssert:  !holiday(2021, hdayUKSctBoxingDay) ==~ dateTime(2021, mDec, 28)  # Tuesday
    doAssert:  !holiday(2023, hdayUKSctBoxingDay) ==~ dateTime(2023, mDec, 26)  # Tuesday
  holidayUKBoxingDay(year, hour, minute, second, nanosecond, zone)


# ==========================     holiday  procs     ========================== #

proc holiday*(year: int, hday: bdHolidayUKEngland, hour: HourRange = 0, 
              minute: MinuteRange = 0, second: SecondRange = 0, 
              nanosecond: NanosecondRange = 0, zone: TimeZone = local()): ?DateTime =
  ## Returns the holiday corresponding to the `<year>` and `<hday>` parameters (desired time can be specified).
  # 1st objective of this function: to guarantee that a procedure has been 
  # implemented for each item in the 'bdHolidayUKEngland' enumeration.
  runnableExamples:
    doAssert:  !holiday(2026, hdayUKEngNewYearsDay) ==~ dateTime(2026, mJan, 1)
    doAssert:  !holiday(2026, hdayUKEngGoodFriday) ==~ dateTime(2026, mApr, 3)
  case hday
    of hdayUKEngNewYearsDay:
      result = holidayUKEngNewYearsDay(year, hour, minute, second, nanosecond, zone)
    of hdayUKEngGoodFriday:
      result = holidayUKEngGoodFriday(year, hour, minute, second, nanosecond, zone)    
    of hdayUKEngEasterMonday:
      result = holidayUKEngEasterMonday(year, hour, minute, second, nanosecond, zone)
    of hdayUKEngEarlyMay:
      result = holidayUKEngEarlyMay(year, hour, minute, second, nanosecond, zone) 
    of hdayUKEngSpringBank:
      result = holidayUKEngSpringBank(year, hour, minute, second, nanosecond, zone)
    of hdayUKEngSummerBank:
      result = holidayUKEngSummerBank(year, hour, minute, second, nanosecond, zone)
    of hdayUKEngChristmasDay:
      result = holidayUKEngChristmasDay(year, hour, minute, second, nanosecond, zone)   
    of hdayUKEngBoxingDay:
      result = holidayUKEngBoxingDay(year, hour, minute, second, nanosecond, zone)


proc holiday*(year: int, hday: bdHolidayUKNorthenIreland, hour: HourRange = 0, 
              minute: MinuteRange = 0, second: SecondRange = 0, 
              nanosecond: NanosecondRange = 0, zone: TimeZone = local()): ?DateTime =
  ## Returns the holiday corresponding to the `<year>` and `<hday>` parameters (desired time can be specified).
  # 1st objective of this function: to guarantee that a procedure has been 
  # implemented for each item in the 'bdHolidayUKNorthenIreland' enumeration.
  runnableExamples:
    doAssert:  !holiday(2026, hdayUKNirEasterMonday) ==~ dateTime(2026, mApr, 6)
    doAssert:  !holiday(2026, hdayUKNirEarlyMay) ==~ dateTime(2026, mMay, 4)
  case hday
    of hdayUKNirNewYearsDay:
      result = holidayUKNirNewYearsDay(year, hour, minute, second, nanosecond, zone)
    of hdayUKNirStPatricksDay:
      result = holidayUKNirStPatricksDay(year, hour, minute, second, nanosecond, zone)
    of hdayUKNirGoodFriday:
      result = holidayUKNirGoodFriday(year, hour, minute, second, nanosecond, zone)
    of hdayUKNirEasterMonday:
      result = holidayUKNirEasterMonday(year, hour, minute, second, nanosecond, zone)
    of hdayUKNirEarlyMay:
      result = holidayUKNirEarlyMay(year, hour, minute, second, nanosecond, zone)  
    of hdayUKNirSpringBank:
      result = holidayUKNirSpringBank(year, hour, minute, second, nanosecond, zone) 
    of hdayUKNirOrangemensDay:
      result = holidayUKNirOrangemensDay(year, hour, minute, second, nanosecond, zone) 
    of hdayUKNirSummerBank:
      result = holidayUKNirSummerBank(year, hour, minute, second, nanosecond, zone)
    of hdayUKNirChristmasDay:
      result = holidayUKNirChristmasDay(year, hour, minute, second, nanosecond, zone)   
    of hdayUKNirBoxingDay:
      result = holidayUKNirBoxingDay(year, hour, minute, second, nanosecond, zone)


proc holiday*(year: int, hday: bdHolidayUKScotland, hour: HourRange = 0, 
              minute: MinuteRange = 0, second: SecondRange = 0, 
              nanosecond: NanosecondRange = 0, zone: TimeZone = local()): ?DateTime =
  ## Returns the holiday corresponding to the `<year>` and `<hday>` parameters (desired time can be specified).
  # 1st objective of this function: to guarantee that a procedure has been 
  # implemented for each item in the 'bdHolidayUKScotland' enumeration.
  runnableExamples:
    doAssert:  !holiday(2026, hdayUKSctSummerBank) ==~ dateTime(2026, mAug, 3)
    doAssert:  !holiday(2026, hdayUKSctStAndrewsDay) ==~ dateTime(2026, mNov, 30)
  case hday
    of hdayUKSctNewYearsDay:
      result = holidayUKSctNewYearsDay(year, hour, minute, second, nanosecond, zone)
    of hdayUKSctJanuary2:
      result = holidayUKSctJanuary2(year, hour, minute, second, nanosecond, zone)
    of hdayUKSctGoodFriday:
      result = holidayUKSctGoodFriday(year, hour, minute, second, nanosecond, zone)
    of hdayUKSctEarlyMay:
      result = holidayUKSctEarlyMay(year, hour, minute, second, nanosecond, zone)  
    of hdayUKSctSpringBank:
      result = holidayUKSctSpringBank(year, hour, minute, second, nanosecond, zone)
    of hdayUKSctSummerBank:
      result = holidayUKSctSummerBank(year, hour, minute, second, nanosecond, zone)
    of hdayUKSctStAndrewsDay:
      result = holidayUKSctStAndrewsDay(year, hour, minute, second, nanosecond, zone)
    of hdayUKSctChristmasDay:
      result = holidayUKSctChristmasDay(year, hour, minute, second, nanosecond, zone)   
    of hdayUKSctBoxingDay:
      result = holidayUKSctBoxingDay(year, hour, minute, second, nanosecond, zone)


# =========================     isholiday  procs     ========================= #

proc isholidayUKEngland*(dt: DateTime): bool =
  ##[
  **Returns:**
    - `true` if `dt` is a holiday in England
    - `false` if `dt` is not a holiday in England

  **Business days and holidays:**

    In England, all days are working days, with the exception of:
    - Saturdays and Sundays (weekends)
    - Holidays that are moved to Monday if it is a weekend day:
      - New Year's Day, January 1st
    - Other holidays:
      - Good Friday
      - Easter Monday
      - Early May bank holiday (1st Monday in May)
      - Spring bank holiday (last Monday in May)
      - Summer bank holiday (last Monday in August)
      - Christmas Day, December 27 if December 25 is a weekend, December 25 otherwise
      - Boxing Day, December 28 if December 26 is a weekend, December 26 otherwise

  **References:**
    - https://www.gov.uk/bank-holidays#england-and-wales
  ]##  
  runnableExamples:
    doAssert:  isholidayUKEngland(dateTime(2025, mJan, 1)) # New Year's Day
    doAssert:  isholidayUKEngland(dateTime(2025, mApr, 18)) # Good Friday
    doAssert:  isholidayUKEngland(dateTime(2025, mApr, 21)) # Easter Monday
    doAssert:  isholidayUKEngland(dateTime(2025, mMay, 5)) # Early May bank holiday
    doAssert:  isholidayUKEngland(dateTime(2025, mMay, 26)) # Spring bank holiday
    doAssert:  isholidayUKEngland(dateTime(2025, mAug, 25)) # Summer bank holiday
    doAssert:  isholidayUKEngland(dateTime(2025, mDec, 25)) # Christmas Day
    doAssert:  isholidayUKEngland(dateTime(2025, mDec, 26)) # Boxing Day
  let yy = dt.year
  let mm = dt.month
  let dd = dt.monthday
  let tz = dt.timezone
  # Official Closings
  # -----------------
  case mm
    of mJan..mJun:  # dichotomy for speed up the algorithm
      if hday =? holidayUKEngNewYearsDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKEngGoodFriday(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKEngEasterMonday(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKEngEarlyMay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKEngSpringBank(year = yy, zone = tz) and dt ==~ hday:  return true
    else:
      if hday =? holidayUKEngSummerBank(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKEngChristmasDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKEngBoxingDay(year = yy, zone = tz) and dt ==~ hday:  return true
  # Special Closings
  # ----------------
  # Bank holiday for the coronation of King Charles III
  if yy == 2023 and mm == mMay and dd == 8:  return true  
  # Bank Holiday for the State Funeral of Queen Elizabeth II
  if yy == 2022 and mm == mSep and dd == 19:  return true
  # Platinum Jubilee bank holiday
  if yy == 2022 and mm == mJun and dd == 3:  return true
  # Finally
  return false


proc isholidayUKNorthenIreland*(dt: DateTime): bool =
  ##[
  **Returns:**
    - `true` if `dt` is a holiday in Northen Ireland
    - `false` if `dt` is not a holiday in Northen Ireland

  **Business days and holidays:**

    In Northern Ireland, all days are working days, with the exception of:
    - Saturdays and Sundays (weekends)   
    - Holidays that are moved to Monday if it is a weekend day:
      - New Year's Day, January 1st
    - Holidays that are moved to Monday if it is Sunday, or to Friday if it is Saturday:
      - St Patrick’s Day
      - Orangemen’s Day
    - Other holidays:
      - Good Friday
      - Easter Monday
      - Early May bank holiday (1st Monday in May)
      - Spring bank holiday (last Monday in May)
      - Summer bank holiday (last Monday in August)
      - Christmas Day, December 27 if December 25 is a weekend, December 25 otherwise
      - Boxing Day, December 28 if December 26 is a weekend, December 26 otherwise

  **References:**
    - https://www.gov.uk/bank-holidays#northern-ireland
  ]##
  runnableExamples:
    doAssert:  isholidayUKNorthenIreland(dateTime(2025, mJan, 1)) # New Year's Day
    doAssert:  isholidayUKNorthenIreland(dateTime(2025, mMar, 17)) # St Patrick’s Day
    doAssert:  isholidayUKNorthenIreland(dateTime(2025, mApr, 18)) # Good Friday
    doAssert:  isholidayUKNorthenIreland(dateTime(2025, mApr, 21)) # Easter Monday
    doAssert:  isholidayUKNorthenIreland(dateTime(2025, mMay, 5)) # Early May bank holiday
    doAssert:  isholidayUKNorthenIreland(dateTime(2025, mMay, 26)) # Spring bank holiday
    doAssert:  isholidayUKNorthenIreland(dateTime(2025, mJul, 14)) # Orangemen’s Day
    doAssert:  isholidayUKNorthenIreland(dateTime(2025, mAug, 25)) # Summer bank holiday
    doAssert:  isholidayUKNorthenIreland(dateTime(2025, mDec, 25)) # Christmas Day
    doAssert:  isholidayUKNorthenIreland(dateTime(2025, mDec, 26)) # Boxing Day
  let yy = dt.year
  let mm = dt.month
  let dd = dt.monthday
  let tz = dt.timezone
  # Official Closings
  # -----------------
  case mm
    of mJan..mJun:  # dichotomy for speed up the algorithm
      if hday =? holidayUKNirNewYearsDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKNirStPatricksDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKNirGoodFriday(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKNirEasterMonday(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKNirEarlyMay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKNirSpringBank(year = yy, zone = tz) and dt ==~ hday:  return true
    else:
      if hday =? holidayUKNirOrangemensDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKNirSummerBank(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKNirChristmasDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKNirBoxingDay(year = yy, zone = tz) and dt ==~ hday:  return true
  # Special Closings
  # ----------------
  # Bank holiday for the coronation of King Charles III
  if yy == 2023 and mm == mMay and dd == 8:  return true  
  # Bank Holiday for the State Funeral of Queen Elizabeth II
  if yy == 2022 and mm == mSep and dd == 19:  return true
  # Platinum Jubilee bank holiday
  if yy == 2022 and mm == mJun and dd == 3:  return true
  # Finally
  return false


proc isholidayUKScotland*(dt: DateTime): bool =
  ##[
  **Returns:**
    - `true` if `dt` is a holiday in Scotland
    - `false` if `dt` is not a holiday in Scotland

  **Business days and holidays:**

    In Scotland, all days are working days, with the exception of:
    - Saturdays and Sundays (weekends)   
    - Holidays that are moved to Monday if it is a weekend day:
      - New Year's Day, January 1st
    - Holidays that are moved to Monday if it is Sunday, or to Friday if it is Saturday:
      - St Andrew’s Day, November 30
    - Other holidays:
      - 2nd January
      - Good Friday
      - Early May bank holiday (1st Monday in May)
      - Summer bank holiday (1st Monday in August)
      - Christmas Day, December 27 if December 25 is a weekend, December 25 otherwise
      - Boxing Day, December 28 if December 26 is a weekend, December 26 otherwise

  **References:**
    - https://www.gov.uk/bank-holidays#scotland
  ]##
  runnableExamples:
    doAssert:  isholidayUKScotland(dateTime(2025, mJan, 1)) # New Year's Day
    doAssert:  isholidayUKScotland(dateTime(2025, mJan, 2)) # 2nd January
    doAssert:  isholidayUKScotland(dateTime(2025, mApr, 18)) # Good Friday
    doAssert:  isholidayUKScotland(dateTime(2025, mMay, 5)) # Early May bank holiday
    doAssert:  isholidayUKScotland(dateTime(2025, mMay, 26)) # Spring bank holiday
    doAssert:  isholidayUKScotland(dateTime(2025, mAug, 4)) # Summer bank holiday
    doAssert:  isholidayUKScotland(dateTime(2025, mDec, 1)) # St Andrew’s Day
    doAssert:  isholidayUKScotland(dateTime(2025, mDec, 25)) # Christmas Day
    doAssert:  isholidayUKScotland(dateTime(2025, mDec, 26)) # Boxing Day
  let yy = dt.year
  let mm = dt.month
  let dd = dt.monthday
  let tz = dt.timezone
  # Official Closings
  # -----------------
  case mm
    of mJan..mJun:  # dichotomy for speed up the algorithm
      if hday =? holidayUKSctNewYearsDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKSctJanuary2(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKSctGoodFriday(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKSctEarlyMay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKSctEarlyMay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKSctSpringBank(year = yy, zone = tz) and dt ==~ hday:  return true
    else:
      if hday =? holidayUKSctSummerBank(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKSctStAndrewsDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKSctChristmasDay(year = yy, zone = tz) and dt ==~ hday:  return true
      if hday =? holidayUKSctBoxingDay(year = yy, zone = tz) and dt ==~ hday:  return true
  # Special Closings
  # ----------------
  # Bank holiday for the coronation of King Charles III
  if yy == 2023 and mm == mMay and dd == 8:  return true  
  # Bank Holiday for the State Funeral of Queen Elizabeth II
  if yy == 2022 and mm == mSep and dd == 19:  return true
  # Platinum Jubilee bank holiday
  if yy == 2022 and mm == mJun and dd == 3:  return true
  # Finally
  return false
