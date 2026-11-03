import  std/[unittest, algorithm, intsets, strscans, sequtils, strutils, tables]
import  timeit
import  businessdays


# public holidays observed for each calendar
let hdaysByKlndr = {#
  klndrUSBondMarket: "hdaysCalcWithJulia.txt"}.toTable  #  klndrUSFederalGovt


# for each calendar, it is estimated that there are a maximum of 
# 20 public holidays per year times 100 years of observation
const size = 2_000

suite "checking for public holidays calculated by Julia":
  for klndr in hdaysByKlndr.keys:
    var hdaysJulia = newSeqOfCap[DateTime](size)  # public holidays calculated with Julia
    var yearsJulia = initIntSet()  # years of observing public holidays
    let file = open(hdaysByKlndr[klndr])
    try:  
      var line: string
      while file.readLine(line):
        if line.strip == "" or line[0] == '#':  
          continue  # empty and comment lines are ignored
        let dates = line.splitWhitespace()  
        for date in dates:
          var year, month, monthday: int
          if scanf(date.strip, "$i/$i/$i", year, month, monthday):
            hdaysJulia.add(dateTime(year, Month(month), MonthdayRange(monthday)))
            yearsJulia.incl(year)
          else:
            notSupposedToGetHere()
    finally:
      close(file)
    # public holidays calculated with Nim
    var hdaysNim = newSeqOfCap[DateTime](size)
    for year in yearsJulia:
      hdaysNim = hdaysNim.concat(klndr.holidays(year, ignoreWeekend = true))
    # test
#    test $klndr:
#      check:  sorted(hdaysNim) == sorted(hdaysJulia)
    echo "Tested calendar:  " & $klndr
    var hdaysNimSorted = sorted(hdaysNim)
    var hdaysJuliaSorted = sorted(hdaysJulia)
    echo "  Nim - Julia:"
    for d in hdaysNimSorted:
      if d notin hdaysJuliaSorted:  echo "    ", d
      else:  continue
    echo "  Julia - Nim:"
    for d in hdaysJuliaSorted:
      if d notin hdaysNimSorted:  echo "    ", d
      else:  continue
    echo "  Comparison end"


type
  CalendarTARGET = ref object of bdCalendar
  CalendarUSBondMarket = ref object of bdCalendar

method isholiday(calendar: CalendarTARGET, dt: DateTime): bool = dt.isholidayTARGET
method isweekend(calendar: CalendarTARGET, dt: DateTime): bool = dt.weekday in {dSat, dSun}

method isholiday(calendar: CalendarUSBondMarket, dt: DateTime): bool = dt.isholidayUSBondMarket
method isweekend(calendar: CalendarUSBondMarket, dt: DateTime): bool = dt.weekday in {dSat, dSun}

 
let 
  dt0 = dateTime(2015, mJan, 01)
  dt1 = dateTime(2100, mDec, 31)
  calendarTARGET = new(CalendarTARGET)
  calendarUSBondMarket = new(CalendarUSBondMarket)

timeGo(1,10):
  discard calendarTARGET.bdays(dt0,dt1, ynYes, ynYes)

timeGo(1,10):
  discard bdCalendarId.klndrTARGET.bdays(dt0,dt1, ynYes, ynYes)

timeGo(1,100):
  discard calendarUSBondMarket.bdays(dt0,dt1, ynYes, ynYes)

timeGo(1,100):
  discard bdCalendarId.klndrUSBondMarket.bdays(dt0,dt1, ynYes, ynYes)

echo bdCalendarId.klndrUSBondMarket.bdays(dt0,dt1, ynYes, ynYes).len