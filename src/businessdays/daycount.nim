##[
========
daycount
========
The `daycount` module allows you to calculate the duration between 
two dates according to the calculation convention of your choice.

The user is encouraged to see the `yearFraction` proc for more details.
]##


# =========================     Imports / Exports     ======================== #

import  calendars
export  calendars


# =======================     Day count conventions    ======================= #

type
  DayCountConvention* = enum
    ##[
    Description of each element of the `DayCountConvention` enumeration.

      - *DayCountConvention*.**dccThirtyA360**
          - http://deltaquants.com/day-count-conventions /
            Table 2: DCF calculations / 30/360 ISDA day count method.

      - *DayCountConvention*.**dccThirtyU360**
          - http://deltaquants.com/day-count-conventions /
            Table 2: DCF calculations / 30/360 US day count method.

      - *DayCountConvention*.**dccThirtyE360**
          - http://deltaquants.com/day-count-conventions /
            Table 2: DCF calculations / 30E/360 day count method.

      - *DayCountConvention*.**dccThirtyEPlus360**
          - http://deltaquants.com/day-count-conventions /
            Table 2: DCF calculations / 30E+/360 day count method.

      - *DayCountConvention*.**dccThirtyG360**
          - http://deltaquants.com/day-count-conventions /
            Table 2: DCF calculations / 30/360 German day count method.

      - *DayCountConvention*.**dccActual360**
          - The number of days between the start and end dates is divided by 360
            (each full year is therefore assumed to have 360 ​​days).

      - *DayCountConvention*.**dccActual365F**
          - The number of days between the start and end dates is divided by 365
            (each full year is therefore assumed to have 365 ​​days).	

      - *DayCountConvention*.**dccActual366**
          - The number of days between the start and end dates is divided by 366
            (each full year is therefore assumed to have 366 ​​days).	 

      - *DayCountConvention*.**dccActual364**
          - The number of days between the start and end dates is divided by 364
            (each full year is therefore assumed to have 364 ​​days).	  

      - *DayCountConvention*.**dccActual36525**
          - The number of days between the start and end dates is divided by 365.25
            (each full year is therefore assumed to have 365.25 ​​days).

      - *DayCountConvention*.**dccActual365L**
          - http://deltaquants.com/day-count-conventions /
            Table 2: DCF calculations / Act/365L day count method.

      - *DayCountConvention*.**dccActual365A**
          - http://deltaquants.com/day-count-conventions /
            Table 2: DCF calculations / Act/365A day count method.	

      - *DayCountConvention*.**dccNL365**
          - http://deltaquants.com/day-count-conventions /
            Table 2: DCF calculations / NL/365 day count method.  

      - *DayCountConvention*.**dccActualActual**
          - http://deltaquants.com/day-count-conventions /
            Table 2: DCF calculations / Act/Act day count method.		

      - *DayCountConvention*.**dccActualActualAFB**
          - https://en.wikipedia.org/wiki/Day_count_convention#Actual/Actual_AFB	

      - *DayCountConvention*.**dccBusinessDays252**
          - The number of business days between the start and end dates is divided by 252
            (each full year is therefore assumed to have 252 business ​​days).	

      - *DayCountConvention*.**dccOneOne**
          - https://en.wikipedia.org/wiki/Day_count_convention#1/1   
    ]##  
    dccThirtyA360 = "30A/360"  ## Also known as "30/360 Bond basis" or "30/360 ISDA"
    dccThirtyU360 = "30U/360"  ## Also known as "30US/360", "30/360 US" or "30/360 SIA" 
    dccThirtyE360 = "30E/360"  ## Also known as "30/360 European", "Eurobond basis", 
                               ## "Special German", "30/360 ISMA" or "30/360 ICMA"
    dccThirtyEPlus360 = "30E+/360"  ## No other name known
    dccThirtyG360 = "30/360 German"  ## Also known as "30E/360 ISDA"
    dccActual360 = "Actual/360"  ## Also known as "French" 
    dccActual365F = "Actual/365 Fixed"  ## Also known as "English"
    dccActual366 = "Actual/366"  ## No other name known 
    dccActual364 = "Actual/364"  ## No other name known 
    dccActual36525 = "Actual/365.25"  ## No other name known 
    dccActual365L = "Actual/365L"  ## Also known as "ISMA-Year"
    dccActual365A = "Actual/365A"  ## No other name known 
    dccNL365 = "NL/365"  ## Also known as "Actual/365 No leap year", "NL365"
    dccActualActual = "Actual/Actual" ## Also known as "Actual/Actual ISDA"	
    dccActualActualAFB = "Actual/Actual AFB" ## No other name known
    dccBusinessDays252 = "BusinessDays/252"  ## Also known as "BUS/252" or "BD/252" 
    dccOneOne = "1/1" ## Also known as "One/One"


