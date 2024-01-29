##[
========
holidays
========
Some useful tools when working with holidays.

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

import  std/[tables], ./private/[easter, nudates]
export  tables, easter, nudates


# =============================     qtHoliday     ============================ #

type
  qtHoliday* = enum
    ##[ 
    Holidays natively supported by the system (for each `hdayXXXX` holiday 
    there exists a `holidayXXXX` procedure whose documentation contains 
    useful information).
    ]##
    hdayAscension, hdayEasterMonday, hdayGoodFriday, hdayEasterSunday,
    hdayWhitMonday, hdayWhitSunday,
    # cause of the definition of the 'qtEasterNCo' range below,
    # the order of the above items should not be changed
    hdayBoxingDay, hdayChristmasDay, hdayDecember31, hdayLabourDay, 
    hdayNewYearsDay, hdayUSChristmasDayObs, hdayUSColumbusDay, 
    hdayUSInaugurationDay, hdayUSInaugurationDayObs, hdayUSIndependenceDay, 
    hdayUSIndependenceDayObs, hdayUSJuneteenthIndependenceDay,
    hdayUSJuneteenthIndependenceDayObs, hdayUSLaborDay,
    hdayUSMartinLutherKingBirthday, hdayUSMemorialDay, hdayUSNewYearsDayObs, 
    hdayUSNYSEElectionDay, hdayUSNYSENewYearsDayObs, hdayUSThanksgivingDay, 
    hdayUSVeteransDay, hdayUSVeteransDayObs, hdayUSWashingtonBirthday,
    
  qtEasterNCo* = range[hdayAscension..hdayWhitSunday]
    ##[
    Easter and related holidays (Pentecost, Ascension, etc.).

    **See also:**
      - `qtHoliday <#qtHoliday>`_
    ]##


# ===========================     Special dates     ========================== #

const
  NewYearsDay*: MonthMonthday = (mJan, 1)  ## New Year's Day (January 1st)
  ChristmasDay*: MonthMonthday = (mDec, 25)  ## Christmas Day (December 25th)
  USJuneteenthIndependenceDay*: MonthMonthday = (mJun, 19)  
    ## U.S. Juneteenth National Independence Day (June 19th)
  USIndependanceDay*: MonthMonthday = (mJul, 4)  ## U.S.  Independence Day (July 4th)
  USVeteransDay*: MonthMonthday = (mNov, 11)  ## U.S. Veterans’ Day (November 11th)
  LabourDay*: MonthMonthday = (mMay, 1)  ## Labour Day (May 1st)
  BoxingDay*: MonthMonthday = (mDec, 26)  ## Boxing Day (December 26th)
  December31*: MonthMonthday = (mDec, 31)  ## December 31st
    

# ==============================     Easter     ============================== #

proc  gregorianEasterSunday*(year: int; hour: HourRange = 0; 
                             minute: MinuteRange = 0;
                             second: SecondRange = 0; 
                             nanosecond: NanosecondRange = 0;
                             zone: Timezone = local()): 
                            ?DateTime =
  ##[
  **Returns:**
    - The date of Gregorian Easter Sunday of the 
      year given in parameter if `year >= 1583`.
    - `none(DateTime)` if `year < 1583`.

  **See also:**
    - `gregorianEasterSundayMMDD <private/easter.html#gregorianEasterSundayMMDD,int>`_
  ]##

  if easter =? gregorianEasterSundayMMDD(year):
    result = dateTime(year = year, month = Month(easter.month), 
                      monthday = easter.monthday, hour = hour,
                      minute = minute, second = second, 
                      nanosecond = nanosecond, zone = zone).some


proc  gregorianEasterSundayNCo*(year: int; hour: HourRange = 0; 
                                minute: MinuteRange = 0;
                                second: SecondRange = 0; 
                                nanosecond: NanosecondRange = 0;
                                zone: Timezone = local()): 
                                Table[qtEasterNCo, DateTime] =
  ##[
  **Returns:**
    - The dates of Gregorian Easter (Sunday and Monday), 
      Good Friday, Ascension and Pentecost (Sunday and Monday), 
      of the year given in parameter if `year >= 1583`.
    - An empty `Table` if `year < 1583`.

  **See also:**
    - `gregorianEasterSundayMMDD <private/easter.html#gregorianEasterSundayMMDD,int>`_
  ]##

  runnableExamples:
    doAssert:  gregorianEasterSundayNCo(1200).len == 0
    doAssert:  gregorianEasterSundayNCo(1582).len == 0

    let easterNCo = gregorianEasterSundayNCo(2018)
    doAssert:  easterNCo[hdayEasterSunday] == dateTime(2018, mApr, 1)
    doAssert:  easterNCo[hdayEasterMonday] == dateTime(2018, mApr, 2)
    doAssert:  easterNCo[hdayGoodFriday] == dateTime(2018, mMar, 30)
    doAssert:  easterNCo[hdayAscension] == dateTime(2018, mMay, 10)
    doAssert:  easterNCo[hdayWhitSunday] == dateTime(2018, mMay, 20)
    doAssert:  easterNCo[hdayWhitMonday] == dateTime(2018, mMay, 21)

  if easterSunday =? gregorianEasterSunday(year = year, hour = hour, 
                                           minute = minute, second = second,
                                           nanosecond = nanosecond, zone = zone):
    result[hdayEasterSunday] = easterSunday
    result[hdayEasterMonday] = easterSunday + 1.days
    result[hdayGoodFriday] = easterSunday - 2.days
    result[hdayAscension] = easterSunday + 39.days
    result[hdayWhitSunday] = easterSunday + 49.days
    result[hdayWhitMonday] = easterSunday + 50.days


# =================     U.S. Rules for Holiday Adjustment     ================ #

proc  adjustHolidayUSSundayRule*(dt: DateTime): DateTime =
  ##[
  **Returns:**
    - The following Monday if `dt` is a Sunday.
    - `dt` for other days of the week.
  ]##
  if getDayOfWeek(dt) == dSun:  result = dt + 1.days  # following monday
  else:  result = dt


