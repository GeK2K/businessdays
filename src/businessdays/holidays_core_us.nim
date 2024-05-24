# ===============     Public holidays: with U.S. adjusment     =============== #

# New Year's Day  (January 1st)
# -----------------------------

proc  holidayUSNewYearsDayObs*(year: int, zone: TimeZone = local()): 
                              DateTime {.inline.} =
  ##[
  **Returns:**
    - Monday, January 2, if January 1 is a Sunday.
    - Friday, December 31, if January 1 is a Saturday.
    - January 1, in all other cases.

  **Notes:**
  
    The above rules are based on those that currently 
    apply in the United States for New Year's Day.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holidayNewYearsDay <#holidayNewYearsDay,int,Timezone>`_, 
      `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSNewYearsDayObs(2017) ~== dateTime(2017, mJan, 2)  # Monday
    doAssert:  holidayUSNewYearsDayObs(2022) ~== dateTime(2021, mDec, 31) # Friday
    doAssert:  holidayUSNewYearsDayObs(2020) ~== dateTime(2020, mJan, 1)  # Wednesday
    doAssert:  !holiday(2017, hdayUSNewYearsDayObs) ~== dateTime(2017, mJan, 2)  # Monday
    doAssert:  !holiday(2022, hdayUSNewYearsDayObs) ~== dateTime(2021, mDec, 31) # Friday
    doAssert:  !holiday(2020, hdayUSNewYearsDayObs) ~== dateTime(2020, mJan, 1)  # Wednesday
  holidayNewYearsDay(year, zone).adjustHolidayUSRule


proc  holidayUSNYSENewYearsDayObs*(year: int, zone: TimeZone = local()): 
                                  DateTime {.inline.} =
  ##[
  **Returns:**
    - Monday, January 2, if January 1 is a Sunday.
    - January 1, in all other cases.

  **Notes:**
  
    The above rules are based on those that currently apply 
    to the New York Stock Exchange (NYSE) for New Year's Day.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holidayNewYearsDay <#holidayNewYearsDay,int,Timezone>`_,
      `holidayUSNewYearsDayObs <#holidayUSNewYearsDayObs,int,Timezone>`_,
      `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSNYSENewYearsDayObs(2017) ~== dateTime(2017, mJan, 2)  # Monday
    doAssert:  holidayUSNYSENewYearsDayObs(2022) ~== dateTime(2022, mJan, 1)  # Saturday
    doAssert:  holidayUSNYSENewYearsDayObs(2020) ~== dateTime(2020, mJan, 1)  # Wednesday
    doAssert:  !holiday(2017, hdayUSNYSENewYearsDayObs) ~== dateTime(2017, mJan, 2)  # Monday
    doAssert:  !holiday(2022, hdayUSNYSENewYearsDayObs) ~== dateTime(2022, mJan, 1)  # Saturday
    doAssert:  !holiday(2020, hdayUSNYSENewYearsDayObs) ~== dateTime(2020, mJan, 1)  # Wednesday
  holidayNewYearsDay(year, zone).adjustHolidayUSSundayRule


# Christmas Day  (December 25th)
# -----------------------------

proc  holidayUSChristmasDayObs*(year: int, zone: TimeZone = local()): 
                               DateTime {.inline.} =
  ##[
  **Returns:**
    - Monday, December 26, if December 25 is a Sunday.
    - Friday, December 24, if December 25 is a Saturday.
    - December 25, in all other cases.

  **Notes:**
  
    The above rules are based on those that currently 
    apply in the United States for Christmas Day.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holidayChristmasDay <#holidayChristmasDay,int,Timezone>`_,
      `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSChristmasDayObs(2022) ~== dateTime(2022, mDec, 26) # Monday
    doAssert:  holidayUSChristmasDayObs(2021) ~== dateTime(2021, mDec, 24) # Friday
    doAssert:  holidayUSChristmasDayObs(2019) ~== dateTime(2019, mDec, 25) # Tuesday
    doAssert:  !holiday(2022, hdayUSChristmasDayObs) ~== dateTime(2022, mDec, 26) # Monday
    doAssert:  !holiday(2021, hdayUSChristmasDayObs) ~== dateTime(2021, mDec, 24) # Friday
    doAssert:  !holiday(2019, hdayUSChristmasDayObs) ~== dateTime(2019, mDec, 25) # Tuesday
  holidayChristmasDay(year, zone).adjustHolidayUSRule


# Juneteenth National Independence Day (June 19th)
# ------------------------------------------------

let USJuneteenthIndependenceDay* = newMonthMonthday(mJun, 19)  
    ## U.S. Juneteenth National Independence Day (June 19th)

proc  holidayUSJuneteenthIndependenceDay*(year: int, zone: TimeZone = local()): 
                                         DateTime {.inline.} =
  ##[
  Returns the *U.S. Juneteenth National Independence Day (June 19th)*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSJuneteenthIndependenceDay(2016) ~== dateTime(2016, mJun, 19)
    doAssert:  !holiday(2016, hdayUSJuneteenthIndependenceDay) ~== dateTime(2016, mJun, 19)
  dateTime(year, USJuneteenthIndependenceDay.month, 
           USJuneteenthIndependenceDay.monthday, zone = zone)


proc  holidayUSJuneteenthIndependenceDayObs*(year: int, zone: TimeZone = local()): 
                                            DateTime {.inline.} =
  ##[
  **Returns:**
    - Monday, June 20, if June 19 is a Sunday.
    - Friday, June 18, if June 19 is a Saturday.
    - June 19 in all other cases.

  **Notes:**
  
    The above rules are based on those that currently apply in 
    the United States for Juneteenth National Independence Day.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holidayUSJuneteenthIndependenceDay <#holidayUSJuneteenthIndependenceDay,int,Timezone>`_,
      `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSJuneteenthIndependenceDayObs(2033) ~== dateTime(2033, mJun, 20) # Monday
    doAssert:  holidayUSJuneteenthIndependenceDayObs(2027) ~== dateTime(2027, mJun, 18) # Friday
    doAssert:  holidayUSJuneteenthIndependenceDayObs(2024) ~== dateTime(2024, mJun, 19) # Wednesday
    doAssert:  !holiday(2033, hdayUSJuneteenthIndependenceDayObs) ~== dateTime(2033, mJun, 20) # Monday
    doAssert:  !holiday(2027, hdayUSJuneteenthIndependenceDayObs) ~== dateTime(2027, mJun, 18) # Friday
    doAssert:  !holiday(2024, hdayUSJuneteenthIndependenceDayObs) ~== dateTime(2024, mJun, 19) # Wednesday
  holidayUSJuneteenthIndependenceDay(year, zone).adjustHolidayUSRule
  

# Independence Day (July 4th)
# ---------------------------

let USIndependanceDay* = newMonthMonthday(mJul, 4)  ## U.S.  Independence Day (July 4th)

proc  holidayUSIndependenceDay*(year: int, zone: TimeZone = local()): 
                               DateTime {.inline.} =
  ##[
  Returns the *U.S. Independence Day (July 4th)*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSIndependenceDay(2016) ~== dateTime(2016, mJul, 4)
    doAssert:  !holiday(2016, hdayUSIndependenceDay) ~== dateTime(2016, mJul, 4)
  dateTime(year, USIndependanceDay.month, USIndependanceDay.monthday, zone = zone)


proc  holidayUSIndependenceDayObs*(year: int, zone: TimeZone = local()): 
                                            DateTime {.inline.} =
  ##[
  **Returns:**
    - Monday, July 5, if July 4 is a Sunday.
    - Friday, July 3, if July 4 is a Saturday.
    - July 4, in all other cases.

  **Notes:**
  
    The above rules are based on those that currently 
    apply in the United States for Independence Day.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holidayUSIndependenceDay <#holidayUSIndependenceDay,int,Timezone>`_,
      `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSIndependenceDayObs(2021) ~== dateTime(2021, mJul, 5) # Monday
    doAssert:  holidayUSIndependenceDayObs(2020) ~== dateTime(2020, mJul, 3) # Friday
    doAssert:  holidayUSIndependenceDayObs(2019) ~== dateTime(2019, mJul, 4) # Thursday
    doAssert:  !holiday(2021, hdayUSIndependenceDayObs) ~== dateTime(2021, mJul, 5) # Monday
    doAssert:  !holiday(2020, hdayUSIndependenceDayObs) ~== dateTime(2020, mJul, 3) # Friday
    doAssert:  !holiday(2019, hdayUSIndependenceDayObs) ~== dateTime(2019, mJul, 4) # Thursday
  holidayUSIndependenceDay(year, zone).adjustHolidayUSRule
  

# Veterans’ Day (November 11th)
# -----------------------------

let USVeteransDay* = newMonthMonthday(mNov, 11)  ## U.S. Veterans’ Day (November 11th)

proc  holidayUSVeteransDay*(year: int, zone: TimeZone = local()): 
                           DateTime {.inline.} =
  ##[
  Returns the *U.S. Veterans’ Day (November 11th)*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSVeteransDay(2016) ~== dateTime(2016, mNov, 11)
    doAssert:  !holiday(2016, hdayUSVeteransDay) ~== dateTime(2016, mNov, 11)
  dateTime(year, USVeteransDay.month, USVeteransDay.monthday, zone = zone)


proc  holidayUSVeteransDayObs*(year: int, zone: TimeZone = local()): 
                              DateTime {.inline.} =
  ##[
  **Returns:**
    - Monday, November 12, if November 11 is a Sunday.
    - Friday, November 10, if November 11 is a Saturday.
    - November 11 in all other cases.

  **Notes:**
  
    The above rules are based on those that currently 
    apply in the United States for Veterans’ Day.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holidayUSVeteransDay <#holidayUSVeteransDay,int,Timezone>`_,
      `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSVeteransDayObs(2018) ~== dateTime(2018, mNov, 12) # Monday
    doAssert:  holidayUSVeteransDayObs(2017) ~== dateTime(2017, mNov, 10) # Friday
    doAssert:  holidayUSVeteransDayObs(2014) ~== dateTime(2014, mNov, 11) # Tuesday
    doAssert:  !holiday(2018, hdayUSVeteransDayObs) ~== dateTime(2018, mNov, 12) # Monday
    doAssert:  !holiday(2017, hdayUSVeteransDayObs) ~== dateTime(2017, mNov, 10) # Friday
    doAssert:  !holiday(2014, hdayUSVeteransDayObs) ~== dateTime(2014, mNov, 11) # Tuesday
  holidayUSVeteransDay(year, zone).adjustHolidayUSRule
  

# Inauguration Day (January 20th since 1937, March 4th before)
# ------------------------------------------------------------

proc  holidayUSInaugurationDay*(year: int, zone: TimeZone = local()): ?DateTime =
  ##[ 
  Returns the *U.S. Inauguration Day* of the year received in parameter, that is:
    - April 30 for the year 1789 (1st presidential election).
    - March 4, every presidential election year, from 1793 to 1933.
    - January 20,  every presidential election year, since 1937.
    - `none(DateTime)` for all other years.

  **Postconditions:**
    - `result.zone = zone`

  **References:**
    - https://en.wikipedia.org/wiki/United_States_presidential_inauguration

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSInaugurationDay(1512).isNone # 1st presidential election in 1789
    doAssert:  holidayUSInaugurationDay(2019).isNone # no presidential election in 2019
    doAssert:  !holidayUSInaugurationDay(1789) ~== dateTime(1789, mApr, 30)
    doAssert:  !holidayUSInaugurationDay(1813) ~== dateTime(1813, mMar, 4)
    doAssert:  !holidayUSInaugurationDay(1917) ~== dateTime(1917, mMar, 4)
    doAssert:  !holidayUSInaugurationDay(1985) ~== dateTime(1985, mJan, 20)
    doAssert:  !holidayUSInaugurationDay(1997) ~== dateTime(1997, mJan, 20)
    doAssert:  !holidayUSInaugurationDay(2013) ~== dateTime(2013, mJan, 20)
    doAssert:  !holidayUSInaugurationDay(2021) ~== dateTime(2021, mJan, 20)
    doAssert:  holiday(1512, hdayUSInaugurationDay).isNone
    doAssert:  holiday(2019, hdayUSInaugurationDay).isNone
    doAssert:  !holiday(1789, hdayUSInaugurationDay) ~== dateTime(1789, mApr, 30)
    doAssert:  !holiday(1917, hdayUSInaugurationDay) ~== dateTime(1917, mMar, 4)
    doAssert:  !holiday(1985, hdayUSInaugurationDay) ~== dateTime(1985, mJan, 20)

  if year < 1789:  return none(DateTime)
  elif year == 1789:  return dateTime(1789, mApr, 30, zone = zone).some
  elif year > 1789 and year <= 1933:
    if (year-1789).mod(4) != 0:  return none(DateTime)  
    else:  return dateTime(year, mMar, 4, zone = zone).some
  else:
    if (year-1933).mod(4) != 0:  return none(DateTime)  
    else:  return dateTime(year, mJan, 20, zone = zone).some
  

proc  holidayUSInaugurationDayObs*(year: int, zone: TimeZone = local()): 
                                  ?DateTime {.inline.} =
  ##[
  The observed *U.S. Inauguration Day* of the year received in parameter, 
  that is:
    - Next Monday, if U.S. Inauguration Day is a Sunday.
    - U.S. Inauguration Day in all other cases.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holidayUSInaugurationDay <#holidayUSInaugurationDay,int,Timezone>`_,
      `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSInaugurationDayObs(1512).isNone # 1st presidential election in 1789
    doAssert:  holidayUSInaugurationDayObs(2019).isNone # no presidential election in 2019
    doAssert:  !holidayUSInaugurationDayObs(1789) ~== dateTime(1789, mApr, 30) # Thursday
    doAssert:  !holidayUSInaugurationDayObs(1813) ~== dateTime(1813, mMar, 4) # Thursday
    doAssert:  !holidayUSInaugurationDayObs(1917) ~== dateTime(1917, mMar, 5) # Monday
    doAssert:  !holidayUSInaugurationDayObs(1985) ~== dateTime(1985, mJan, 21) # Monday
    doAssert:  !holidayUSInaugurationDayObs(1997) ~== dateTime(1997, mJan, 20) # Monday
    doAssert:  !holidayUSInaugurationDayObs(2013) ~== dateTime(2013, mJan, 21) # Monday
    doAssert:  !holidayUSInaugurationDayObs(2021) ~== dateTime(2021, mJan, 20) # Wednesday
    doAssert:  holiday(1512, hdayUSInaugurationDayObs).isNone
    doAssert:  holiday(2019, hdayUSInaugurationDayObs).isNone
    doAssert:  !holiday(1789, hdayUSInaugurationDayObs) ~== dateTime(1789, mApr, 30) # Thursday
    doAssert:  !holiday(2013, hdayUSInaugurationDayObs) ~== dateTime(2013, mJan, 21) # Monday
    doAssert:  !holiday(2021, hdayUSInaugurationDayObs) ~== dateTime(2021, mJan, 20) # Wednesday
  holidayUSInaugurationDay(year, zone).?adjustHolidayUSSundayRule


# ================     Public holidays: no U.S. adjusment     ================ #

# Birthday of Martin Luther King 
# ------------------------------

proc  holidayUSMartinLutherKingBirthday*(year: int, zone: TimeZone = local()): 
                                        DateTime =
  ##[ 
  Returns the *3rd Monday in January*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSMartinLutherKingBirthday(2035) ~== dateTime(2035, mJan, 15)
    doAssert:  !holiday(2035, hdayUSMartinLutherKingBirthday) ~== dateTime(2035, mJan, 15)
  let monthday = nthWeekday(year = year, month = mJan, weekday = dMon, 
                            nthOccurrence = 3)
  assert: monthday.isSome
  result = dateTime(year, mJan, !monthday, zone = zone) 


# Washington's Birthday
# ---------------------

proc  holidayUSWashingtonBirthday*(year: int, zone: TimeZone = local()): DateTime =
  ##[ 
  Returns the *3rd Monday in February*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSWashingtonBirthday(2035) ~== dateTime(2035, mFeb, 19)
    doAssert:  !holiday(2035, hdayUSWashingtonBirthday) ~== dateTime(2035, mFeb, 19)
  let monthday = nthWeekday(year = year, month = mFeb, weekday = dMon, 
                            nthOccurrence = 3)
  assert: monthday.isSome
  result = dateTime(year, mFeb, !monthday, zone = zone) 


# Memorial Day
# ------------

proc  holidayUSMemorialDay*(year: int, zone: TimeZone = local()): DateTime =
  ##[ 
  Returns the *U.S. Memorial Day (last Monday in May)*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSMemorialDay(2035) ~== dateTime(2035, mMay, 28)
    doAssert:  !holiday(2035, hdayUSMemorialDay) ~== dateTime(2035, mMay, 28)
  let monthday = nthWeekday(year = year, month = mMay, weekday = dMon, 
                            nthOccurrence = -1)
  assert: monthday.isSome
  result = dateTime(year, mMay, !monthday, zone = zone)


# Labor Day
# ---------

proc  holidayUSLaborDay*(year: int, zone: TimeZone = local()): DateTime =
  ##[ 
  Returns the *U.S. Labor Day (1st Monday in September)*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##

  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSLaborDay(2035) ~== dateTime(2035, mSep, 3)
    doAssert:  !holiday(2035, hdayUSLaborDay) ~== dateTime(2035, mSep, 3)

  let monthday = nthWeekday(year = year, month = mSep, weekday = dMon, 
                            nthOccurrence = 1)
  assert: monthday.isSome
  result = dateTime(year, mSep, !monthday, zone = zone)


# Columbus Day
# ------------

proc  holidayUSColumbusDay*(year: int, zone: TimeZone = local()): DateTime =
  ##[ 
  Returns the *U.S. Columbus Day (2nd Monday in October)*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSColumbusDay(2003) ~== dateTime(2003, mOct, 13)
    doAssert:  !holiday(2003, hdayUSColumbusDay) ~== dateTime(2003, mOct, 13)
  let monthday = nthWeekday(year = year, month = mOct, weekday = dMon, 
                            nthOccurrence = 2)
  assert: monthday.isSome
  result = dateTime(year, mOct, !monthday, zone = zone)


# Thanksgiving Day
# ----------------  

proc  holidayUSThanksgivingDay*(year: int, zone: TimeZone = local()): DateTime =
  ##[ 
  Returns the *U.S. Thanksgiving Day (4th Thursday in November)*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSThanksgivingDay(2035) ~== dateTime(2035, mNov, 22)
    doAssert:  !holiday(2035, hdayUSThanksgivingDay) ~== dateTime(2035, mNov, 22)

  let monthday = nthWeekday(year = year, month = mNov, weekday = dThu, 
                            nthOccurrence = 4)
  assert: monthday.isSome
  result = dateTime(year, mNov, !monthday, zone = zone)


# U.S. Election Day
# -----------------  

proc  holidayUSNYSEElectionDay*(year: int, zone: TimeZone = local()): DateTime =
  ##[ 
  Returns "the Tuesday next after the first Monday in November"
  of the year received in parameter.
  
  **Notes:**
  
  These calculations also apply in years when there is no presidential election.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayUSNYSEElectionDay(2035) ~== dateTime(2035, mNov, 6)
    doAssert:  !holiday(2035, hdayUSNYSEElectionDay) ~== dateTime(2035, mNov, 6)
  let monthday = nthWeekday(year = year, month = mNov, weekday = dMon, 
                            nthOccurrence = 1)
  assert: monthday.isSome
  result = dateTime(year, mNov, !monthday, zone = zone) + 1.days

