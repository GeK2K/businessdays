##[
===========
easter_days
===========

Easter and related public holidays (Good Friday, Whit Monday, etc.).
]##


# =========================     Imports / Exports     ======================== #

import  std/[tables], questionable, nimutils/[nutimes]
export  tables, questionable, nutimes


# =========================     Types & Constants     ======================== #

type
  EasterRelatedDays* = tuple
    ## For a given year, Easter and related days can be stored in a `tuple` of this type.
    GoodFriday: DateTime 
    EasterSunday: DateTime 
    EasterMonday: DateTime
    Ascension: DateTime
    WhitSunday: DateTime 
    WhitMonday: DateTime

const 
  # For speed-up some calculations we pre-compute and store some Easter dates.
  startYearEaster* {.intdefine.} = 1970
    ##[ 
    Pre-calculated Easter dates begin in `<startYearEaster>`

    **Assertions:**
      - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
        `startYearEaster >= 1583` (the Gregorian calendar came into effect on October 15th, 1582).
    ]##
  endYearEaster* {.intdefine.} = 2200
    ##[ 
    Pre-calculated Easter dates end in `<endYearEaster>`.

    **Assertions:**
      - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
        `endYearEaster >= startYearEaster`
    ]##


# ====================     Pre-calculated Easter dates     =================== #

proc computeEasterNCo(startYear, endYear: int): Table[int, EasterRelatedDays] =
  # The Gregorian Easter day only makes sense from the year 1583.
  doAssert:  1583 <= startYear  and  startYear <= endYear
  result = initTable[int, EasterRelatedDays](endYear-startYear+1)
  for year in startYear..endYear:
    if easterSunday =? gregorianEasterSunday(year):
      let ascension = easterSunday + 39.days
      let whitSunday = ascension + 10.days
      let whitMonday = whitSunday + 1.days
      result[year] = (GoodFriday: easterSunday - 2.days,
                      EasterSunday: easterSunday,
                      EasterMonday: easterSunday + 1.days,
                      Ascension: ascension,
                      WhitSunday: whitSunday,
                      WhitMonday: whitMonday)


let easterRelatedDays*: Table[int, EasterRelatedDays] = computeEasterNCo(startYearEaster, endYearEaster)
  ##[ 
  Pre-calculated Easter dates and related public holidays (Good Friday, 
  Whit Monday, etc.) between `<startYearEaster>` and `<endYearEaster>`.
  ]##


# ===============================     Getters     ============================== #

proc equalDefaultVal(hour: HourRange, minute: MinuteRange, second: SecondRange, 
                     nanosecond: NanosecondRange, zone: Timezone): bool =
  hour == 0 and minute == 0 and second == 0 and nanosecond == 0 and zone == local()


proc holidaysRelated2Easter*(year: int): ?EasterRelatedDays =
  ## - Returns `none(EasterRelatedDays)` if `year < startYearEaster or year > endYearEaster`.
  ## - Else, returns the *Easter Sunday* day and related holidays 
  ##   (Good Friday, Whit Monday, etc.) of the year received in parameter.
  if year < startYearEaster or year > endYearEaster:
    return none(EasterRelatedDays)
  else:
    return easterRelatedDays[year].some


proc holidayEasterSunday*(year: int, hour: HourRange = 0, minute: MinuteRange = 0, 
                          second: SecondRange = 0, nanosecond: NanosecondRange = 0, 
                          zone: Timezone = local()): ?DateTime =
  ## Returns the *Easter Sunday* day of the year received in parameter (desired time can be specified).
  runnableExamples:
    doAssert:  !holidayEasterSunday(2018) ==~ dateTime(2018, mApr, 1)
  if hdaysRel2Easter =? holidaysRelated2Easter(year):
    let easterSunday = hdaysRel2Easter.EasterSunday
    if equalDefaultVal(hour, minute, second, nanosecond, zone):
      return easterSunday.some
    else:
      return dateTime(easterSunday.year, easterSunday.month, easterSunday.monthday, 
                      hour, minute, second, nanosecond, zone).some