proc  adjustHolidayUSRule*(dt: DateTime): DateTime =
  ##[
  **Returns:**
    - The following Monday if `dt` is a Sunday.
    - The previous Friday if `dt` is a Saturday.
    - `dt` for other days of the week.
  ]##
  let dayOfWeek = getDayOfWeek(dt)
  if dayOfWeek == dSun:  result = dt + 1.days  # following monday
  elif dayOfWeek == dSat:  result = dt - 1.days  # previous friday
  else:  result = dt


# ===============     Public holidays: with U.S. adjusment     =============== #

# New Year's Day  (January 1st)
# -----------------------------

proc  holidayNewYearsDay*(year: int): DateTime {.inline.} =
  ##[ 
  Returns the *New Year's Day (January 1st)*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayNewYearsDay(2016) == dateTime(2016, mJan, 1)
    doAssert:  !holiday(2016, hdayNewYearsDay) == dateTime(2016, mJan, 1)
  dateTime(year, NewYearsDay.month, NewYearsDay.monthday)


proc  holidayUSNewYearsDayObs*(year: int): DateTime {.inline.} =
  ##[
  **Returns:**
    - Monday, January 2, if January 1 is a Sunday.
    - Friday, December 31, if January 1 is a Saturday.
    - January 1, in all other cases.

  **Notes:**
  
    The above rules are based on those that currently 
    apply in the United States for New Year's Day.

  **See also:**
    - `holidayNewYearsDay <#holidayNewYearsDay,int>`_, 
      `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSNewYearsDayObs(2017) == dateTime(2017, mJan, 2)  # Monday
    doAssert:  holidayUSNewYearsDayObs(2022) == dateTime(2021, mDec, 31) # Friday
    doAssert:  holidayUSNewYearsDayObs(2020) == dateTime(2020, mJan, 1)  # Wednesday
    doAssert:  !holiday(2017, hdayUSNewYearsDayObs) == dateTime(2017, mJan, 2)  # Monday
    doAssert:  !holiday(2022, hdayUSNewYearsDayObs) == dateTime(2021, mDec, 31) # Friday
    doAssert:  !holiday(2020, hdayUSNewYearsDayObs) == dateTime(2020, mJan, 1)  # Wednesday
  holidayNewYearsDay(year).adjustHolidayUSRule


proc  holidayUSNYSENewYearsDayObs*(year: int): DateTime {.inline.} =
  ##[
  **Returns:**
    - Monday, January 2, if January 1 is a Sunday.
    - January 1, in all other cases.

  **Notes:**
  
    The above rules are based on those that currently apply 
    to the New York Stock Exchange (NYSE) for New Year's Day.

  **See also:**
    - `holidayNewYearsDay <#holidayNewYearsDay,int>`_,
      `holidayUSNewYearsDayObs <#holidayUSNewYearsDayObs,int>`_,
      `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSNYSENewYearsDayObs(2017) == dateTime(2017, mJan, 2)  # Monday
    doAssert:  holidayUSNYSENewYearsDayObs(2022) == dateTime(2022, mJan, 1)  # Saturday
    doAssert:  holidayUSNYSENewYearsDayObs(2020) == dateTime(2020, mJan, 1)  # Wednesday
    doAssert:  !holiday(2017, hdayUSNYSENewYearsDayObs) == dateTime(2017, mJan, 2)  # Monday
    doAssert:  !holiday(2022, hdayUSNYSENewYearsDayObs) == dateTime(2022, mJan, 1)  # Saturday
    doAssert:  !holiday(2020, hdayUSNYSENewYearsDayObs) == dateTime(2020, mJan, 1)  # Wednesday
  holidayNewYearsDay(year).adjustHolidayUSSundayRule


# Christmas Day  (December 25th)
# -----------------------------

proc  holidayChristmasDay*(year: int): DateTime {.inline.} =
  ##[
  Returns the *Christmas Day (December 25th)*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayChristmasDay(2016) == dateTime(2016, mDec, 25)
    doAssert:  !holiday(2016, hdayChristmasDay) == dateTime(2016, mDec, 25)
  dateTime(year, ChristmasDay.month, ChristmasDay.monthday)


proc  holidayUSChristmasDayObs*(year: int): DateTime {.inline.} =
  ##[
  **Returns:**
    - Monday, December 26, if December 25 is a Sunday.
    - Friday, December 24, if December 25 is a Saturday.
    - December 25, in all other cases.

  **Notes:**
  
    The above rules are based on those that currently 
    apply in the United States for Christmas Day.

  **See also:**
    - `holidayChristmasDay <#holidayChristmasDay,int>`_,
      `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSChristmasDayObs(2022) == dateTime(2022, mDec, 26) # Monday
    doAssert:  holidayUSChristmasDayObs(2021) == dateTime(2021, mDec, 24) # Friday
    doAssert:  holidayUSChristmasDayObs(2019) == dateTime(2019, mDec, 25) # Tuesday
    doAssert:  !holiday(2022, hdayUSChristmasDayObs) == dateTime(2022, mDec, 26) # Monday
    doAssert:  !holiday(2021, hdayUSChristmasDayObs) == dateTime(2021, mDec, 24) # Friday
    doAssert:  !holiday(2019, hdayUSChristmasDayObs) == dateTime(2019, mDec, 25) # Tuesday
  holidayChristmasDay(year).adjustHolidayUSRule


# Juneteenth National Independence Day (June 19th)
# ------------------------------------------------

proc  holidayUSJuneteenthIndependenceDay*(year: int): DateTime {.inline.} =
  ##[
  Returns the *U.S. Juneteenth National Independence Day (June 19th)*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSJuneteenthIndependenceDay(2016) == dateTime(2016, mJun, 19)
    doAssert:  !holiday(2016, hdayUSJuneteenthIndependenceDay) == dateTime(2016, mJun, 19)
  dateTime(year, USJuneteenthIndependenceDay.month, 
           USJuneteenthIndependenceDay.monthday)


proc  holidayUSJuneteenthIndependenceDayObs*(year: int): DateTime {.inline.} =
  ##[
  **Returns:**
    - Monday, June 20, if June 19 is a Sunday.
    - Friday, June 18, if June 19 is a Saturday.
    - June 19 in all other cases.

  **Notes:**
  
    The above rules are based on those that currently apply in 
    the United States for Juneteenth National Independence Day.

  **See also:**
    - `holidayUSJuneteenthIndependenceDay <#holidayUSJuneteenthIndependenceDay,int>`_,
      `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSJuneteenthIndependenceDayObs(2033) == dateTime(2033, mJun, 20) # Monday
    doAssert:  holidayUSJuneteenthIndependenceDayObs(2027) == dateTime(2027, mJun, 18) # Friday
    doAssert:  holidayUSJuneteenthIndependenceDayObs(2024) == dateTime(2024, mJun, 19) # Wednesday
    doAssert:  !holiday(2033, hdayUSJuneteenthIndependenceDayObs) == dateTime(2033, mJun, 20) # Monday
    doAssert:  !holiday(2027, hdayUSJuneteenthIndependenceDayObs) == dateTime(2027, mJun, 18) # Friday
    doAssert:  !holiday(2024, hdayUSJuneteenthIndependenceDayObs) == dateTime(2024, mJun, 19) # Wednesday
  holidayUSJuneteenthIndependenceDay(year).adjustHolidayUSRule
  

# Independence Day (July 4th)
# ---------------------------

proc  holidayUSIndependenceDay*(year: int): DateTime {.inline.} =
  ##[
  Returns the *U.S. Independence Day (July 4th)*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSIndependenceDay(2016) == dateTime(2016, mJul, 4)
    doAssert:  !holiday(2016, hdayUSIndependenceDay) == dateTime(2016, mJul, 4)
  dateTime(year, USIndependanceDay.month, USIndependanceDay.monthday)


proc  holidayUSIndependenceDayObs*(year: int): DateTime {.inline.} =
  ##[
  **Returns:**
    - Monday, July 5, if July 4 is a Sunday.
    - Friday, July 3, if July 4 is a Saturday.
    - July 4, in all other cases.

  **Notes:**
  
    The above rules are based on those that currently 
    apply in the United States for Independence Day.

  **See also:**
    - `holidayUSIndependenceDay <#holidayUSIndependenceDay,int>`_,
      `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSIndependenceDayObs(2021) == dateTime(2021, mJul, 5) # Monday
    doAssert:  holidayUSIndependenceDayObs(2020) == dateTime(2020, mJul, 3) # Friday
    doAssert:  holidayUSIndependenceDayObs(2019) == dateTime(2019, mJul, 4) # Thursday
    doAssert:  !holiday(2021, hdayUSIndependenceDayObs) == dateTime(2021, mJul, 5) # Monday
    doAssert:  !holiday(2020, hdayUSIndependenceDayObs) == dateTime(2020, mJul, 3) # Friday
    doAssert:  !holiday(2019, hdayUSIndependenceDayObs) == dateTime(2019, mJul, 4) # Thursday
  holidayUSIndependenceDay(year).adjustHolidayUSRule
  

# Veterans’ Day (November 11th)
# -----------------------------

proc  holidayUSVeteransDay*(year: int): DateTime {.inline.} =
  ##[
  Returns the *U.S. Veterans’ Day (November 11th)*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSVeteransDay(2016) == dateTime(2016, mNov, 11)
    doAssert:  !holiday(2016, hdayUSVeteransDay) == dateTime(2016, mNov, 11)
  dateTime(year, USVeteransDay.month, USVeteransDay.monthday)


proc  holidayUSVeteransDayObs*(year: int): DateTime {.inline.} =
  ##[
  **Returns:**
    - Monday, November 12, if November 11 is a Sunday.
    - Friday, November 10, if November 11 is a Saturday.
    - November 11 in all other cases.

  **Notes:**
  
    The above rules are based on those that currently 
    apply in the United States for Veterans’ Day.

  **See also:**
    - `holidayUSVeteransDay <#holidayUSVeteransDay,int>`_,
      `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSVeteransDayObs(2018) == dateTime(2018, mNov, 12) # Monday
    doAssert:  holidayUSVeteransDayObs(2017) == dateTime(2017, mNov, 10) # Friday
    doAssert:  holidayUSVeteransDayObs(2014) == dateTime(2014, mNov, 11) # Tuesday
    doAssert:  !holiday(2018, hdayUSVeteransDayObs) == dateTime(2018, mNov, 12) # Monday
    doAssert:  !holiday(2017, hdayUSVeteransDayObs) == dateTime(2017, mNov, 10) # Friday
    doAssert:  !holiday(2014, hdayUSVeteransDayObs) == dateTime(2014, mNov, 11) # Tuesday
  holidayUSVeteransDay(year).adjustHolidayUSRule
  

# Inauguration Day (January 20th since 1937, March 4th before)
# ------------------------------------------------------------

proc  holidayUSInaugurationDay*(year: int): ?DateTime =
  ##[ 
  Returns the *U.S. Inauguration Day* of the year received in parameter, that is:
    - April 30 for the year 1789 (1st presidential election).
    - March 4, every presidential election year, from 1793 to 1933.
    - January 20,  every presidential election year, since 1937.
    - `none(DateTime)` for all other years.

  **References:**
    - https://en.wikipedia.org/wiki/United_States_presidential_inauguration

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSInaugurationDay(1512).isNone # 1st presidential election in 1789
    doAssert:  holidayUSInaugurationDay(2019).isNone # no presidential election in 2019
    doAssert:  !holidayUSInaugurationDay(1789) == dateTime(1789, mApr, 30)
    doAssert:  !holidayUSInaugurationDay(1813) == dateTime(1813, mMar, 4)
    doAssert:  !holidayUSInaugurationDay(1917) == dateTime(1917, mMar, 4)
    doAssert:  !holidayUSInaugurationDay(1985) == dateTime(1985, mJan, 20)
    doAssert:  !holidayUSInaugurationDay(1997) == dateTime(1997, mJan, 20)
    doAssert:  !holidayUSInaugurationDay(2013) == dateTime(2013, mJan, 20)
    doAssert:  !holidayUSInaugurationDay(2021) == dateTime(2021, mJan, 20)
    doAssert:  holiday(1512, hdayUSInaugurationDay).isNone
    doAssert:  holiday(2019, hdayUSInaugurationDay).isNone
    doAssert:  !holiday(1789, hdayUSInaugurationDay) == dateTime(1789, mApr, 30)
    doAssert:  !holiday(1917, hdayUSInaugurationDay) == dateTime(1917, mMar, 4)
    doAssert:  !holiday(1985, hdayUSInaugurationDay) == dateTime(1985, mJan, 20)

  if year < 1789:  return none(DateTime)
  elif year == 1789:  return dateTime(1789, mApr, 30).some
  elif year > 1789 and year <= 1933:
    if (year-1789).mod(4) != 0:  return none(DateTime)  
    else:  return dateTime(year, mMar, 4).some
  else:
    if (year-1933).mod(4) != 0:  return none(DateTime)  
    else:  return dateTime(year, mJan, 20).some
  

proc  holidayUSInaugurationDayObs*(year: int): ?DateTime {.inline.} =
  ##[
  The observed *U.S. Inauguration Day* of the year received in parameter, 
  that is:
    - Next Monday, if U.S. Inauguration Day is a Sunday.
    - U.S. Inauguration Day in all other cases.

  **See also:**
    - `holidayUSInaugurationDay <#holidayUSInaugurationDay,int>`_,
      `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSInaugurationDayObs(1512).isNone # 1st presidential election in 1789
    doAssert:  holidayUSInaugurationDayObs(2019).isNone # no presidential election in 2019
    doAssert:  !holidayUSInaugurationDayObs(1789) == dateTime(1789, mApr, 30) # Thursday
    doAssert:  !holidayUSInaugurationDayObs(1813) == dateTime(1813, mMar, 4) # Thursday
    doAssert:  !holidayUSInaugurationDayObs(1917) == dateTime(1917, mMar, 5) # Monday
    doAssert:  !holidayUSInaugurationDayObs(1985) == dateTime(1985, mJan, 21) # Monday
    doAssert:  !holidayUSInaugurationDayObs(1997) == dateTime(1997, mJan, 20) # Monday
    doAssert:  !holidayUSInaugurationDayObs(2013) == dateTime(2013, mJan, 21) # Monday
    doAssert:  !holidayUSInaugurationDayObs(2021) == dateTime(2021, mJan, 20) # Wednesday
    doAssert:  holiday(1512, hdayUSInaugurationDayObs).isNone
    doAssert:  holiday(2019, hdayUSInaugurationDayObs).isNone
    doAssert:  !holiday(1789, hdayUSInaugurationDayObs) == dateTime(1789, mApr, 30) # Thursday
    doAssert:  !holiday(2013, hdayUSInaugurationDayObs) == dateTime(2013, mJan, 21) # Monday
    doAssert:  !holiday(2021, hdayUSInaugurationDayObs) == dateTime(2021, mJan, 20) # Wednesday
  holidayUSInaugurationDay(year).?adjustHolidayUSSundayRule

 
# ================     Public holidays: no U.S. adjusment     ================ #

# Labour Day  (May 1st)
# ---------------------

proc  holidayLabourDay*(year: int): DateTime {.inline.} =
  ##[ 
  Returns the *Labour Day (May 1st)*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayLabourDay(2016) == dateTime(2016, mMay, 1)
    doAssert:  !holiday(2016, hdayLabourDay) == dateTime(2016, mMay, 1)
  dateTime(year, LabourDay.month, LabourDay.monthday)


# Boxing Day  (December 26th)
# ---------------------------

proc  holidayBoxingDay*(year: int): DateTime {.inline.} =
  ##[ 
  Returns the *Boxing Day (December 26th)*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayBoxingDay(2016) == dateTime(2016, mDec, 26)
    doAssert:  !holiday(2016, hdayBoxingDay) == dateTime(2016, mDec, 26)
  dateTime(year, BoxingDay.month, BoxingDay.monthday)


# December 31st
# -------------

proc  holidayDecember31*(year: int): DateTime {.inline.} =
  ##[ 
  Returns the *December 31st*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayDecember31(2016) == dateTime(2016, mDec, 31)
    doAssert:  !holiday(2016, hdayDecember31) == dateTime(2016, mDec, 31)
  dateTime(year, December31.month, December31.monthday)


# Birthday of Martin Luther King 
# ------------------------------

proc  holidayUSMartinLutherKingBirthday*(year: int): DateTime =
  ##[ 
  Returns the *3rd Monday in January*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSMartinLutherKingBirthday(2035) == dateTime(2035, mJan, 15)
    doAssert:  !holiday(2035, hdayUSMartinLutherKingBirthday) == dateTime(2035, mJan, 15)
  let monthday = searchMonthday(year = year, month = mJan, 
                                weekday = dMon, nthOccurrence = 3)
  assert: monthday.isSome
  result = dateTime(year, mJan, !monthday) 


# Washington's Birthday
# ---------------------

proc  holidayUSWashingtonBirthday*(year: int): DateTime =
  ##[ 
  Returns the *3rd Monday in February*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSWashingtonBirthday(2035) == dateTime(2035, mFeb, 19)
    doAssert:  !holiday(2035, hdayUSWashingtonBirthday) == dateTime(2035, mFeb, 19)
  let monthday = searchMonthday(year = year, month = mFeb, 
                                weekday = dMon, nthOccurrence = 3)
  assert: monthday.isSome
  result = dateTime(year, mFeb, !monthday) 


# Memorial Day
# ------------

proc  holidayUSMemorialDay*(year: int): DateTime =
  ##[ 
  Returns the *U.S. Memorial Day (last Monday in May)*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSMemorialDay(2035) == dateTime(2035, mMay, 28)
    doAssert:  !holiday(2035, hdayUSMemorialDay) == dateTime(2035, mMay, 28)
  let monthday = searchMonthday(year = year, month = mMay, 
                                weekday = dMon, nthOccurrence = -1)
  assert: monthday.isSome
  result = dateTime(year, mMay, !monthday)


# Labor Day
# ---------

proc  holidayUSLaborDay*(year: int): DateTime =
  ##[ 
  Returns the *U.S. Labor Day (1st Monday in September)*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##

  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSLaborDay(2035) == dateTime(2035, mSep, 3)
    doAssert:  !holiday(2035, hdayUSLaborDay) == dateTime(2035, mSep, 3)

  let monthday = searchMonthday(year = year, month = mSep, 
                                weekday = dMon, nthOccurrence = 1)
  assert: monthday.isSome
  result = dateTime(year, mSep, !monthday)


# Columbus Day
# ------------
 
proc  holidayUSColumbusDay*(year: int): DateTime =
  ##[ 
  Returns the *U.S. Columbus Day (2nd Monday in October)*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSColumbusDay(2003) == dateTime(2003, mOct, 13)
    doAssert:  !holiday(2003, hdayUSColumbusDay) == dateTime(2003, mOct, 13)
  let monthday = searchMonthday(year = year, month = mOct, 
                                weekday = dMon, nthOccurrence = 2)
  assert: monthday.isSome
  result = dateTime(year, mOct, !monthday)


# Thanksgiving Day
# ----------------  

proc  holidayUSThanksgivingDay*(year: int): DateTime =
  ##[ 
  Returns the *U.S. Thanksgiving Day (4th Thursday in November)*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSThanksgivingDay(2035) == dateTime(2035, mNov, 22)
    doAssert:  !holiday(2035, hdayUSThanksgivingDay) == dateTime(2035, mNov, 22)

  let monthday = searchMonthday(year = year, month = mNov, 
                                weekday = dThu, nthOccurrence = 4)
  assert: monthday.isSome
  result = dateTime(year, mNov, !monthday)


# U.S. Election Day
# -----------------  

proc  holidayUSNYSEElectionDay*(year: int): DateTime =
  ##[ 
  Returns "the Tuesday next after the first Monday in November"
  of the year received in parameter.
  
  **Notes:**
  
  These calculations also apply in years when there is no presidential election.
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSNYSEElectionDay(2035) == dateTime(2035, mNov, 6)
    doAssert:  !holiday(2035, hdayUSNYSEElectionDay) == dateTime(2035, mNov, 6)
  let monthday = searchMonthday(year = year, month = mNov, 
                                weekday = dMon, nthOccurrence = 1)
  assert: monthday.isSome
  result = dateTime(year, mNov, !monthday) + 1.days


# ======================     holiday(int,qtHoliday)     ====================== #

proc  holiday*(year: int, holiday: qtHoliday): ?DateTime =
  ## Returns the holiday corresponding to the `<year>` and `<holiday>` parameters.

  runnableExamples:
    doAssert:  !holiday(2016, hdayNewYearsDay) == dateTime(2016, mJan, 1)
    doAssert:  !holiday(2022, hdayUSNewYearsDayObs) == dateTime(2021, mDec, 31)
    doAssert:  !holiday(2003, hdayUSThanksgivingDay) == dateTime(2003, mNov, 27)
    doAssert:  !holiday(1901, hdayLabourDay) == dateTime(1901, mMay, 1)

  if holiday is qtHoliday:
    case holiday.qtHoliday
      of hdayNewYearsDay:  result = holidayNewYearsDay(year).some
      of hdayUSNewYearsDayObs:  result = holidayUSNewYearsDayObs(year).some
      of hdayUSNYSENewYearsDayObs:  result = holidayUSNYSENewYearsDayObs(year).some
      of hdayChristmasDay:  result = holidayChristmasDay(year).some
      of hdayUSChristmasDayObs:  result = holidayUSChristmasDayObs(year).some
      of hdayUSJuneteenthIndependenceDay:  result = holidayUSJuneteenthIndependenceDay(year).some
      of hdayUSJuneteenthIndependenceDayObs:  result = holidayUSJuneteenthIndependenceDayObs(year).some
      of hdayUSIndependenceDay:  result = holidayUSIndependenceDay(year).some
      of hdayUSIndependenceDayObs:  result = holidayUSIndependenceDayObs(year).some
      of hdayUSVeteransDay:  result = holidayUSVeteransDay(year).some
      of hdayUSVeteransDayObs:  result = holidayUSVeteransDayObs(year).some
      of hdayUSInaugurationDay:  result = holidayUSInaugurationDay(year)
      of hdayUSInaugurationDayObs:  result = holidayUSInaugurationDayObs(year)
      of hdayLabourDay:  result = holidayLabourDay(year).some
      of hdayBoxingDay:  result = holidayBoxingDay(year).some
      of hdayDecember31:  result = holidayDecember31(year).some
      of hdayUSMartinLutherKingBirthday:  result = holidayUSMartinLutherKingBirthday(year).some
      of hdayUSWashingtonBirthday:  result = holidayUSWashingtonBirthday(year).some
      of hdayUSMemorialDay:  result = holidayUSMemorialDay(year).some
      of hdayUSLaborDay:  result = holidayUSLaborDay(year).some
      of hdayUSColumbusDay:  result = holidayUSColumbusDay(year).some
      of hdayUSThanksgivingDay:  result = holidayUSThanksgivingDay(year).some
      of hdayUSNYSEElectionDay:  result = holidayUSNYSEElectionDay(year).some
      of hdayEasterMonday, hdayEasterSunday, hdayGoodFriday,
           hdayAscension, hdayWhitSunday, hdayWhitMonday:
        let easterNCo = gregorianEasterSundayNCo(year)
        if easterNCo.len == 0:  result = none(DateTime)
        else:  result = easterNCo[holiday].some


proc  isholiday*(dt: DateTime, holidays: set[qtHoliday]): bool =
  ##[
  Tests if `dt` is one of the holidays listed in the `holidays` parameter.
  ]##
  for holiday in holidays:
    if holiday =? holiday(dt.year, holiday) and dt === holiday:  return true
    # New Year's Day is a special case 
    elif holiday == hdayUSNewYearsDayObs and 
        holiday =? holiday(dt.year+1, holiday) and dt === holiday:  return true
  return false  


template  isholiday*(dt: DateTime, holiday: qtHoliday): bool =
  ##[ 
  Shortcut for `dt.isholiday({holiday})`.

  **See also:**
    - `isholiday <#isholiday,DateTime,set[qtHoliday]>`_
  ]##
  dt.isholiday({holiday})
  
  
