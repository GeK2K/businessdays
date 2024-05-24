# ========================     bdBusinessCalendar     ======================== #

type
  bdBusinessCalendar* = enum
    ## Business calendars that are natively supported by the system.
    klndrNoHolidayOrWeekend = "calendar without holidays or weekends"
    klndrWeekendsOnly = "calendars having weekends but no holidays"
    klndrStaticHolidays = "calendar with static holidays"
    klndrTARGET = "TARGET calendar"
    klndrUSFederalGovt = "U.S. Federal Government calendar"
    klndrUSBondMrktCalendar = "U.S. Bond Market calendar"
    klndrUSNYSE = "New York Stock Exchance (NYSE) calendar"


# ==========================     bdCalendarImpl     ========================== #

type
  bdCalendarImpl = ref object of bdCalendar
    ## Default implementation of the abstract class `bdCalendar`.
    description: string
    weekendDays: set[WeekDay]
    case klndr: bdBusinessCalendar
      of klndrStaticHolidays:  staticHolidays: seq[MonthMonthday]
      else:  discard


# ============================    Constructors     =========================== #

proc  newCalendarStaticHolidays*(staticHolidays: seq[MonthMonthday],
                                 weekendDays: set[WeekDay],
                                 description = $klndrStaticHolidays): 
                                bdCalendar =
  ## Returns a new calendar with static holidays.
  let newCalendar = bdCalendarImpl(klndr: klndrStaticHolidays, 
                                   description: description, 
                                   weekendDays: weekendDays, 
                                   staticHolidays: staticHolidays.deduplicate)
  # 'staticHolidays' field must be in ascending order 
  # for the purposes of the 'binarysearch' procedure
  sort(newCalendar.staticHolidays, cmpDate)
  result = newCalendar


proc  newCalendarNoHolidayOrWeekend*(description = $klndrNoHolidayOrWeekend): 
                                    bdCalendar =
  ## Returns a new calendar without holidays or weekends.
  let newCalendar = bdCalendarImpl(klndr: klndrNoHolidayOrWeekend, 
                                   description: description, weekendDays: {})
  result = newCalendar


proc  newCalendarWeekendsOnly*(weekendDays = {dSat,dSun},
                               description = $klndrWeekendsOnly): bdCalendar =
  ## Returns a new calendar having weekends but no holidays.
  let newCalendar = bdCalendarImpl(description: description, 
                                   weekendDays: weekendDays)
  result = newCalendar


proc  newCalendarTARGET*(description = $klndrTARGET): bdCalendar =
  ## Returns a new TARGET calendar.
  let newCalendar = bdCalendarImpl(klndr: klndrTARGET, description: description, 
                                   weekendDays: {dSat, dSun})
  result = newCalendar


proc  newCalendarUSFederalGovt*(description = $klndrUSFederalGovt): bdCalendar =
  ## Returns a new U.S. Federal Government calendar.
  let newCalendar = bdCalendarImpl(klndr: klndrUSFederalGovt, 
                                   description: description, 
                                   weekendDays: {dSat, dSun})
  result = newCalendar


proc  newCalendarUSBondMrkt*(description = $klndrUSBondMrktCalendar): bdCalendar =
  ## Returns a new U.S. Bond Market calendar.
  let newCalendar = bdCalendarImpl(klndr: klndrUSBondMrktCalendar, 
                                   description: description, 
                                   weekendDays: {dSat, dSun})
  result = newCalendar


proc  newCalendarUSNYSE*(description = $klndrUSNYSE): bdCalendar =
  ## Returns a new U.S. NYSE calendar.
  let newCalendar = bdCalendarImpl(klndr: klndrUSNYSE, description: description, 
                                   weekendDays: {dSat, dSun})
  result = newCalendar


proc  newCalendar*(bizCalendar: bdBusinessCalendar, 
                   description: string = $bizCalendar,
                   weekendDays: set[WeekDay] = {dSat, dSun}, 
                   staticHolidays: seq[MonthMonthday] = @[]): bdCalendar =
  ## Returns a new calendar.
  case bizCalendar
    of klndrStaticHolidays:  
      return newCalendarStaticHolidays(description = description,
                                       weekendDays = weekendDays,
                                       staticHolidays = staticHolidays)
    of klndrNoHolidayOrWeekend:  
      return newCalendarNoHolidayOrWeekend(description = description)
    of klndrWeekendsOnly:  
      return newCalendarWeekendsOnly(description = description,
                                     weekendDays = weekendDays)
    of klndrTARGET:  
      return newCalendarTARGET(description = description)
    of klndrUSFederalGovt:
      return newCalendarUSFederalGovt(description = description)
    of klndrUSBondMrktCalendar:
      return newCalendarUSBondMrkt(description = description)
    of klndrUSNYSE:
      return newCalendarUSNYSE(description = description)


# ==========================     Procs & Methods     ========================= #

method  `$`(calendar: bdCalendarImpl): string =
  ## Returns a string representation of `calendar`.
  case calendar.klndr:
    of klndrWeekendsOnly:  
      result = fmt"{calendar.description} ({$calendar.weekendDays})"
    else:
      result = calendar.description


method  isweekend(calendar: bdCalendarImpl, dt: DateTime): Option[bool] = 
  ##[
  **Returns:**
    - `some(true)` if `dt` is a weekend in the `calendar` calendar.
    - `some(false)` if `dt` is not a weekend in the `calendar` calendar.
    - `none(bool)` if the system cannot answer the question.
  ]##
  (getDayOfWeek(dt) in calendar.weekendDays).some


method  isholiday(calendar: bdCalendarImpl, dt: DateTime): Option[bool] = 
  ##[
  **Returns:**
    - `some(true)` if `dt` is a holiday in the `calendar` calendar.
    - `some(false)` if `dt` is not a holiday in the `calendar` calendar.
    - `none(bool)` if the system cannot answer the question.
  ]##
  case calendar.klndr
    of klndrNoHolidayOrWeekend, klndrWeekendsOnly:  
      return some(false)
    of klndrStaticHolidays: 
      let monthMonthday = newMonthMonthday(dt.month, dt.monthday, some(dt.timeZone))
      return some(calendar.staticHolidays.binarySearch(monthMonthday, cmpDate) != -1)
    of klndrTARGET:  return isholidayTARGETCalendar(dt)
    of klndrUSNYSE:  return isholidayUSNYSE(dt)
    of klndrUSFederalGovt:  return isholidayUSFederalGovt(dt)
    of klndrUSBondMrktCalendar:  return isholidayUSBondMrkt(dt)