proc holidayEasterMonday*(year: int, hour: HourRange = 0, minute: MinuteRange = 0, 
                          second: SecondRange = 0, nanosecond: NanosecondRange = 0, 
                          zone: Timezone = local()): ?DateTime =
  ## Returns the *Easter Monday* of the year received in parameter (desired time can be specified).
  runnableExamples:
    doAssert:  !holidayEasterMonday(2018) ==~ dateTime(2018, mApr, 2)
  if hdaysRel2Easter =? holidaysRelated2Easter(year):
    let easterMonday = hdaysRel2Easter.EasterMonday
    if equalDefaultVal(hour, minute, second, nanosecond, zone):
      return easterMonday.some
    else:
      return dateTime(easterMonday.year, easterMonday.month, easterMonday.monthday, 
                      hour, minute, second, nanosecond, zone).some


proc holidayGoodFriday*(year: int, hour: HourRange = 0, minute: MinuteRange = 0, 
                        second: SecondRange = 0, nanosecond: NanosecondRange = 0, 
                        zone: Timezone = local()): ?DateTime =
  ## Returns the *Good Friday* of the year received in parameter (desired time can be specified).
  runnableExamples:
    doAssert:  !holidayGoodFriday(2018) ==~ dateTime(2018, mMar, 30)
  if hdaysRel2Easter =? holidaysRelated2Easter(year):
    let goodFriday = hdaysRel2Easter.GoodFriday
    if equalDefaultVal(hour, minute, second, nanosecond, zone):
      return goodFriday.some
    else:
      return dateTime(goodFriday.year, goodFriday.month, goodFriday.monthday, 
                      hour, minute, second, nanosecond, zone).some


proc holidayAscension*(year: int, hour: HourRange = 0, minute: MinuteRange = 0, 
                       second: SecondRange = 0, nanosecond: NanosecondRange = 0, 
                       zone: Timezone = local()): ?DateTime =
  ## Returns the *Ascension* day of the year received in parameter (desired time can be specified).
  runnableExamples:
    doAssert:  !holidayAscension(2018) ==~ dateTime(2018, mMay, 10)
  if hdaysRel2Easter =? holidaysRelated2Easter(year):
    let ascension = hdaysRel2Easter.Ascension
    if equalDefaultVal(hour, minute, second, nanosecond, zone):
      return ascension.some
    else:
      return dateTime(ascension.year, ascension.month, ascension.monthday, 
                      hour, minute, second, nanosecond, zone).some

 
proc holidayWhitMonday*(year: int, hour: HourRange = 0, minute: MinuteRange = 0, 
                        second: SecondRange = 0, nanosecond: NanosecondRange = 0, 
                        zone: Timezone = local()): ?DateTime =
  ## Returns the *Whit Monday* of the year received in parameter (desired time can be specified).
  runnableExamples:
    doAssert:  !holidayWhitMonday(2018) ==~ dateTime(2018, mMay, 21)
  if hdaysRel2Easter =? holidaysRelated2Easter(year):
    let whitMonday = hdaysRel2Easter.WhitMonday
    if equalDefaultVal(hour, minute, second, nanosecond, zone):
      return whitMonday.some
    else:
      return dateTime(whitMonday.year, whitMonday.month, whitMonday.monthday, 
                      hour, minute, second, nanosecond, zone).some


proc holidayWhitSunday*(year: int, hour: HourRange = 0, minute: MinuteRange = 0, 
                        second: SecondRange = 0, nanosecond: NanosecondRange = 0, 
                        zone: Timezone = local()): ?DateTime =
  ## Returns the *Whit Sunday* of the year received in parameter (desired time can be specified).
  runnableExamples:
    doAssert:  !holidayWhitSunday(2018) ==~ dateTime(2018, mMay, 20)
  if hdaysRel2Easter =? holidaysRelated2Easter(year):
    let whitSunday = hdaysRel2Easter.WhitSunday
    if equalDefaultVal(hour, minute, second, nanosecond, zone):
      return whitSunday.some
    else:
      return dateTime(whitSunday.year, whitSunday.month, whitSunday.monthday, 
                      hour, minute, second, nanosecond, zone).some
