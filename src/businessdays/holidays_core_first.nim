# =============================     bdHoliday     ============================ #

type
  bdHoliday* = enum
    ##[ 
    Holidays natively supported by the system. 

    For each `hdayXXXX` holiday there exists a `holidayXXXX` `proc` whose 
    documentation contains useful information. For example, to the 
    `hdayBoxingDay` item corresponds the `holidayBoxingDay` `proc`; to the 
	`hdayUSMemorialDay` item corresponds the `holidayUSMemorialDay` `proc`; 
    and so on.
    ]##
    hdayAscension, hdayEasterMonday, hdayGoodFriday, hdayEasterSunday,
    hdayWhitMonday, hdayWhitSunday,
    # cause of the definition of the 'bdHolidayEasterNCo' range below,
    # the order of the above items should not be changed
    hdayBoxingDay, hdayChristmasDay, hdayDecember31, hdayLabourDay, 
    hdayNewYearsDay, hdayUSChristmasDayObs, hdayUSColumbusDay, 
    hdayUSInaugurationDay, hdayUSInaugurationDayObs, hdayUSIndependenceDay, 
    hdayUSIndependenceDayObs, hdayUSJuneteenthIndependenceDay,
    hdayUSJuneteenthIndependenceDayObs, hdayUSLaborDay,
    hdayUSMartinLutherKingBirthday, hdayUSMemorialDay, hdayUSNewYearsDayObs, 
    hdayUSNYSEElectionDay, hdayUSNYSENewYearsDayObs, hdayUSThanksgivingDay, 
    hdayUSVeteransDay, hdayUSVeteransDayObs, hdayUSWashingtonBirthday,
    
  bdHolidayEasterNCo* = range[hdayAscension..hdayWhitSunday]
    ##[
    Easter and related holidays (Pentecost, Ascension, etc.).

    **See also:**
      - `bdHoliday <#bdHoliday>`_
    ]## 


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


# ===================     New Year's Day (January 1st)     =================== #

let NewYearsDay* = newMonthMonthday(mJan, 1)  ## New Year's Day (January 1st)

proc  holidayNewYearsDay*(year: int, zone: TimeZone = local()): 
                         DateTime {.inline.} =
  ##[ 
  Returns the *New Year's Day (January 1st)*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayNewYearsDay(2016) ~== dateTime(2016, mJan, 1)
    doAssert:  !holiday(2016, hdayNewYearsDay) ~== dateTime(2016, mJan, 1)
  dateTime(year, NewYearsDay.month, NewYearsDay.monthday, zone = zone)


# ===================     Christmas Day (December 25th)     ================== #

let ChristmasDay* = newMonthMonthday(mDec, 25)  ## Christmas Day (December 25th)

proc  holidayChristmasDay*(year: int, zone: TimeZone = local()): 
                          DateTime {.inline.} =
  ##[
  Returns the *Christmas Day (December 25th)*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayChristmasDay(2016) ~== dateTime(2016, mDec, 25)
    doAssert:  !holiday(2016, hdayChristmasDay) ~== dateTime(2016, mDec, 25)
  dateTime(year, ChristmasDay.month, ChristmasDay.monthday, zone = zone)


# =======================     Labour Day  (May 1st)     ====================== #

let LabourDay* = newMonthMonthday(mMay, 1)  ## Labour Day (May 1st)

proc  holidayLabourDay*(year: int, zone: TimeZone = local()): 
                       DateTime {.inline.} =
  ##[ 
  Returns the *Labour Day (May 1st)*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayLabourDay(2016) ~== dateTime(2016, mMay, 1)
    doAssert:  !holiday(2016, hdayLabourDay) ~== dateTime(2016, mMay, 1)
  dateTime(year, LabourDay.month, LabourDay.monthday, zone = zone)


# ====================     Boxing Day  (December 26th)     =================== #

let BoxingDay* = newMonthMonthday(mDec, 26)  ## Boxing Day (December 26th)

proc  holidayBoxingDay*(year: int, zone: TimeZone = local()): 
                       DateTime {.inline.} =
  ##[ 
  Returns the *Boxing Day (December 26th)*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayBoxingDay(2016) ~== dateTime(2016, mDec, 26)
    doAssert:  !holiday(2016, hdayBoxingDay) ~== dateTime(2016, mDec, 26)
  dateTime(year, BoxingDay.month, BoxingDay.monthday, zone = zone)


# ===========================     December 31st     ========================== #

let December31* = newMonthMonthday(mDec, 31)  ## December 31st

proc  holidayDecember31*(year: int, zone: TimeZone = local()): 
                        DateTime {.inline.} =
  ##[ 
  Returns the *December 31st*
  of the year received in parameter.

  **Postconditions:**
    - `result.zone = zone`

  **See also:**
    - `holiday <#holiday,int,bdHoliday,Timezone>`_
  ]##
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  holidayDecember31(2016) ~== dateTime(2016, mDec, 31)
    doAssert:  !holiday(2016, hdayDecember31) ~== dateTime(2016, mDec, 31)
  dateTime(year, December31.month, December31.monthday, zone = zone)


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
    - `gregorianEasterSundayMMDD <https://gek2k.github.io/easter/easter.html#gregorianEasterSundayMMDD%2Cint>`_
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
                                Table[bdHolidayEasterNCo, DateTime] =
  ##[
  **Returns:**
    - The dates of Gregorian Easter (Sunday and Monday), 
      Good Friday, Ascension and Pentecost (Sunday and Monday), 
      of the year given in parameter if `year >= 1583`.
    - An empty `Table` if `year < 1583`.

  **See also:**
    - `gregorianEasterSundayMMDD <https://gek2k.github.io/easter/easter.html#gregorianEasterSundayMMDD%2Cint>`_
  ]##

  runnableExamples:
    doAssert:  gregorianEasterSundayNCo(1200).len == 0
    doAssert:  gregorianEasterSundayNCo(1582).len == 0

    let easterNCo = gregorianEasterSundayNCo(2018)
    doAssert:  easterNCo[hdayEasterSunday] ~== dateTime(2018, mApr, 1)
    doAssert:  easterNCo[hdayEasterMonday] ~== dateTime(2018, mApr, 2)
    doAssert:  easterNCo[hdayGoodFriday] ~== dateTime(2018, mMar, 30)
    doAssert:  easterNCo[hdayAscension] ~== dateTime(2018, mMay, 10)
    doAssert:  easterNCo[hdayWhitSunday] ~== dateTime(2018, mMay, 20)
    doAssert:  easterNCo[hdayWhitMonday] ~== dateTime(2018, mMay, 21)

  if easterSunday =? gregorianEasterSunday(year = year, hour = hour, 
                                           minute = minute, second = second,
                                           nanosecond = nanosecond, zone = zone):
    result[hdayEasterSunday] = easterSunday
    result[hdayEasterMonday] = easterSunday + 1.days
    result[hdayGoodFriday] = easterSunday - 2.days
    result[hdayAscension] = easterSunday + 39.days
    result[hdayWhitSunday] = easterSunday + 49.days
    result[hdayWhitMonday] = easterSunday + 50.days