# ===================     Public holidays: Easter & Co     =================== #

proc  holidayEasterSunday*(year: int): ?DateTime =
  ##[ 
  Returns the *Easter Sunday* day
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayEasterSunday(2018) == dateTime(2018, mApr, 1)
    doAssert:  !holiday(2018, hdayEasterSunday) == dateTime(2018, mApr, 1)
  result = holiday(year, hdayEasterSunday) 


proc  holidayEasterMonday*(year: int): ?DateTime =
  ##[ 
  Returns the *Easter Monday* 
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayEasterMonday(2018) == dateTime(2018, mApr, 2)
    doAssert:  !holiday(2018, hdayEasterMonday) == dateTime(2018, mApr, 2)
  result = holiday(year, hdayEasterMonday) 


proc  holidayGoodFriday*(year: int): ?DateTime =
  ##[ 
  Returns the *Good Friday* 
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayGoodFriday(2018) == dateTime(2018, mMar, 30)
    doAssert:  !holiday(2018, hdayGoodFriday) == dateTime(2018, mMar, 30)
  result = holiday(year, hdayGoodFriday) 


proc  holidayAscension*(year: int): ?DateTime =
  ##[ 
  Returns the *Ascension* day
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayAscension(2018) == dateTime(2018, mMay, 10)
    doAssert:  !holiday(2018, hdayAscension) == dateTime(2018, mMay, 10)
  result = holiday(year, hdayAscension) 


