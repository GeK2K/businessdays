##[
========
holidays
========
The `holidays` sub-module brings together the basic tools which allow 
the `businessdays` module to take charge of all of its public holidays.
]##

# =========================     Imports / Exports     ======================== #

import  std/[tables], questionable, nimutils/[nudates]
export  tables, questionable, nudates

# =============================     Includes     ============================= #

include  ./holidays/enum_and_lets
include  ./holidays/useful
include  ./holidays/target
include  ./holidays/us
include  ./holidays/gb
include  ./holidays/isholiday
include  ./holidays/isholiday_target
include  ./holidays/isholiday_us
include  ./holidays/isholiday_gb