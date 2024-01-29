##[
============
nuexceptions
============
Some useful tools related to exception handling 
(the suffix `nu` stands for `Nim utils`).
]##


# =======================     MethodWoImplemDefect     ======================= #

type
  MethodWoImplemDefect* = object of Defect
    ## This exception is intended to be raised if a base 
    ## method is called when no implementation exists.


func  newMethodWoImplemDefect*(msg = "Method without implementation override."):
                              ref MethodWoImplemDefect =
  ## A constructor for objects of type `MethodWoImplemDefect`.
  newException(MethodWoImplemDefect, msg)