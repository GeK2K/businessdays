# examples of use in 'holidays_us.nim'
template defineSpecialDate(varName, procName: untyped; 
                           month: Month; monthday: MonthDayRange; 
                           runnableExamples: untyped): untyped =
  let varName* = newMonthMonthday(month, monthday)
  proc procName*(year: int; hour: HourRange = 0; minute: MinuteRange = 0; 
                 second: SecondRange = 0; nanosecond: NanosecondRange = 0; 
                 zone: Timezone = local()): DateTime {.inline.} =
    runnableExamples
    result = dateTime(year, month, monthday, hour, minute, second, nanosecond, zone)
