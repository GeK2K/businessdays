# ========================     qtBusinessCalendar     ======================== #

type
  qtBusinessCalendar* = enum
    ## Business calendars that are natively supported by the system.
    klndrNoHolidayOrWeekend = "calendar without holidays or weekends"
    klndrWeekendsOnly = "calendars having weekends but no holidays"
    klndrStaticHolidays = "calendar with static holidays"
    klndrTARGET = "TARGET calendar"
    klndrUSFederalGovt = "U.S. Federal Government calendar"
    klndrUSBondMrktCalendar = "U.S. Bond Market calendar"
    klndrUSNYSE = "New York Stock Exchance (NYSE) calendar"


# ==========================     qtCalendarImpl     ========================== #

type
  qtCalendarImpl = ref object of qtCalendar
    ## Default implementation of the abstract class 'qtCalendar'.
    description: string
    weekendDays: set[WeekDay]
    case klndr: qtBusinessCalendar
      of klndrStaticHolidays:  staticHolidays: seq[MonthMonthday]
      else:  discard


# ============================    Constructors     =========================== #

proc  newCalendarStaticHolidays*(staticHolidays: seq[MonthMonthday],
                                 weekendDays: set[WeekDay],
                                 description = $klndrStaticHolidays): 
                                qtCalendar =
  ## Returns a new calendar with static holidays.
  let newCalendar = qtCalendarImpl(klndr: klndrStaticHolidays, 
                                   description: description, 
                                   weekendDays: weekendDays, 
                                   staticHolidays: staticHolidays.deduplicate)
  # 'staticHolidays' field must be in ascending order 
  # for the purposes of the 'binarysearch' procedure
  sort(newCalendar.staticHolidays, cmpDate)
  result = newCalendar


proc  newCalendarNoHolidayOrWeekend*(description = $klndrNoHolidayOrWeekend): 
                                    qtCalendar =
  ## Returns a new calendar without holidays or weekends.
  let newCalendar = qtCalendarImpl(klndr: klndrNoHolidayOrWeekend, 
                                   description: description, weekendDays: {})
  result = newCalendar


proc  newCalendarWeekendsOnly*(weekendDays = {dSat,dSun},
                               description = $klndrWeekendsOnly): qtCalendar =
  ## Returns a new calendar having weekends but no holidays.
  let newCalendar = qtCalendarImpl(description: description, 
                                   weekendDays: weekendDays)
  result = newCalendar


proc  newCalendarTARGET*(description = $klndrTARGET): qtCalendar =
  ## Returns a new TARGET calendar.
  let newCalendar = qtCalendarImpl(klndr: klndrTARGET, description: description, 
                                   weekendDays: {dSat, dSun})
  result = newCalendar


proc  newCalendarUSFederalGovt*(description = $klndrUSFederalGovt): qtCalendar =
  ## Returns a new U.S. Federal Government calendar.
  let newCalendar = qtCalendarImpl(klndr: klndrUSFederalGovt, 
                                   description: description, 
                                   weekendDays: {dSat, dSun})
  result = newCalendar


proc  newCalendarUSBondMrkt*(description = $klndrUSBondMrktCalendar): qtCalendar =
  ## Returns a new U.S. Bond Market calendar.
  let newCalendar = qtCalendarImpl(klndr: klndrUSBondMrktCalendar, 
                                   description: description, 
                                   weekendDays: {dSat, dSun})
  result = newCalendar


proc  newCalendarUSNYSE*(description = $klndrUSNYSE): qtCalendar =
  ## Returns a new U.S. NYSE calendar.
  let newCalendar = qtCalendarImpl(klndr: klndrUSNYSE, description: description, 
                                   weekendDays: {dSat, dSun})
  result = newCalendar

#[
proc  newCalendar*(bizCalendar: qtBusinessCalendar, 
                   description: string = $bizCalendar,
                   weekendDays: set[WeekDay] = {dSat, dSun}, 
                   staticHolidays: seq[MonthMonthday] = @[]): qtCalendar =
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
]#

# ==========================     Procs & Methods     ========================= #

method  `$`(calendar: qtCalendarImpl): string =
  ## Returns a string representation of `calendar`.
  case calendar.klndr:
    of klndrWeekendsOnly:  
      result = fmt"{calendar.description} ({$calendar.weekendDays})"
    else:
      result = calendar.description


method  isweekend(calendar: qtCalendarImpl, dt: DateTime): Option[bool] = 
  ##[
  **Returns:**
    - `some(true)` if `dt` is a weekend in the `calendar` calendar.
    - `some(false)` if `dt` is not a weekend in the `calendar` calendar.
    - `none(bool)` if the system cannot answer the question.
  ]##
  (getDayOfWeek(dt) in calendar.weekendDays).some


method  isholiday(calendar: qtCalendarImpl, dt: DateTime): Option[bool] = 
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
      let monthMonthday = (month: dt.month, monthday: dt.monthday)
      return some(calendar.staticHolidays.binarySearch(monthMonthday, cmpDate) != -1)
    of klndrTARGET:  return isholidayTARGETCalendar(dt)
    of klndrUSNYSE:  return isholidayUSNYSE(dt)
    of klndrUSFederalGovt:  return isholidayUSFederalGovt(dt)
    of klndrUSBondMrktCalendar:  return isholidayUSBondMrkt(dt)
