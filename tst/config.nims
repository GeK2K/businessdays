import  std/[os, strformat, strutils]


const
  srcDir = "./src"
  binDir = "./bin"
  projDir = projectDir()
  docRootPath = projDir.joinPath(srcDir)


task  test, "Run all tests":
  echo "**************\n*  STARTING  *\n**************\n\n"
  for subDir in walkDirRec(dir = tstDir, yieldFilter = {pcDir}, 
                           followFilter = {pcDir}, relative = false, 
                           checkDir = true):
    for f in listFiles(dir = subDir):
      let (dir, name, ext) = splitFile(f)
      if ext.toLowerAscii == ".nim"  and  name.toLowerAscii.endsWith("tests"):
        exec fmt"""nim  c  -r  --outdir:{binDir}  {f}"""
  echo "\n\n*********\n*  END  *\n*********\n\n"