# =======================     Day count calculations    ====================== #

func  yearFraction360(y1, m1, d1, y2, m2, d2: int): float64 {.inline.} =
  ## Calculates the duration between two dates when 
  ## the calculation convention is a 360 method.
  ## NO CHECK IS MADE ON THE VALUES OF THE PARAMETERS
  ## (these must be done upstream).
  ##   - d1/m1/y1 is the start date
  ##   - d2/m2/y2 is the end date
  float64(360*(y2-y1)+30*(m2-m1)+(d2-d1)) / 360.0
 

#[
NOT USED AT THIS STAGE
func  yearFraction360(startDate, endDate: DateTime): float64 {.inline.} =
  ## Calculates the duration between two dates when 
  ## the calculation convention is a 360 method.
  ## NO CHECK IS MADE ON THE VALUES OF THE PARAMETERS
  ## (these must be done upstream).
  yearFraction360(y1 = startDate.year, m1 = startDate.month.ord, 
    d1 = startDate.monthday, y2 = endDate.year, m2 = endDate.month.ord, 
    d2 = endDate.monthday)
]#


proc  yearFraction*(startDate, endDate: DateTime; dcc: DayCountConvention,
                    calendar: qtCalendar = nil, 
                    dateInterval: BoundedRealInterval = BoundedRightOpen): float64 =
  ##[
  Calculates the duration between the starting date `<startDate>` and 
  the end date `<endDate>`, according to the day count convention `<dcc>`.
  
  **Notes:**
    - If `endDate < startDate` the result is equal to
      `-yearFraction(startDate = endDate, endDate = startDate, dcc, calendar, dateInterval)`.
    - `calendar` and `dateInterval` parameters are 
      only use when `dcc == dccBusinessDays252`.
    - The `dateInterval` parameter allows you to include/exclude 
      `<fromDate>` and `<toDate>` for business day counting. 

  **Main references:**
    - http://deltaquants.com/day-count-conventions
    - https://en.wikipedia.org/wiki/Day_count_convention
    - https://quant.opengamma.io/Interest-Rate-Instruments-and-Market-Conventions.pdf (pp. 5-7)
  ]##

  runnableExamples:
    let utcZone = utc()  # the timezone we will use

    # Time interval 1:  from  31 January 2008  to  28 February 2008  (leap year)
    # --------------------------------------------------------------------------
    let startDate1 = dateTime(2008, mJan, 31, zone = utcZone)
    let endDate1 = dateTime(2008, mFeb, 28, zone = utcZone)

    doAssert: yearFraction(startDate1, endDate1, dccActual360) == 28.0/360.0
    doAssert: yearFraction(startDate1, endDate1, dccThirtyA360) == 28.0/360.0
    doAssert: yearFraction(startDate1, endDate1, dccThirtyU360) == 28.0/360.0
    doAssert: yearFraction(startDate1, endDate1, dccThirtyE360) == 28.0/360.0
    doAssert: yearFraction(startDate1, endDate1, dccThirtyEPlus360) == 28.0/360.0
    doAssert: yearFraction(startDate1, endDate1, dccThirtyG360) == 28.0/360.0

    # Day count is 28.0 for all considered day count conventions.

    # Time interval 2:  from  28 February 2007  to  31 March 2007  (non-leap year)
    # ----------------------------------------------------------------------------
    let startDate2 = dateTime(2007, mFeb, 28, zone = utcZone)
    let endDate2 = dateTime(2007, mMar, 31, zone = utcZone)

    doAssert: yearFraction(startDate2, endDate2, dccActual360) == 31.0/360.0
    doAssert: yearFraction(startDate2, endDate2, dccThirtyA360) == 33.0/360.0
    doAssert: yearFraction(startDate2, endDate2, dccThirtyU360) == 30.0/360.0
    doAssert: yearFraction(startDate2, endDate2, dccThirtyE360) == 32.0/360.0
    doAssert: yearFraction(startDate2, endDate2, dccThirtyEPlus360) == 33.0/360.0
    doAssert: yearFraction(startDate2, endDate2, dccThirtyG360) == 30.0/360.0

    # - Depending on the considered day count convention, 
    #   the day count varies from 30.0 to 33.0 (4 values).
    #
    # - The actual number of days is 31.0. But depending on 
    #   how the convention manages the end of the month, and 
    #   the end of the month of February, we can also obtain 
    #   30.0, 32.0 or 33.0 days.


    # The following 4 numerical examples are taken from
    # http://deltaquants.com/day-count-conventions

    # Time interval 3:  from  28 December 2007  to  28 February 2008
    # --------------------------------------------------------------
    let startDate3 = dateTime(2007, mDec, 28, zone = utcZone)
    let endDate3 = dateTime(2008, mFeb, 28, zone = utcZone)

    doAssert: yearFraction(startDate3, endDate3, dccThirtyA360) == 60.0/360.0
    doAssert: yearFraction(startDate3, endDate3, dccThirtyU360) == 60.0/360.0
    doAssert: yearFraction(startDate3, endDate3, dccThirtyE360) == 60.0/360.0
    doAssert: yearFraction(startDate3, endDate3, dccThirtyEPlus360) == 60.0/360.0
    doAssert: yearFraction(startDate3, endDate3, dccThirtyG360) == 60.0/360.0
    doAssert: yearFraction(startDate3, endDate3, dccActual360) == 62.0/360.0
    doAssert: yearFraction(startDate3, endDate3, dccActual365F) == 62.0/365.0
    doAssert: yearFraction(startDate3, endDate3, dccActual365L) == 62.0/366.0
    doAssert: yearFraction(startDate3, endDate3, dccActual365A) == 62.0/365.0
    doAssert: yearFraction(startDate3, endDate3, dccNL365) == 62.0/365.0
    doAssert: yearFraction(startDate3, endDate3, dccActualActual) == 4.0/365.0+58.0/366.0

    # Time interval 4:  from  28 December 2007  to  29 February 2008
    # --------------------------------------------------------------
    let startDate4 = dateTime(2007, mDec, 28, zone = utcZone)
    let endDate4 = dateTime(2008, mFeb, 29, zone = utcZone)

    doAssert: yearFraction(startDate4, endDate4, dccThirtyA360) == 61.0/360.0
    doAssert: yearFraction(startDate4, endDate4, dccThirtyU360) == 61.0/360.0
    doAssert: yearFraction(startDate4, endDate4, dccThirtyE360) == 61.0/360.0
    doAssert: yearFraction(startDate4, endDate4, dccThirtyEPlus360) == 61.0/360.0
    doAssert: yearFraction(startDate4, endDate4, dccThirtyG360) == 62.0/360.0
    doAssert: yearFraction(startDate4, endDate4, dccActual360) == 63.0/360.0
    doAssert: yearFraction(startDate4, endDate4, dccActual365F) == 63.0/365.0
    doAssert: yearFraction(startDate4, endDate4, dccActual365L) == 63.0/366.0
    doAssert: yearFraction(startDate4, endDate4, dccActual365A) == 63.0/366.0
    doAssert: yearFraction(startDate4, endDate4, dccNL365) == 62.0/365.0
    doAssert: yearFraction(startDate4, endDate4, dccActualActual) == 4.0/365.0+59.0/366.0

    # Time interval 5:  from  31 October 2007  to  30 November 2008
    # --------------------------------------------------------------
    let startDate5 = dateTime(2007, mOct, 31, zone = utcZone)
    let endDate5 = dateTime(2008, mNov, 30, zone = utcZone)

    doAssert: yearFraction(startDate5, endDate5, dccThirtyA360) == 390.0/360.0
    doAssert: yearFraction(startDate5, endDate5, dccThirtyU360) == 390.0/360.0
    doAssert: yearFraction(startDate5, endDate5, dccThirtyE360) == 390.0/360.0
    doAssert: yearFraction(startDate5, endDate5, dccThirtyEPlus360) == 390.0/360.0
    doAssert: yearFraction(startDate5, endDate5, dccThirtyG360) == 390.0/360.0
    doAssert: yearFraction(startDate5, endDate5, dccActual360) == 396.0/360.0
    doAssert: yearFraction(startDate5, endDate5, dccActual365F) == 396.0/365.0
    doAssert: yearFraction(startDate5, endDate5, dccActual365L) == 396.0/366.0
    doAssert: yearFraction(startDate5, endDate5, dccActual365A) == 396.0/366.0
    doAssert: yearFraction(startDate5, endDate5, dccNL365) == 395.0/365.0
    doAssert: yearFraction(startDate5, endDate5, dccActualActual) == 62.0/365.0+334.0/366.0

    # Time interval 6:  from  1 February 2008  to  31 May 2009
    # --------------------------------------------------------
    let startDate6 = dateTime(2008, mFeb, 1, zone = utcZone)
    let endDate6 = dateTime(2009, mMay, 31, zone = utcZone)

    doAssert: yearFraction(startDate6, endDate6, dccThirtyA360) == 480.0/360.0
    doAssert: yearFraction(startDate6, endDate6, dccThirtyU360) == 480.0/360.0
    doAssert: yearFraction(startDate6, endDate6, dccThirtyE360) == 479.0/360.0
    doAssert: yearFraction(startDate6, endDate6, dccThirtyEPlus360) == 480.0/360.0
    doAssert: yearFraction(startDate6, endDate6, dccThirtyG360) == 479.0/360.0
    doAssert: yearFraction(startDate6, endDate6, dccActual360) == 485.0/360.0
    doAssert: yearFraction(startDate6, endDate6, dccActual365F) == 485.0/365.0
    doAssert: yearFraction(startDate6, endDate6, dccActual365L) == 485.0/365.0 
    doAssert: yearFraction(startDate6, endDate6, dccActual365A) == 485.0/366.0
    doAssert: yearFraction(startDate6, endDate6, dccNL365) == 484.0/365.0
    doAssert: yearFraction(startDate6, endDate6, dccActualActual) == 335.0/366.0+150.0/365.0

    # "Actual/Actual AFB" day count method
    # ------------------------------------
    # (https://en.wikipedia.org/wiki/Day_count_convention#Actual/Actual_AFB)
    let startDate7 = dateTime(2004, mFeb, 28, zone = utcZone)
    let endDate7 = dateTime(2008, mFeb, 27, zone = utcZone)
    let endDate7bis = dateTime(2008, mFeb, 28, zone = utcZone)
    let endDate7ter = dateTime(2008, mFeb, 29, zone = utcZone)
    let startDate8 = dateTime(1994, mFeb, 10, zone = utcZone)
    let endDate8 = dateTime(1997, mJun, 30, zone = utcZone)

    doAssert: yearFraction(startDate7, endDate7, dccActualActualAFB) == 3.0+365.0/366.0
    doAssert: yearFraction(startDate7, endDate7bis, dccActualActualAFB) == 4.0
    doAssert: yearFraction(startDate7, endDate7ter, dccActualActualAFB) == 4.0+1.0/366.0
    doAssert: yearFraction(startDate8, endDate8, dccActualActualAFB) == 3.0+140.0/365.0
  
  if endDate < startDate:
    return  (-yearFraction(startDate = endDate, endDate = startDate, 
                           dcc, calendar, dateInterval))

  let y1 = startDate.year
  let m1 = startDate.month.ord
  let d1 = startDate.monthday
  let y2 = endDate.year
  let m2 = endDate.month.ord
  let d2 = endDate.monthday

  case dcc
    of dccThirtyA360:  
      let nd1 = (if d1 == 31:  30  else:  d1)  # new d1
      let nd2 = (if nd1 == 30 and d2 == 31:  30  else:  d2)  # new d2
      return  yearFraction360(y1=y1, m1=m1, d1=nd1, y2=y2, m2=m2, d2=nd2)

    of dccThirtyU360:  
      var nd2 = (if endDate.isLastDayOfFebruary and startDate.isLastDayOfFebruary:  30 
                 else:  d2)  # new d2
      var nd1 = (if startDate.isLastDayOfFebruary:  30
                 else:  d1)  # new d1
      if nd2 == 31 and nd1 in {30,31}:  nd2 = 30
      if nd1 == 31:  nd1 = 30
      return  yearFraction360(y1=y1, m1=m1, d1=nd1, y2=y2, m2=m2, d2=nd2)

    of dccThirtyE360:  
      let nd1 = (if d1 == 31:  30  else:  d1)  # new d1
      let nd2 = (if d2 == 31:  30  else:  d2)  # new d2
      return  yearFraction360(y1=y1, m1=m1, d1=nd1, y2=y2, m2=m2, d2=nd2)

    of dccThirtyEPlus360:  
      let nd1 = (if d1 == 31:  30  else:  d1)  # new d1
      let ndt2 = 
        ( if d2 == 31:  
            let dt3 = dateTime(y2, endDate.month, d2, zone=endDate.timeZone) + 1.days
            dt3
          else:
            endDate
        )
      return  yearFraction360(y1=y1, m1=m1, d1=nd1, y2=ndt2.year, 
                              m2=ndt2.month.ord, d2=ndt2.monthday)

    of dccThirtyG360:  
      let nd1 = (if d1 == 31 or startDate.isLastDayOfFebruary:  30  else:  d1)  # new d1
      let nd2 = (if d2 == 31 or endDate.isLastDayOfFebruary:  30  else:  d2)  # new d2
      return  yearFraction360(y1=y1, m1=m1, d1=nd1, y2=y2, m2=m2, d2=nd2)

    of dccActual360:  
      return  float64((endDate-startDate).inDays) / 360.0

    of dccActual365F:  
      return  float64((endDate-startDate).inDays) / 365.0

    of dccActual366:  
      return  float64((endDate-startDate).inDays) / 366.0

    of dccActual364:  
      return  float64((endDate-startDate).inDays) / 364.0

    of dccActual36525:  
      return  float64((endDate-startDate).inDays) / 365.25

    of dccActual365L:
      let denominateur = (if endDate.year.isLeapYear:  366.0  else:  365.0)
      return  float64((endDate-startDate).inDays) / denominateur

    of dccActual365A, dccNL365:
      # the period [startDate; endDate] is entirely included in the  
      # same year n else it starts in year n and ends in year n+1
      doAssert: y2 == y1 or y2 == y1+1
      let numerator = float64((endDate-startDate).inDays)
      if not startDate.year.isLeapYear and not endDate.year.isLeapYear:
        return numerator/365.0
      let twentyNineFeb = block:
        var twentyNineFeb: DateTime
        if startDate.year.isLeapYear:
          twentyNineFeb = dateTime(y1, mFeb, 29, zone=startDate.timeZone)
        elif endDate.year.isLeapYear:
          twentyNineFeb = dateTime(y2, mFeb, 29, zone=endDate.timeZone)
        else:
          doAssert: false # we're not supposed to get here
        twentyNineFeb
      if startDate < twentyNineFeb and twentyNineFeb <= endDate:
        if dcc == dccActual365A:  return numerator/366.0
        elif dcc == dccNL365:  return (numerator-1.0)/365.0
        else:  doAssert: false # we're not supposed to get here
      else:
        return numerator/365.0

    of dccActualActual:  
      if y1 == y2:
        if y1.isLeapYear:  return float64((endDate-startDate).inDays)/366.0
        else:  return float64((endDate-startDate).inDays)/365.0
      else:
        let dt3 = dateTime(y1+1, mJan, 1, zone=startDate.timeZone)
        let dt4 = dateTime(y2, mJan, 1, zone=endDate.timeZone)
        let denominator1 =
          if y1.isLeapYear:  366.0
          else:  365.0
        let denominator2 =
          if y2.isLeapYear:  366.0
          else:  365.0
        return float64((dt3-startDate).inDays)/denominator1 + float64(y2-y1-1) + 
                 float64((endDate-dt4).inDays)/denominator2

    of dccActualActualAFB:  
      let dt3 = startDate + 1.years
      if endDate < dt3:
        return yearFraction(startDate, endDate, dccActual365L)
      else:
        let dt3 = endDate - (y2-y1).years
        return  float64(y2-y1) + yearFraction(startDate, dt3, dccActual365L)

    of dccBusinessDays252:
      doAssert: not calendar.isNil
      let bdayscount = calendar.bdays(startDate, endDate, dateInterval).len
      if bdayscount in {1,0}:  return 0.0
      else:  return  (bdayscount-1).float64 / 252.0

    of dccOneOne:
      return 1.0
