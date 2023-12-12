import  std/[options, strutils, times]
import  businessdays


# tests on the years 1583 to 1599 and the year 2100
doAssert: get(gregorianEasterSundayMMDD(1583)) == (month: 4, monthday: 10)
doAssert: get(gregorianEasterSundayMMDD(1584)) == (month: 4, monthday:  1)
doAssert: get(gregorianEasterSundayMMDD(1585)) == (month: 4, monthday: 21)
doAssert: get(gregorianEasterSundayMMDD(1586)) == (month: 4, monthday:  6)
doAssert: get(gregorianEasterSundayMMDD(1587)) == (month: 3, monthday: 29)
doAssert: get(gregorianEasterSundayMMDD(1588)) == (month: 4, monthday: 17)
doAssert: get(gregorianEasterSundayMMDD(1589)) == (month: 4, monthday:  2)
doAssert: get(gregorianEasterSundayMMDD(1590)) == (month: 4, monthday: 22)
doAssert: get(gregorianEasterSundayMMDD(1591)) == (month: 4, monthday: 14)
doAssert: get(gregorianEasterSundayMMDD(1592)) == (month: 3, monthday: 29)
doAssert: get(gregorianEasterSundayMMDD(1593)) == (month: 4, monthday: 18)
doAssert: get(gregorianEasterSundayMMDD(1594)) == (month: 4, monthday: 10)
doAssert: get(gregorianEasterSundayMMDD(1595)) == (month: 3, monthday: 26)
doAssert: get(gregorianEasterSundayMMDD(1596)) == (month: 4, monthday: 14)
doAssert: get(gregorianEasterSundayMMDD(1597)) == (month: 4, monthday:  6)
doAssert: get(gregorianEasterSundayMMDD(1598)) == (month: 3, monthday: 22)
doAssert: get(gregorianEasterSundayMMDD(1599)) == (month: 4, monthday: 11)
doAssert: get(gregorianEasterSundayMMDD(2100)) == (month: 3, monthday: 28)


# tests on the years 1600 to 2099
let file = open("holidaysEasterObserved.txt")
try:
  var line : string
  while file.readLine(line):
    if line[0] == '#':  continue  # comment lines are ignored
    let splitLine = line.splitWhitespace
    doAssert: splitLine.len == 3
    let month = splitLine[0].parseInt.Month
    let monthday = splitLine[1].parseInt.MonthdayRange 
    let year = splitLine[2].parseInt
    let easterSundayObserved = dateTime(year, month, monthday)    
    let easterSundayCalculated = gregorianEasterSundayMMDD(year)
    doAssert: easterSundayCalculated.isSome
    let cmpEasterSunday = 
      easterSundayObserved.cmpDate((month: get(easterSundayCalculated).month.Month, 
                                    monthday: get(easterSundayCalculated).monthDay.MonthdayRange))
    doAssert: cmpEasterSunday == 0
finally:
  close(file)