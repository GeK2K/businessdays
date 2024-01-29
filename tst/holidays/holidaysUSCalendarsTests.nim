import  std/[algorithm, strutils, tables]
import  businessdays

# mapping:  klndr -> (data file, min year in data file, max year in data file)
let context = 
  {klndrUSFederalGovt: ("holidaysUSFederalGovtObserved.txt", 2011, 2030),
   klndrUSBondMrktCalendar: ("holidaysUSBondMrktObserved.txt", 2018, 2027),
   klndrUSNYSE: ("holidaysUSNYSEObserved.txt", 2012, 2025)}.toTable

for klndr in context.keys:
  # holidays observed
  let file = open(context[klndr][0])
  let N = 40_000
  var holidaysObserved = newSeqOfCap[DateTime](N)
  try:  
    var line : string
    while file.readLine(line):
      if line.strip == "" or line[0] == '#':  continue  # comment lines are ignored
      let dates = line.split('|')  
      for date in dates:
        let splitDate = date.strip.split('/')    
        doAssert: splitDate.len == 3
        let year = splitDate[0].parseInt
        let month = splitDate[1].parseInt.Month
        let monthday = splitDate[2].parseInt.MonthdayRange
        holidaysObserved.add(dateTime(year, month, monthday))
  finally:
    close(file)

  # holidays calculated
  let startYear = context[klndr][1]
  let endYear = context[klndr][2]
  let calendar = 
    case klndr:
      of klndrUSFederalGovt:  newCalendarUSFederalGovt()
      of klndrUSBondMrktCalendar:  newCalendarUSBondMrkt()
      of klndrUSNYSE: newCalendarUSNYSE()
      else:  newCalendarUSFederalGovt()
  let holidaysCalculated = 
    calendar.observedHolidays(dateTime(startYear, mJan, 1), dateTime(endYear, mDec, 31))

  # TEST
  doAssert: sorted(holidaysCalculated) == sorted(holidaysObserved)

  # echo calendar.observedHolidays(2025)
  #echo sorted(calendar.observedHolidays(2025))
  # let b = sorted(holidaysObserved)
  # doAssert:  len(a) == len(b) 
  # for i in low(a)..high(a):
  #  if a[i] != b[i]:  echo $a[i], "  --  ", $b[i]


