import  std/[unittest, algorithm, intsets, strscans, sequtils, strutils, tables]
import  businessdays


# public holidays observed for each calendar
let hdaysByKlndr = {#
  klndrUKEngland: "hdaysObsEngland.txt",
  klndrUKScotland: "hdaysObsScotland.txt",
  klndrUKNorthenIreland: "hdaysObsNorthIreland.txt",
  klndrUSFederalGovt: "hdaysObsUSFederalGovt.txt",
  klndrUSNYSE: "hdaysObsUSNYSE.txt",
  klndrUSBondMarket: "hdaysObsUSBondMrkt.txt"}.toTable


# for each calendar, it is estimated that there are a maximum of 
# 20 public holidays per year times 100 years of observation
const size = 2_000

suite "checking for public holidays observed in different calendars":
  for klndr in hdaysByKlndr.keys:
    var hdaysObs = newSeqOfCap[DateTime](size)  # public holidays observed
    var yearsObs = initIntSet()  # years of observing public holidays
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
            hdaysObs.add(dateTime(year, Month(month), MonthdayRange(monthday)))
            yearsObs.incl(year)
          else:
            notSupposedToGetHere()
    finally:
      close(file)
    # public holidays calculated
    var hdaysCalc = newSeqOfCap[DateTime](size)
    for year in yearsObs:
      hdaysCalc = hdaysCalc.concat(klndr.holidays(year, ignoreWeekend = true))
    # test
    test $klndr:
      check:  sorted(hdaysCalc) == sorted(hdaysObs)
  #[
  echo "Tested calendar:  " & $klndr
  if sorted(hdaysCalc) != sorted(hdaysObs):
    echo sorted(hdaysCalc)
    echo sorted(hdaysObs)
  ]#
