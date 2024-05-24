##[
=========
calendars
=========
The `calendars` module contains routines and types for dealing with calendars
(holidays, week-ends, businessdays, arithmetic with business days, etc.).
]##


# =========================     Imports / Exports     ======================== #

import  std/[algorithm, sequtils, strformat]
import  ./private/[nuexceptions, numath]
import  holidays
export  holidays, numath

# =============================     Includes     ============================= #

include  calendars_abstract_class
include  calendars_default_implem
