proc  isholidayUSNYSE*(dt: DateTime): ?bool =
  ##[
  **Returns:**
    - `none(bool)` if the system cannot answer the question 
      (typically when `dt.year < 1960`)
    - `some(true)` if `dt` is a holiday on the New York Stock Exchange (NYSE)
    - `some(false)` if `dt` is not a holiday on the New York Stock Exchange (NYSE)

  **Business days and holidays:**

    On the New York Stock Exchange (NYSE) *all days are operating days except*:
    - Saturdays and Sundays (weekends)
    - Holidays that are moved to Monday if it is Sunday:
      - New Year's Day, January 1st
    - Holidays that are moved to Monday if it is Sunday, or to Friday if it is Saturday:
      - Independence Day, July 4th
      - Christmas Day, December 25th
      - Juneteenth National Independence Day, June 19th, since 2023
    - Other holidays:
      - Martin Luther King's birthday, third Monday in January, since 1998
      - Washington's Birthday, 3rd Monday in February, since 1971
      - Good Friday
      - Memorial Day, last Monday in May, since 1971	  
      - Labor Day, 1st Monday in September, since 1887
      - Thanksgiving Day, 4th Thursday in November
    - Special closings:
      - President George H.W. Bush's funeral, December 5, 2018
      - Hurricane Sandy, October 29-30, 2012
      - etc.

  **References:**
    - https://s3.amazonaws.com/armstrongeconomics-wp/2013/07/NYSE-Closings.pdf
    - https://www.nyse.com/markets/hours-calendars
    - https://www.sifma.org/resources/general/holiday-schedule/
  ]##

  if dt.year < 1960:  return none(bool)

  # Official Closings
  # -----------------
  if dt.isholiday(hdayUSNYSENewYearsDay):  return some(true)
  if dt.isholiday(hdayUSMartinLutherKingBirthday) and dt.year > 1997:  return some(true)
  if dt.isholiday(hdayUSWashingtonBirthday) and dt.year > 1970:  return some(true)
  if dt.isholiday(hdayGoodFriday) and dt.year notin [1898, 1906, 1907]:  return some(true)
  if dt.isholiday(hdayUSMemorialDay) and dt.year > 1970:  return some(true)
  if dt.isholiday(hdayUSIndependenceDay):  return some(true)
  if dt.isholiday(hdayUSLaborDay) and dt.year > 1887:  return some(true)
  if dt.isholiday(hdayUSThanksgivingDay):  return some(true)
  if dt.isholiday(hdayUSChristmasDay):  return some(true)
  if dt.isholiday(hdayUSJuneteenthIndependenceDay) and dt.year > 2022:  return some(true)

  # Special Closings
  # ----------------
  let yy = dt.year
  let mm = dt.month
  let dd = dt.monthday
  let dayOfWeek = getDayOfWeek(dt)
  # President George H.W. Bush's funeral
  # <https://www.newyorkfed.org/markets/opolicy/operating_policy_181204>
  if yy == 2018 and mm == mDec and dd == 5:  return some(true)
  # Hurricane Sandy
  if yy == 2012 and mm == mOct and (dd == 29 or dd == 30):  return some(true)
  # Predient Ford's funeral
  if yy == 2007 and mm == mJan and dd == 2:  return some(true)
  # President Reagan's funeral
  if yy == 2004 and mm == mJun and dd == 11:  return some(true)
  # Sep 11th, 2001
  if yy == 2001 and mm == mSep and (11 <= dd and dd <= 14):  return some(true)
  # President Nixon's funeral
  if yy == 1994 and mm == mApr and dd == 27:  return some(true)
  # Hurricane Gloria
  if yy == 1985 and mm == mSep and dd == 27:  return some(true)  
  # Election Day
  if dt.isholiday(hdayUSNYSEElectionDay) and (yy <= 1968 or yy in [1972, 1976, 1980]):
    return some(true)
  # 1977 Blackout
  if yy == 1977 and mm == mJul and dd == 14:  return some(true)
  # Funeral of former President Lyndon B. Johnson
  if yy == 1973 and mm == mJan and dd == 25:  return some(true)
  # Funeral of former President Harry S. Truman
  if yy == 1972 and mm == mDec and dd == 28:  return some(true)
  # National Day of Participation for the lunar exploration
  if yy == 1969 and mm == mJul and dd == 21:  return some(true)
  # Eisenhower's funeral
  if yy == 1969 and mm == mMar and dd == 31:  return some(true)
  # Heavy snow
  if yy == 1969 and mm == mFeb and dd == 10:  return some(true)
  # Day after Independence Day
  if yy == 1968 and mm == mJul and dd == 5:  return some(true)
  # Paperwork Crisis
  if yy == 1968 and dayOfWeek == dWed and 
      (month: mJun, monthday: 12) <= (month: mm, monthday: dd):  
    return some(true)
  # Mourning for Martin Luther King Jr
  if yy == 1968 and mm == mApr and dd == 9:  return some(true)
  # Christmas Eve
  if mm == mDec and dd == 24 and yy in [1965, 1956, 1954, 1945, 1900]: 
    return some(true)
  # President Kennedy's funeral
  if yy == 1963 and mm == mNov and dd == 25:  return some(true)
  # Day before Decoration Day
  if yy == 1961 and mm == mMay and dd == 29:  return some(true)
  # Day after Christmas
  if yy == 1958 and mm == mDec and dd == 26:  return some(true)
  # Lincoln's Birthday
  if 1896 <= yy and yy <= 1953 and mm == mFeb and dd == 12:  return some(true)
  # Columbus Day
  if 1909 <= yy and yy <= 1953 and mm == mOct and dd == 12:  return some(true)
  # Veteran's Day
  if dd == 11 and mm == mNov and 
       (yy == 1918 or yy == 1921 or (1934 <= yy and yy <= 1953)):  return some(true)
  # V-J Day. End of World War II.
  if yy == 1945 and mm == mAug and (dd == 15 or dd == 16):  return some(true)
  # National banking holiday.
  if yy == 1933 and mm == mMar and 6 <= dd and dd <= 14:  return some(true)  
  # Parade for Colonel Charles A. Lindbergh.
  if yy == 1927 and mm == mJun and dd == 13:  return some(true)
  # Funeral of President Warren G. Harding at Marion, Ohio.
  # Death of President Warren G. Harding.
  if yy == 1923 and mm == mAug and (dd == 10 or dd == 3):  return some(true)
  # Return of General John J. Pershing.
  if yy == 1919 and mm == mSep and dd == 10:  return some(true)
  # Parade of 77th Division.
  if yy == 1919 and mm == mMay and dd == 6:  return some(true)
  # Homecoming of 27th Division.
  if yy == 1919 and mm == mMar and dd == 25:  return some(true)
  # Armistice signed.
  if yy == 1918 and mm == mNov and dd == 11:  return some(true)
  # Draft registration day.
  if yy == 1918 and mm == mSep and dd == 12:  return some(true)
  if yy == 1917 and mm == mJun and dd == 5:  return some(true)
  # Heatless day.
  if yy == 1918:
    if mm == mJan and dd == 28:  return some(true)
    if mm == mFeb and (dd == 4 or dd == 11):  return some(true)
  # World War I
  # it is not easy to determine the exact days of closure, partial or total
  if yy == 1914 or yy == 1915:  return none(bool)
  # Opening of new NYSE building.
  if yy == 1903 and mm == mApr and dd == 22:  return some(true)
  # Funeral of President William McKinley.
  if yy == 1901 and mm == mSep and dd == 19:  return some(true)
  # Days after Independence Day.
  if yy == 1901 and mm == mJul and dd == 5:  return some(true)
  # Admiral Dewey Celebration.
  if yy == 1899 and mm == mSep and dd == 29:  return some(true)
  # Monday before Independence Day.
  if yy == 1899 and mm == mJul and dd == 3:  return some(true)
  # Monday before Decoration Day.
  if yy == 1899 and mm == mMay and dd == 29:  return some(true)
  # Charter Day.
  if yy == 1898 and mm == mMay and dd == 4:  return some(true)
  # Grant's birthday.
  if yy == 1897 and mm == mApr and dd == 27:  return some(true)
  # Columbian Celebration.
  if yy == 1892 and mm == mOct and dd in [12,21]:  return some(true)
  if yy == 1893 and mm == mApr and dd == 27:  return some(true)
  # Centennial celebration of Washington's inauguration.
  if yy == 1889:
    if mm == mApr and (dd == 30 or dd == 30):  return some(true)
    if mm == mMay and dd == 1:  return some(true)
  # 1888
  if yy == 1888: 
    # Friday after Thanksgiving Day.
    if mm == mNov and dd == 30:  return some(true)
    # Blizzard of 1888.
    if mm == mMar and (dd == 12 or dd == 13):  return some(true)

  return some(false)


