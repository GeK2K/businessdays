import  std/[os, strformat, strutils]


# script parameters
# =================
const
  srcDir = "./src"
  binDir = "./bin"
  htmldocsDir = "./doc/htmldocs"
  projDir = projectDir()
  docRootPath = projDir.joinPath(srcDir)


# disabling some warnings
# =======================
# A dot-like operator is an operator starting with '.' but not with '..'.
# Since Nim v2.0, dot-like operator have the same precedence as '.',
# and we get a warning every time we use a dot-like operator (e.g. '.?' 
# of the 'questionable' module).
# https://nim-lang.org/docs/manual.html#syntax-dotminuslike-operators
# https://nim-lang.org/blog/2021/10/19/version-160-released.html  
# (section "Dot-like operators")
# We have decided to disable this warning.
if (NimMajor, NimMinor) >= (1, 6):
  switch("warning", "DotLikeOps:off")


# tasks
# =====
let mainfile = "src/businessdays.nim"


task  runNimDoc, "":
  echo "**************\n*  STARTING  *\n**************\n\n"
  exec fmt"""nim  doc --project  --index:off  --outdir:{htmldocsDir}  {mainfile}"""
  echo "\n\n*********\n*  END  *\n*********\n\n"


proc  execTask(compileOption = "") =
  echo "**************\n*  STARTING  *\n**************\n\n"
  exec fmt"""nim  c  {compileOption}  --mm:orc  --path:{srcDir}  --outdir:{binDir}  {mainfile}"""
  echo "\n\n*********\n*  END  *\n*********\n\n"

 
task  compileApp, "compiles the application":
  execTask()

task  releaseApp, "releases the application":
  execTask "-d:release"

task  compileDangerApp, "compiles the application by disabling the controls":
  execTask "-d:danger"

task  buildApp, "builds the application":
  execTask "-d:release"
  runNimDocTask()
