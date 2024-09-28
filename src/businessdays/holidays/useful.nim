# ==========================     Date adjustment     ========================= #

proc  nextMondayIfSunday*(dt: DateTime): DateTime =
  ##[
  **Returns:**
    - the following Monday if `dt` is a Sunday;
    - `dt` for other days of the week.
  ]##
  if getDayOfWeek(dt) == dSun:  result = dt + 1.days  # following Monday
  else:  result = dt


proc  nextMondayIfWeekend*(dt: DateTime): DateTime =
  ##[
  **Returns:**
    - the following Monday if `dt` is a Sunday or Saturday;
    - `dt` for other days of the week.
  ]##
  let dayOfWeek = getDayOfWeek(dt)
  if dayOfWeek == dSun:  result = dt + 1.days  # following Monday
  elif dayOfWeek == dSat:  result = dt + 2.days  # following Monday
  else:  result = dt


proc  nextWeekday*(dt: DateTime): DateTime =
  ##[
  **Returns:**
    - the following day if `dt` is a Monday, Tuesday, Wednesday or Thursday;
    - the following Monday if `dt` is a Friday, Saturday or Sunday.
  ]##
  let dayOfWeek = getDayOfWeek(dt)
  if dayOfWeek == dSat:  result = dt + 2.days  # following Monday
  elif dayOfWeek == dFri:  result = dt + 3.days  # following Monday
  else:  result = dt + 1.days  # following day


proc  nearestWeekday*(dt: DateTime): DateTime =
  ##[
  **Returns:**
    - the following Monday if `dt` is a Sunday;
    - the previous Friday if `dt` is a Saturday;
    - `dt` for other days of the week.
  ]##
  let dayOfWeek = getDayOfWeek(dt)
  if dayOfWeek == dSun:  result = dt + 1.days  # following Monday
  elif dayOfWeek == dSat:  result = dt - 1.days  # previous Friday
  else:  result = dt


# =============================     Templates     ============================ #

template  defineGetterFromMmdParam(mmd: MonthMonthday,
                                   nameOfProcToDefine: untyped, 
                                   runnableExamples: untyped): untyped =
  # examples in the 'special dates' section below
  proc nameOfProcToDefine*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                           second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                           zone: Timezone = local()): DateTime {.inline.} =
    runnableExamples
    result = dateTime(year, mmd.month, mmd.monthday, hour, minute, second, nanosecond, zone)


template  defineProcHolidayXXXFromMmdParam(mmd: MonthMonthday,
                                           nameOfProcToDefine: untyped, 
                                           runnableExamples: untyped): untyped =
  # examples of use in 'target.nim'
  proc nameOfProcToDefine*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                           second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                           zone: Timezone = local()): ?DateTime {.inline.} =
    runnableExamples
    result = dateTime(year, mmd.month, mmd.monthday, hour, minute, second, nanosecond, zone).some


template  defineProcHolidayXXXByAdjustingMmdParam(mmd: MonthMonthday; nameOfProcToDefine, 
                                                  adjustmentProc, runnableExamples): untyped =
  # examples of use in 'us.nim'
  proc nameOfProcToDefine*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                           second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                           zone: Timezone = local()): ?DateTime {.inline.}  =
    runnableExamples
    let dt = dateTime(year, mmd.month, mmd.monthday, hour, minute, second, nanosecond, zone)
    result = adjustmentProc(dt).some


template  defineProcHolidayXXXFromAnAdjustProc(nameOfProcToDefine, procToAdjust, 
                                               adjustmentProc, runnableExamples): untyped =
  # examples of use in 'us.nim'
  proc nameOfProcToDefine*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                           second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                           zone: Timezone = local()): ?DateTime {.inline.}  =
    runnableExamples
    result = procToAdjust(year, hour, minute, second, nanosecond, zone).?adjustmentProc


template  defineProcHolidayXXXUsingNthWeekdayOfMonth(nameOfProcToDefine: untyped, month: Month, 
                                                     weekday: WeekDay, n: int, delay: int, 
                                                     runnableExamples: untyped): untyped =
  # examples of use in 'us.nim'
  proc nameOfProcToDefine*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                           second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                           zone: Timezone = local()): ?DateTime =
    runnableExamples
    let monthday = nthWeekday(n, weekday, month, year)
    assert: monthday.isSome
    result = (dateTime(year, month, !monthday, hour, minute, second, nanosecond, zone) + delay.days).some


