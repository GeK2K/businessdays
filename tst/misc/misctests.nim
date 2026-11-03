import  std/[unittest]
import  nimutils/[nudates, nutimes]
import  businessdays, businessdays/calendars/holidays/private/easter_days


var calendar: bdCalendarId

suite "some basic tests":
  # no holiday or weekend
  calendar = bdCalendarId.klndrNoHolidayOrWeekend
  test $calendar:
    check:  calendar.holidays(2023).len == 0
    check:  calendar.holidays(2024).len == 0
    check:  calendar.bdays(dateTime(2023, mJan, 1), dateTime(2023, mDec, 31)).len == 365
    check:  calendar.bdays(dateTime(2024, mJan, 1), dateTime(2024, mDec, 31)).len == 366

  # weekend only
  calendar = bdCalendarId.klndrWeekendsOnlyInTheWest
  test $calendar:
    check:  calendar.holidays(2023).len == 0
    check:  calendar.holidays(2024).len == 0
    check:  calendar.bdays(dateTime(2023, mJan, 1), dateTime(2023, mDec, 31)).len == 260
    check:  calendar.bdays(dateTime(2024, mJan, 1), dateTime(2024, mDec, 31)).len == 262
