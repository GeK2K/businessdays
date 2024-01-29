import  std/[os, strformat, strutils]

  
switch("path", "../src")  # source directory of the project 
                          # for which the tests are written


task  runTests, "Run all tests":
  echo "**************\n*  STARTING  *\n**************\n\n"
  for subDir in walkDirRec(dir = ".", yieldFilter = {pcDir}, 
                           followFilter = {pcDir}, relative = false, 
                           checkDir = true):
    for f in listFiles(dir = subDir):
      let (dir, name, ext) = splitFile(f)
      if ext.toLowerAscii == ".nim"  and  name.toLowerAscii.endsWith("tests"):
        withDir(dir):
          exec fmt"""nim  c  -d:release  -r  {name.addFileExt(ext)}"""
  echo "\n\n*********\n*  END  *\n*********\n\n"