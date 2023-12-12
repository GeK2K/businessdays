##[
=========
calendars
=========
The `calendars` module contains routines and types for dealing with calendars
(holidays, week-ends, businessdays, arithmetic with business days, etc.).
]##


# =========================     Imports / Exports     ======================== #

import  std/[algorithm, sequtils, strformat]
import  ./private/[commonmath, nudates, nuexceptions]
import  holidays
export  commonmath, holidays, nudates


# =============================     Includes     ============================= #

include  calendars_abstract_class
include  calendars_default_implem