proc  holidayWhitMonday*(year: int): ?DateTime =
  ##[ 
  Returns the *Whit Monday*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayWhitMonday(2018) == dateTime(2018, mMay, 21)
    doAssert:  !holiday(2018, hdayWhitMonday) == dateTime(2018, mMay, 21)
  result = holiday(year, hdayWhitMonday) 


proc  holidayWhitSunday*(year: int): ?DateTime =
  ##[ 
  Returns the *Whit Sunday*
  of the year received in parameter.

  **See also:**
    - `holiday <#holiday,int,qtHoliday>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayWhitSunday(2018) == dateTime(2018, mMay, 20)
    doAssert:  !holiday(2018, hdayWhitSunday) == dateTime(2018, mMay, 20)
  result = holiday(year, hdayWhitSunday) 


# ====================     Holidays in TARGET calendar     =================== #

proc  isweekendTARGETCalendar*(dt: DateTime): ?bool = 
  ##[
  **Returns:**
    - `none(bool)` if `dt.year < 1999`
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
    - `none(bool)` if `dt.year < 1999`
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


# =======================     Holidays on U.S. NYSE     ====================== #

proc  isholidayUSNYSE*(dt: DateTime): ?bool =
  ##[
  **Returns:**
    - `none(bool)` if the system cannot answer the question 
      (typically when `dt.year < 1960`)
    - `some(true)` if `dt` is a holiday on the New York Stock Exchange (NYSE)
    - `some(false)` if `dt` is not a holiday on the New York Stock Exchange (NYSE)

  **Business days and holidays:**

    On the New York Stock Exchange **all days are operating days except**:
    - Saturdays and Sundays (weekends)
    - Holidays that are moved to Monday if it is Sunday:
      - New Year's Day, January 1st
    - Holidays that are moved to Monday if it is Sunday, or to Friday if it is Saturday:
      - Independence Day, July 4th
      - Christmas Day, December 25th
      - Juneteenth National Independence Day, June 19th, since 2023
    - Other holidays:
      - Martin Luther King's birthday, third Monday in January, since 1998
      - Washington's Birthday, 3rd Monday in February, since 1971
      - Good Friday
      - Memorial Day, last Monday in May, since 1971	  
      - Labor Day, 1st Monday in September, since 1887
      - Thanksgiving Day, 4th Thursday in November
    - Special closings:
      - President George H.W. Bush's funeral, December 5, 2018
      - Hurricane Sandy, October 29-30, 2012
      - etc.

  **References:**
    - https://s3.amazonaws.com/armstrongeconomics-wp/2013/07/NYSE-Closings.pdf
    - https://www.nyse.com/markets/hours-calendars
    - https://www.sifma.org/resources/general/holiday-schedule/
  ]##

  if dt.year < 1960:  return none(bool)

  # Official Closings
  # -----------------
  if dt.isholiday(hdayUSNYSENewYearsDayObs):  return some(true)
  if dt.isholiday(hdayUSMartinLutherKingBirthday) and dt.year > 1997:  return some(true)
  if dt.isholiday(hdayUSWashingtonBirthday) and dt.year > 1970:  return some(true)
  if dt.isholiday(hdayGoodFriday) and dt.year notin [1898, 1906, 1907]:  return some(true)
  if dt.isholiday(hdayUSMemorialDay) and dt.year > 1970:  return some(true)
  if dt.isholiday(hdayUSIndependenceDayObs):  return some(true)
  if dt.isholiday(hdayUSLaborDay) and dt.year > 1887:  return some(true)
  if dt.isholiday(hdayUSThanksgivingDay):  return some(true)
  if dt.isholiday(hdayUSChristmasDayObs):  return some(true)
  if dt.isholiday(hdayUSJuneteenthIndependenceDayObs) and dt.year > 2022:  return some(true)

  # Special Closings
  # ----------------
  let yy = dt.year
  let mm = dt.month
  let dd = dt.monthday
  let dayOfWeek = getDayOfWeek(dt)
  # President George H.W. Bush's funeral
  # <https://www.newyorkfed.org/markets/opolicy/operating_policy_181204>
  if yy == 2018 and mm == mDec and dd == 5:  return some(true)
  # Hurricane Sandy
  if yy == 2012 and mm == mOct and (dd == 29 or dd == 30):  return some(true)
  # Predient Ford's funeral
  if yy == 2007 and mm == mJan and dd == 2:  return some(true)
  # President Reagan's funeral
  if yy == 2004 and mm == mJun and dd == 11:  return some(true)
  # Sep 11th, 2001
  if yy == 2001 and mm == mSep and (11 <= dd and dd <= 14):  return some(true)
  # President Nixon's funeral
  if yy == 1994 and mm == mApr and dd == 27:  return some(true)
  # Hurricane Gloria
  if yy == 1985 and mm == mSep and dd == 27:  return some(true)  
  # Election Day
  if dt.isholiday(hdayUSNYSEElectionDay) and (yy <= 1968 or yy in [1972, 1976, 1980]):
    return some(true)
  # 1977 Blackout
  if yy == 1977 and mm == mJul and dd == 14:  return some(true)
  # Funeral of former President Lyndon B. Johnson
  if yy == 1973 and mm == mJan and dd == 25:  return some(true)
  # Funeral of former President Harry S. Truman
  if yy == 1972 and mm == mDec and dd == 28:  return some(true)
  # National Day of Participation for the lunar exploration
  if yy == 1969 and mm == mJul and dd == 21:  return some(true)
  # Eisenhower's funeral
  if yy == 1969 and mm == mMar and dd == 31:  return some(true)
  # Heavy snow
  if yy == 1969 and mm == mFeb and dd == 10:  return some(true)
  # Day after Independence Day
  if yy == 1968 and mm == mJul and dd == 5:  return some(true)
  # Paperwork Crisis
  if yy == 1968 and dayOfWeek == dWed and 
      (month: mJun, monthday: 12) <= (month: mm, monthday: dd):  
    return some(true)
  # Mourning for Martin Luther King Jr
  if yy == 1968 and mm == mApr and dd == 9:  return some(true)
  # Christmas Eve
  if mm == mDec and dd == 24 and yy in [1965, 1956, 1954, 1945, 1900]: 
    return some(true)
  # President Kennedy's funeral
  if yy == 1963 and mm == mNov and dd == 25:  return some(true)
  # Day before Decoration Day
  if yy == 1961 and mm == mMay and dd == 29:  return some(true)
  # Day after Christmas
  if yy == 1958 and mm == mDec and dd == 26:  return some(true)
  # Lincoln's Birthday
  if 1896 <= yy and yy <= 1953 and mm == mFeb and dd == 12:  return some(true)
  # Columbus Day
  if 1909 <= yy and yy <= 1953 and mm == mOct and dd == 12:  return some(true)
  # Veteran's Day
  if dd == 11 and mm == mNov and 
       (yy == 1918 or yy == 1921 or (1934 <= yy and yy <= 1953)):  return some(true)
  # V-J Day. End of World War II.
  if yy == 1945 and mm == mAug and (dd == 15 or dd == 16):  return some(true)
  # National banking holiday.
  if yy == 1933 and mm == mMar and 6 <= dd and dd <= 14:  return some(true)  
  # Parade for Colonel Charles A. Lindbergh.
  if yy == 1927 and mm == mJun and dd == 13:  return some(true)
  # Funeral of President Warren G. Harding at Marion, Ohio.
  # Death of President Warren G. Harding.
  if yy == 1923 and mm == mAug and (dd == 10 or dd == 3):  return some(true)
  # Return of General John J. Pershing.
  if yy == 1919 and mm == mSep and dd == 10:  return some(true)
  # Parade of 77th Division.
  if yy == 1919 and mm == mMay and dd == 6:  return some(true)
  # Homecoming of 27th Division.
  if yy == 1919 and mm == mMar and dd == 25:  return some(true)
  # Armistice signed.
  if yy == 1918 and mm == mNov and dd == 11:  return some(true)
  # Draft registration day.
  if yy == 1918 and mm == mSep and dd == 12:  return some(true)
  if yy == 1917 and mm == mJun and dd == 5:  return some(true)
  # Heatless day.
  if yy == 1918:
    if mm == mJan and dd == 28:  return some(true)
    if mm == mFeb and (dd == 4 or dd == 11):  return some(true)
  # World War I
  # it is not easy to determine the exact days of closure, partial or total
  if yy == 1914 or yy == 1915:  return none(bool)
  # Opening of new NYSE building.
  if yy == 1903 and mm == mApr and dd == 22:  return some(true)
  # Funeral of President William McKinley.
  if yy == 1901 and mm == mSep and dd == 19:  return some(true)
  # Days after Independence Day.
  if yy == 1901 and mm == mJul and dd == 5:  return some(true)
  # Admiral Dewey Celebration.
  if yy == 1899 and mm == mSep and dd == 29:  return some(true)
  # Monday before Independence Day.
  if yy == 1899 and mm == mJul and dd == 3:  return some(true)
  # Monday before Decoration Day.
  if yy == 1899 and mm == mMay and dd == 29:  return some(true)
  # Charter Day.
  if yy == 1898 and mm == mMay and dd == 4:  return some(true)
  # Grant's birthday.
  if yy == 1897 and mm == mApr and dd == 27:  return some(true)
  # Columbian Celebration.
  if yy == 1892 and mm == mOct and dd in [12,21]:  return some(true)
  if yy == 1893 and mm == mApr and dd == 27:  return some(true)
  # Centennial celebration of Washington's inauguration.
  if yy == 1889:
    if mm == mApr and (dd == 30 or dd == 30):  return some(true)
    if mm == mMay and dd == 1:  return some(true)
  # 1888
  if yy == 1888: 
    # Friday after Thanksgiving Day.
    if mm == mNov and dd == 30:  return some(true)
    # Blizzard of 1888.
    if mm == mMar and (dd == 12 or dd == 13):  return some(true)

  return some(false)


# ====     Holidays for the U.S. Federal Govt and the U.S. Bond Market     === #

proc  isholidayUSFedGovtOrUSBondMrkt(dt: DateTime, USFedGovtCalendar: bool): 
                                    ?bool =
  ## 'U.S. Federal Govt' and 'U.S. Bond Market' have:
  ##   - 9 common holidays
  ##   - 2 common holidays that can be observed differently  
  ##     (New Year's Day, Juneteenth Independance Day)
  ##   - 2 separate holidays  (Inauguration Day and Good Friday)
  if dt.isholiday(hdayUSMartinLutherKingBirthday) and dt.year > 1983:  return some(true)
  if dt.isholiday(hdayUSWashingtonBirthday) and dt.year > 1879:  return some(true)
  if dt.isholiday(hdayUSMemorialDay) and dt.year > 1968:  return some(true)
  if dt.isholiday(hdayUSIndependenceDayObs) and dt.year > 1870:  return some(true)
  if dt.isholiday(hdayUSLaborDay) and dt.year > 1894:  return some(true)
  if dt.isholiday(hdayUSColumbusDay) and dt.year > 1968:  return some(true)
  if dt.isholiday(hdayUSVeteransDayObs) and dt.year > 1938:  return some(true)
  if dt.isholiday(hdayUSThanksgivingDay) and dt.year > 1941:  return some(true)
  if dt.isholiday(hdayUSChristmasDayObs) and dt.year > 1870:  return some(true)
  if USFedGovtCalendar:
    if dt.isholiday(hdayUSNewYearsDayObs) and dt.year > 1870:  return some(true)
    if dt.isholiday(hdayUSInaugurationDayObs):  return some(true)
    if dt.isholiday(hdayUSJuneteenthIndependenceDayObs) and dt.year > 2020:  return some(true)
  else:
    if dt.isholiday(hdayUSNYSENewYearsDayObs) and dt.year > 1870:  return some(true)
    if dt.isholiday(hdayGoodFriday) and dt.year > 1886:  return some(true)
    if dt.isholiday(hdayUSJuneteenthIndependenceDayObs) and dt.year > 2021:  return some(true)
  return some(false)


proc  isholidayUSFederalGovt*(dt: DateTime): ?bool =
  ##[
  **Returns:**
    - `some(true)` if `dt` is a holiday in the U.S. Federal Government calendar
    - `some(false)` if `dt` is not a holiday in the U.S. Federal Government calendar
    - `none(bool)` if the system cannot answer the question

  **Business days and holidays:**

    In the U.S. Federal Government calendars **all days are operating days except**:
    - Saturdays and Sundays (weekends)
    - Holidays that are moved to Monday if it is Sunday, or to Friday if it is Saturday:
      - New Year's Day, January 1st, since 1871
      - Christmas Day, December 25th, since 1871
      - Independence Day, July 4th, since 1871
      - Veterans' Day, November 11th, since 1939 
      - Juneteenth National Independence Day, June 19th, since 2021
    - Holidays that are moved to Monday if it is Sunday:
      - Inauguration Day, since 1789
    - Other holidays:
      - Washington's Birthday, 3rd Monday in February, since 1880 
      - Labor Day, 1st Monday in September, since 1895
      - Thanksgiving Day, 4th Thursday in November, since 1942
      - Memorial Day, last Monday in May, since 1969
      - Columbus Day, 2nd Monday in October, since 1969
      - Martin Luther King's birthday, third Monday in January, since 1983

  **References:**
    - https://en.wikipedia.org/wiki/Federal_holidays_in_the_United_States#List_of_federal_holidays
    - https://en.wikipedia.org/wiki/United_States_presidential_inauguration

  **Notes:**

    The results provided by this procedure have been **successfully compared** 
    to the 209 holidays of the years 2011 to 2030. These holidays can be viewed
    here:
    - https://www.opm.gov/policy-data-oversight/pay-leave/federal-holidays/#url=Historical-Data
  ]##
  runnableExamples:
    doAssert:  !isholidayUSFederalGovt(dateTime(1993, mJan, 20)) # Inauguration Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2010, mDec, 31)) # New Year's Day 
    doAssert:  !isholidayUSFederalGovt(dateTime(2012, mJan, 2)) # New Year's Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2013, mJan, 21)) # Martin Luther King
    doAssert:  !isholidayUSFederalGovt(dateTime(2014, mFeb, 17)) # Washington’s Birthday
    doAssert:  !isholidayUSFederalGovt(dateTime(2015, mMay, 25)) # Memorial Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2015, mJul, 3)) # Independence Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2016, mSep, 5)) # Labor Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2017, mOct, 9)) # Columbus Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2018, mNov, 12)) # Veterans Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2019, mNov, 28)) # Thanksgiving Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2021, mDec, 24)) # Christmas Day
  result = isholidayUSFedGovtOrUSBondMrkt(dt, USFedGovtCalendar = true)


proc  isholidayUSBondMrkt*(dt: DateTime): ?bool =
  ##[
  **Returns:**
    - `some(true)` if `dt` is a holiday in the U.S. Bond Market
    - `some(false)` if `dt` is not a holiday in the U.S. Bond Market
    - `none(bool)` if the system cannot answer the question

  **Holidays:**

    In the U.S. Bond Market, holidays are those of the 
    U.S. Federal Government, with the exception of:
      - Inauguration Day (not observed on U.S. Bond Market)
      - Good Friday (not observed by the U.S. Federal Government)
      - New Year's Day
        - similarly observed when January 1 is not a Saturday
        - observed on Friday December 31 by the U.S. Federal Government 
          while January 1 is a Saturday (not observed by the U.S. Bond 
          Market in this case) 
      - Juneteenth National Independence Day
        - observed since 2022 in the U.S. Bond Market
        - observed since 2021 for the U.S. Federal Government  
      - Special Closings (may differ)

  **See also:**
    - `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_
  ]##
  
  # Official Closings
  # -----------------
  
  if isholiday =? isholidayUSFedGovtOrUSBondMrkt(dt, USFedGovtCalendar = false):
    if isholiday:  return some(true)
  
  # Special Closings
  # ----------------

  # President George H.W. Bush's funeral
  # <https://www.newyorkfed.org/markets/opolicy/operating_policy_181204>
  if dt.cmpDate(dateTime(2018, mDec, 5.MonthdayRange)) == 0:  return some(true)

  return some(false)
