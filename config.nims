include ./config_nims_param
include ../config_nims_body


# command-line options
switch("define", "startYearEaster:1900")
switch("define", "endYearEaster:2200")


# this template is used below
template includeFile(aFile: static[string]) =
  include aFile

# begin Nimble config (version 2)
when withDir(thisDir(), system.fileExists("nimble.paths")):
  include "nimble.paths"
# end Nimble config