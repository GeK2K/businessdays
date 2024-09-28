# ===============================     Enum     =============================== #

type
  bdHoliday* = enum
    ##[ 
    Holidays natively supported by the system. 

    **Notes:**

    For each `hdayXXXX` element there exists a `holidayXXXX` `proc` which
    contains interesting information about the holiday concerned. For example, 
    to the `hdayBoxingDay` element corresponds the `holidayBoxingDay` `proc`;
    to the `hdayUSMemorialDay` element corresponds the `holidayUSMemorialDay` 
    `proc`; and so on.
    ]##
    # Easter and Co (common to several calendars)
    hdayGoodFriday, hdayEasterSunday, hdayEasterMonday, 
    hdayAscension, hdayWhitMonday, hdayWhitSunday,
    # public holidays in the TARGET calendar
    hdayTargetNewYearsDay, hdayTargetLabourDay, hdayTargetChristmasDay, 
    hdayTargetBoxingDay, hdayTargetDecember31,
    # public holidays in U.S.A. (US)
    hdayUSNewYearsDay, hdayUSNYSENewYearsDay, hdayUSMartinLutherKingBirthday,
    hdayUSWashingtonBirthday, hdayUSMemorialDay, hdayUSJuneteenthIndependenceDay,
    hdayUSIndependenceDay, hdayUSLaborDay,  hdayUSColumbusDay, 
    hdayUSNYSEElectionDay, hdayUSThanksgivingDay, hdayUSVeteransDay,
    hdayUSChristmasDay, hdayUSInaugurationDay,
    # public holidays in GB (United Kingdom of Great Britain and Northern Ireland)
    # GB = England (GB-ENG) + Wales (GB-WLS) + Scotland (GB-SCT) + Northern Ireland (GB-NIR)
    hdayGBNewYearsDay, hdayGBSctJanuary2, hdayGBNirStPatricksDay, 
    hdayGBEarlyMay, hdayGBSpring, hdayGBSctOrangemensDay,
    hdayGBEngNirWlsSummer, hdayGBSctSummer, hdayGBSctStAndrewsDay,
    hdayGBChristmasDay, hdayGBBoxingDay,


# ===============================     Lets     =============================== #

let 
  NewYearsDay* = newMonthMonthday(mJan, 1)
  StPatricksDay* = newMonthMonthday(mMar, 17)
  LabourDay* = newMonthMonthday(mMay, 1)
  USJuneteenthIndependenceDay* = newMonthMonthday(mJun, 19)
  USIndependenceDay* = newMonthMonthday(mJul, 4) 
  OrangemensDay* = newMonthMonthday(mJul, 12) 
  USVeteransDay* = newMonthMonthday(mNov, 11)
  StAndrewsDay* = newMonthMonthday(mNov, 30)
  ChristmasDay* = newMonthMonthday(mDec, 25)
  BoxingDay* = newMonthMonthday(mDec, 26)
  December31* = newMonthMonthday(mDec, 31)