proc  isholidayUSFedGovtOrUSBondMrkt(dt: DateTime, USFedGovtCalendar: bool): ?bool =
  ## 'U.S. Federal Govt' and 'U.S. Bond Market' have:
  ##   - 9 common holidays
  ##   - 2 common holidays that can be observed differently  
  ##     (New Year's Day, Juneteenth Independance Day)
  ##   - 2 separate holidays  (Inauguration Day and Good Friday)
  if dt.isholiday(hdayUSMartinLutherKingBirthday) and dt.year > 1983:  return some(true)
  if dt.isholiday(hdayUSWashingtonBirthday) and dt.year > 1879:  return some(true)
  if dt.isholiday(hdayUSMemorialDay) and dt.year > 1968:  return some(true)
  if dt.isholiday(hdayUSIndependenceDay) and dt.year > 1870:  return some(true)
  if dt.isholiday(hdayUSLaborDay) and dt.year > 1894:  return some(true)
  if dt.isholiday(hdayUSColumbusDay) and dt.year > 1968:  return some(true)
  if dt.isholiday(hdayUSVeteransDay) and dt.year > 1938:  return some(true)
  if dt.isholiday(hdayUSThanksgivingDay) and dt.year > 1941:  return some(true)
  if dt.isholiday(hdayUSChristmasDay) and dt.year > 1870:  return some(true)
  if USFedGovtCalendar:
    if dt.isholiday(hdayUSNewYearsDay) and dt.year > 1870:  return some(true)
    if dt.isholiday(hdayUSInaugurationDay):  return some(true)
    if dt.isholiday(hdayUSJuneteenthIndependenceDay) and dt.year > 2020:  return some(true)
  else:
    if dt.isholiday(hdayUSNYSENewYearsDay) and dt.year > 1870:  return some(true)
    if dt.isholiday(hdayGoodFriday) and dt.year > 1886:  return some(true)
    if dt.isholiday(hdayUSJuneteenthIndependenceDay) and dt.year > 2021:  return some(true)
  return some(false)