# ===========================     Special dates     ========================== #

# New Year’s Day, January 1st
defineGetterFromMmdParam(NewYearsDay, newYearsDay):
  runnableExamples:
    # the 'New Year’s Day (January 1st)' of the year received as a parameter
    doAssert:  newYearsDay(2016) ==~ dateTime(2016, mJan, 1)


# Saint Patrick's Day, March 17
defineGetterFromMmdParam(StPatricksDay, stPatricksDay):
  runnableExamples:
    # the 'Saint Patrick’s Day (May 17)' of the year received as a parameter
    doAssert:  stPatricksDay(2016) ==~ dateTime(2016, mMar, 17)


# Labour Day, May 1st
defineGetterFromMmdParam(LabourDay, labourDay):
  runnableExamples:
    # the 'Labour Day (May 1st)' of the year received as a parameter
    doAssert:  labourDay(2016) ==~ dateTime(2016, mMay, 1)


# Orangemens’ Day, July 12
defineGetterFromMmdParam(OrangemensDay, orangemensDay):
  runnableExamples:
    # the 'Orangemens’ Day (July 12)' of the year received as a parameter
    doAssert:  orangemensDay(2016) ==~ dateTime(2016, mJul, 12)


# St Andrew’s Day, November 30
defineGetterFromMmdParam(StAndrewsDay, stAndrewsDay):
  runnableExamples:
    # the 'St Andrew’s Day (November 30)' of the year received as a parameter
    doAssert:  stAndrewsDay(2016) ==~ dateTime(2016, mNov, 30)


# Christmas Day, December 25th
defineGetterFromMmdParam(ChristmasDay, christmasDay):
  runnableExamples:
    # the 'Christmas Day (December 25)' of the year received as a parameter
    doAssert:  christmasDay(2016) ==~ dateTime(2016, mDec, 25)


# Boxing Day, December 26th
defineGetterFromMmdParam(BoxingDay, boxingDay):
  runnableExamples:
    # the 'Boxing Day (December 26)' of the year received as a parameter
    doAssert:  boxingDay(2016) ==~ dateTime(2016, mDec, 26)


# December 31st
defineGetterFromMmdParam(December31, december31):
  runnableExamples:
    # the 'December 31st' of the year received as a parameter
    doAssert:  december31(2016) ==~ dateTime(2016, mDec, 31)


# ============================     Easter & Co     =========================== #

proc  holidayEasterNCo*(year: int; hour: HourRange = 0; minute: MinuteRange = 0;
                        second: SecondRange = 0; nanosecond: NanosecondRange = 0;
                        zone: Timezone = local()): Table[bdHoliday, DateTime] =
  ##[
  **Returns:**
    - the dates of Gregorian Easter (Sunday and Monday), 
      Good Friday, Ascension and Pentecost (Sunday and Monday), 
      of the year given in parameter if `year >= 1583`;
    - an empty `Table` if `year < 1583`.

  **See also:**
    - `gregorianEasterSundayMMDD <https://gek2k.github.io/nimutils/docs/nimutils/nudates.html#gregorianEasterSundayMMDD,int>`_
  ]##
  runnableExamples:
    doAssert:  holidayEasterNCo(1200).len == 0
    doAssert:  holidayEasterNCo(1582).len == 0
    #
    let easterNCo = holidayEasterNCo(2018)
    doAssert:  easterNCo[hdayEasterSunday] ==~ dateTime(2018, mApr, 1)
    doAssert:  easterNCo[hdayEasterMonday] ==~ dateTime(2018, mApr, 2)
    doAssert:  easterNCo[hdayGoodFriday] ==~ dateTime(2018, mMar, 30)
    doAssert:  easterNCo[hdayAscension] ==~ dateTime(2018, mMay, 10)
    doAssert:  easterNCo[hdayWhitSunday] ==~ dateTime(2018, mMay, 20)
    doAssert:  easterNCo[hdayWhitMonday] ==~ dateTime(2018, mMay, 21)
    # the result does not contain any other holidays
    doAssert:  not easterNCo.hasKey(hdayTargetNewYearsDay)
    doAssert:  not easterNCo.hasKey(hdayUSChristmasDay)
  if easterSunday =? gregorianEasterSunday(year = year, hour = hour, 
                                           minute = minute, second = second,
                                           nanosecond = nanosecond, zone = zone):
    let ascension = easterSunday + 39.days
    let withSunday = ascension + 10.days
    let whitMonday = withSunday + 1.days
    result[hdayEasterSunday] = easterSunday
    result[hdayEasterMonday] = easterSunday + 1.days
    result[hdayGoodFriday] = easterSunday - 2.days
    result[hdayAscension] = ascension
    result[hdayWhitSunday] = withSunday
    result[hdayWhitMonday] = whitMonday

 
