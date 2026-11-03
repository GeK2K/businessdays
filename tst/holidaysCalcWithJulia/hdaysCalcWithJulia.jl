using Dates
using BusinessDays


function write_holidays_to_file(cal::HolidayCalendar, filename::AbstractString, start_year::Int, end_year::Int)
  start_date = Date(start_year, 1, 1)
  end_date = Date(end_year, 12, 31)
  open(filename, "w") do io
    for d in start_date:Day(1):end_date
      if isholiday(cal, d) && dayofweek(d) <= 5
        println(io, Dates.format(d, dateformat"yyyy/mm/dd"))
      end
    end
  end
end

#= 
USGovernmentBond (Julia)  =  US Bond MArket (Nim)

2017:
----
  Julia: November 10th (Veteran's Day)
  Explanation: November 10th, 2017 is a Saturday, so Julia takes the Friday before
  This is not conform to rules; if this holiday is a Saturday, it is loss
  Realised holiday for 2017 can be seen here: https://www.sifma.org/resources/general/us-holiday-archive/
=#
write_holidays_to_file(BusinessDays.USGovernmentBond(), "hdaysCalcWithJulia.txt", 2017, 2100)