proc  isholidayUSFederalGovt*(dt: DateTime): ?bool =
  ##[
  **Returns:**
    - `some(true)` if `dt` is a holiday in the U.S. Federal Government calendar
    - `some(false)` if `dt` is not a holiday in the U.S. Federal Government calendar
    - `none(bool)` if the system cannot answer the question

  **Business days and holidays:**

    In the U.S. Federal Government calendars *all days are operating days except*:
    - Saturdays and Sundays (weekends)
    - Holidays that are moved to Monday if it is Sunday, or to Friday if it is Saturday:
      - New Year's Day, January 1st, since 1871
      - Christmas Day, December 25th, since 1871
      - Independence Day, July 4th, since 1871
      - Veterans' Day, November 11th, since 1939 
      - Juneteenth National Independence Day, June 19th, since 2021
    - Holidays that are moved to Monday if it is Sunday:
      - Inauguration Day, since 1789
    - Other holidays:
      - Washington's Birthday, 3rd Monday in February, since 1880 
      - Labor Day, 1st Monday in September, since 1895
      - Thanksgiving Day, 4th Thursday in November, since 1942
      - Memorial Day, last Monday in May, since 1969
      - Columbus Day, 2nd Monday in October, since 1969
      - Martin Luther King's birthday, third Monday in January, since 1983

  **References:**
    - https://en.wikipedia.org/wiki/Federal_holidays_in_the_United_States#List_of_federal_holidays
    - https://en.wikipedia.org/wiki/United_States_presidential_inauguration

  **Notes:**

    The results provided by this procedure have been *successfully compared* 
    to the 209 holidays of the years 2011 to 2030. These holidays can be 
    viewed here:
    - https://www.opm.gov/policy-data-oversight/pay-leave/federal-holidays/#url=Historical-Data
  ]##
  runnableExamples:
    doAssert:  !isholidayUSFederalGovt(dateTime(1993, mJan, 20)) # Inauguration Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2010, mDec, 31)) # New Year's Day 
    doAssert:  !isholidayUSFederalGovt(dateTime(2012, mJan, 2)) # New Year's Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2013, mJan, 21)) # Martin Luther King
    doAssert:  !isholidayUSFederalGovt(dateTime(2014, mFeb, 17)) # Washington’s Birthday
    doAssert:  !isholidayUSFederalGovt(dateTime(2015, mMay, 25)) # Memorial Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2015, mJul, 3)) # Independence Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2016, mSep, 5)) # Labor Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2017, mOct, 9)) # Columbus Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2018, mNov, 12)) # Veterans Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2019, mNov, 28)) # Thanksgiving Day
    doAssert:  !isholidayUSFederalGovt(dateTime(2021, mDec, 24)) # Christmas Day
  result = isholidayUSFedGovtOrUSBondMrkt(dt, USFedGovtCalendar = true)


proc  isholidayUSBondMrkt*(dt: DateTime): ?bool =
  ##[
  **Returns:**
    - `some(true)` if `dt` is a holiday in the U.S. Bond Market
    - `some(false)` if `dt` is not a holiday in the U.S. Bond Market
    - `none(bool)` if the system cannot answer the question

  **Holidays:**

    In the U.S. Bond Market, holidays are those of the 
    U.S. Federal Government, with the exception of:
      - Inauguration Day (not observed on U.S. Bond Market)
      - Good Friday (not observed by the U.S. Federal Government)
      - New Year's Day
        - similarly observed when January 1 is not a Saturday
        - observed on Friday December 31 by the U.S. Federal Government 
          while January 1 is a Saturday (not observed by the U.S. Bond 
          Market in this case) 
      - Juneteenth National Independence Day
        - observed since 2022 in the U.S. Bond Market
        - observed since 2021 for the U.S. Federal Government  
      - Special Closings (may differ)

  **See also:**
    - `isholidayUSFederalGovt <#isholidayUSFederalGovt,DateTime>`_
  ]##
  
  # Official Closings
  # -----------------
  if isholiday =? isholidayUSFedGovtOrUSBondMrkt(dt, USFedGovtCalendar = false) and isholiday:  return some(true)
  
  # Special Closings
  # ----------------

  # President George H.W. Bush's funeral
  # <https://www.newyorkfed.org/markets/opolicy/operating_policy_181204>
  if dt ==~ dateTime(2018, mDec, 5.MonthdayRange):  return some(true)

  return some(false)