template  holidayEasterSunday*(year: int, hour: HourRange = 0, minute: MinuteRange = 0, 
                               second: SecondRange = 0, nanosecond: NanosecondRange = 0, 
                               zone: TimeZone = local()): ?DateTime =
  ## Returns the *Easter Sunday* day of the year received in parameter.
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayEasterSunday(2018) ==~ dateTime(2018, mApr, 1)
    doAssert:  !holiday(2018, hdayEasterSunday) ==~ dateTime(2018, mApr, 1)
  gregorianEasterSunday(year, hour, minute, second, nanosecond, zone)


proc  holidayEasterMonday*(year: int, hour: HourRange = 0, minute: MinuteRange = 0, 
                           second: SecondRange = 0, nanosecond: NanosecondRange = 0, 
                           zone: TimeZone = local()): ?DateTime {.inline.} =
  ## Returns the *Easter Monday* of the year received in parameter.
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayEasterMonday(2018) ==~ dateTime(2018, mApr, 2)
    doAssert:  !holiday(2018, hdayEasterMonday) ==~ dateTime(2018, mApr, 2)
  result = holidayEasterNCo(year, hour, minute, second, nanosecond, zone)[hdayEasterMonday].some


proc  holidayGoodFriday*(year: int, hour: HourRange = 0, minute: MinuteRange = 0, 
                         second: SecondRange = 0, nanosecond: NanosecondRange = 0, 
                         zone: TimeZone = local()): ?DateTime {.inline.} =
  ## Returns the *Good Friday* of the year received in parameter.
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayGoodFriday(2018) ==~ dateTime(2018, mMar, 30)
    doAssert:  !holiday(2018, hdayGoodFriday) ==~ dateTime(2018, mMar, 30)
  result = holidayEasterNCo(year, hour, minute, second, nanosecond, zone)[hdayGoodFriday].some


proc  holidayAscension*(year: int, hour: HourRange = 0, minute: MinuteRange = 0, 
                        second: SecondRange = 0, nanosecond: NanosecondRange = 0, 
                        zone: TimeZone = local()): ?DateTime {.inline.} =
  ## Returns the *Ascension* day of the year received in parameter.
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayAscension(2018) ==~ dateTime(2018, mMay, 10)
    doAssert:  !holiday(2018, hdayAscension) ==~ dateTime(2018, mMay, 10)
  result = holidayEasterNCo(year, hour, minute, second, nanosecond, zone)[hdayAscension].some

 
proc  holidayWhitMonday*(year: int, hour: HourRange = 0, minute: MinuteRange = 0, 
                         second: SecondRange = 0, nanosecond: NanosecondRange = 0, 
                         zone: TimeZone = local()): ?DateTime {.inline.} =
  ## Returns the *Whit Monday* of the year received in parameter.
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayWhitMonday(2018) ==~ dateTime(2018, mMay, 21)
    doAssert:  !holiday(2018, hdayWhitMonday) ==~ dateTime(2018, mMay, 21)
  result = holidayEasterNCo(year, hour, minute, second, nanosecond, zone)[hdayWhitMonday].some


proc  holidayWhitSunday*(year: int, hour: HourRange = 0, minute: MinuteRange = 0, 
                         second: SecondRange = 0, nanosecond: NanosecondRange = 0, 
                         zone: TimeZone = local()): ?DateTime {.inline.} =
  ## Returns the *Whit Sunday* of the year received in parameter.
  runnableExamples:
    # we proceed in two distinct but equivalent ways
    doAssert:  !holidayWhitSunday(2018) ==~ dateTime(2018, mMay, 20)
    doAssert:  !holiday(2018, hdayWhitSunday) ==~ dateTime(2018, mMay, 20)
  result = holidayEasterNCo(year, hour, minute, second, nanosecond, zone)[hdayWhitSunday].some