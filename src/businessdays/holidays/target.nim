# New Year’s Day (January 1st) in the TARGET calendar
defineProcHolidayXXXFromMmdParam(NewYearsDay, holidayTargetNewYearsDay):
  runnableExamples:
    # The 'New Year’s Day (January 1st)' in the TARGET calendar
    # can be obtained in two different but equivalent ways.
    doAssert:  !holidayTargetNewYearsDay(2020) ==~ dateTime(2020, mJan, 1)
    doAssert:  !holiday(2020, hdayTargetNewYearsDay) ==~ dateTime(2020, mJan, 1)


# Labour Day (May 1st) in the TARGET calendar
defineProcHolidayXXXFromMmdParam(LabourDay, holidayTargetLabourDay):
  runnableExamples:
    # The 'Labour Day (May 1st)' in the TARGET calendar
    # can be obtained in two different but equivalent ways.
    doAssert:  !holidayTargetLabourDay(2020) ==~ dateTime(2020, mMay, 1)
    doAssert:  !holiday(2020, hdayTargetLabourDay) ==~ dateTime(2020, mMay, 1)


# Christmas Day (December 25) in the TARGET calendar
defineProcHolidayXXXFromMmdParam(ChristmasDay, holidayTargetChristmasDay):
  runnableExamples:
    # The 'Christmas Day (December 25)' in the TARGET calendar
    # can be obtained in two different but equivalent ways.
    doAssert:  !holidayTargetChristmasDay(2020) ==~ dateTime(2020, mDec, 25)
    doAssert:  !holiday(2020, hdayTargetChristmasDay) ==~ dateTime(2020, mDec, 25)


# Boxing Day (December 26) in the TARGET calendar
defineProcHolidayXXXFromMmdParam(BoxingDay, holidayTargetBoxingDay):
  runnableExamples:
    # The 'Boxing Day (December 26)' in the TARGET calendar
    # can be obtained in two different but equivalent ways.
    doAssert:  !holidayTargetBoxingDay(2020) ==~ dateTime(2020, mDec, 26)
    doAssert:  !holiday(2020, hdayTargetBoxingDay) ==~ dateTime(2020, mDec, 26)


# December 31 in the TARGET calendar
defineProcHolidayXXXFromMmdParam(December31, holidayTargetDecember31):
  runnableExamples:
    # The 'December 31st' in the TARGET calendar can
    # be obtained in two different but equivalent ways.
    doAssert:  !holidayTargetDecember31(2020) ==~ dateTime(2020, mDec, 31)
    doAssert:  !holiday(2020, hdayTargetDecember31) ==~ dateTime(2020, mDec, 31)
