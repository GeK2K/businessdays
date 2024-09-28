type
  GreatBritainCountries = enum
    gbEngland = "England"
    gbWales = "Wales"
    gbScotland = "Scotland"
    gbNorthenIreland = "Northen Ireland"


proc  isholidayGb(dt: DateTime, gbCountry: GreatBritainCountries): ?bool =
  ##[
  **Returns:**
    - `some(true)` if `dt` is a Bank holiday in `<gbCountry>`
    - `some(false)` if `dt` is not a Bank holiday in `<gbCountry>`
    - `none(bool)` if the system cannot answer the question

  **Bank holidays in United Kingdom of Great Britain:**
    - Official closings:
      - New Year's Day
      - Good Friday
      - Early May bank holiday
      - Spring bank holiday
      - Summer bank holiday
      - Christmas Day
      - Boxing Day
      - Easter Monday (except Scotland)
      - 2nd January (Scotland only)
      - St Patrick's Day (Northen Ireland only)
    - Special closings:
      - Bank holiday for the coronation of King Charles III, May 8, 2023
      - Bank Holiday for the State Funeral of Queen Elizabeth II, September 19, 2022
      - etc.

  **References:**
    - https://www.gov.uk/bank-holidays#england-and-wales
    - https://www.gov.uk/bank-holidays#scotland
    - https://www.gov.uk/bank-holidays#northern-ireland
  ]##

  # Official Closings
  # -----------------
  if dt.isholiday(hdayGBNewYearsDay):  return some(true)
  if dt.isholiday(hdayGoodFriday):  return some(true)
  if dt.isholiday(hdayGBEarlyMay):  return some(true)
  if dt.isholiday(hdayGBSpring):  return some(true)
  if dt.isholiday(hdayGBChristmasDay):  return some(true)
  if dt.isholiday(hdayGBBoxingDay):  return some(true)
  case gbCountry
    of gbEngland, gbWales:
      if dt.isholiday(hdayEasterMonday):  return some(true)
      if dt.isholiday(hdayGBEngNirWlsSummer):  return some(true)
    of gbScotland:
      if dt.isholiday(hdayGBSctJanuary2):  return some(true)
      if dt.isholiday(hdayGBSctSummer):  return some(true)
      if dt.isholiday(hdayGBSctStAndrewsDay):  return some(true)
    of gbNorthenIreland:
      if dt.isholiday(hdayGBNirStPatricksDay):  return some(true)
      if dt.isholiday(hdayEasterMonday):  return some(true)
      if dt.isholiday(hdayGBSctOrangemensDay):  return some(true)
      if dt.isholiday(hdayGBEngNirWlsSummer):  return some(true)

  # Special Closings
  # ----------------
  let yy = dt.year
  let mm = dt.month
  let dd = dt.monthday
  # Bank holiday for the coronation of King Charles III
  if yy == 2023 and mm == mMay and dd == 8:  return some(true)  
  # Bank Holiday for the State Funeral of Queen Elizabeth II
  if yy == 2022 and mm == mSep and dd == 19:  return some(true)
  # Platinum Jubilee bank holiday
  if yy == 2022 and mm == mJun and dd == 3:  return some(true)

  return some(false)


proc  isholidayEngland*(dt: DateTime): ?bool =
  ##[
  **Returns:**
    - `some(true)` if `dt` is a Bank holiday in England and Wales
    - `some(false)` if `dt` is not a Bank holiday in England and Wales
    - `none(bool)` if the system cannot answer the question

  **Bank holidays in United Kingdom of Great Britain:**
    - Official closings:
      - New Year's Day
      - Good Friday
      - Early May bank holiday
      - Spring bank holiday
      - Summer bank holiday
      - Christmas Day
      - Boxing Day
      - Easter Monday (except Scotland)
      - 2nd January (Scotland only)
      - St Patrick's Day (Northen Ireland only)
    - Special closings:
      - Bank holiday for the coronation of King Charles III, May 8, 2023
      - Bank Holiday for the State Funeral of Queen Elizabeth II, September 19, 2022
      - etc.

  **References:**
    - https://www.gov.uk/bank-holidays#england-and-wales
    - https://www.gov.uk/bank-holidays#scotland
    - https://www.gov.uk/bank-holidays#northern-ireland
  ]##
  result = dt.isholidayGb(gbEngland)


proc  isholidayScotland*(dt: DateTime): ?bool =
  ##[
  **Returns:**
    - `some(true)` if `dt` is a Bank holiday in Scotland
    - `some(false)` if `dt` is not a Bank holiday in Scotland
    - `none(bool)` if the system cannot answer the question

  **See also:**
    - `isholidayEngland <#isholidayEngland,DateTime>`_
  ]##
  result = dt.isholidayGb(gbScotland)


proc  isholidayNorthIreland*(dt: DateTime): ?bool =
  ##[
  **Returns:**
    - `some(true)` if `dt` is a Bank holiday in Northen Ireland
    - `some(false)` if `dt` is not a Bank holiday in Northen Ireland
    - `none(bool)` if the system cannot answer the question

  **See also:**
    - `isholidayEngland <#isholidayEngland,DateTime>`_
  ]##
  result = dt.isholidayGb(gbNorthenIreland)