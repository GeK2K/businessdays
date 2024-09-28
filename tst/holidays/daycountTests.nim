import  std/times
import  businessdays

let startDate2 = dateTime(2007, mFeb, 28)
let endDate2 = dateTime(2007, mMar, 31)
doAssert:  yearFraction(startDate2, endDate2, dccActual360) == 31.0/360.0
let startDate3 = dateTime(2007, mFeb, 28)
let endDate3 = dateTime(2007, mMar, 31)
doAssert:  yearFraction(startDate3, endDate3, dccActual360) == 31.0/360.0
