##[
========
holidays
========
The `holidays` sub-module brings together the basic tools which allow 
the `businessdays` module to take charge of all of its public holidays.


`questionable` module
---------------------

To shorten certain parts of the code we have often favored the syntax of 
the `questionable <https://github.com/codex-storage/questionable>`_ module 
over the syntax of the `options <https://nim-lang.org/docs/options.html>`_ 
module. Most basic examples:
  - `?T` instead of `Option[T]`
  - `!x` instead of `get(x)`


`nudates` module
----------------

We systematically used the comparison operators of the 
`nudates <https://gek2k.github.io/nudates/nudates.html>`_ 
module. For example `~==` for equality test, `!~==` 
for inequality test, and so on.
]##


# =========================     Imports / Exports     ======================== #

import  std/[tables], questionable, nudates, easter
export  tables, questionable, nudates, easter


# =============================     Includes     ============================= #

include  holidays_core_first
include  holidays_core_us
include  holidays_core_final
include  holidays_us
include  holidays_target
