#!/usr/bin/python

#Read JSON data and write it well formatted to a file
#Fred Dinkler IV
#GPLv3


import json
import sys

for fn in sys.argv:
 if fn == sys.argv[0]:
  continue
 try:
  jf = open(fn)
 except:
  sys.exit("Unable to open " + fn)
  jf.close()
 try:
  jsondat=json.dumps(json.loads(jf.read()), sort_keys=True, indent=4)
 except:

  sys.exit("Unable to read valid json in: "  + fn + "\n" + str(sys.exc_info()[0]) + "\n\t" + str(sys.exc_info()[1]) )
  jf.close()

 jf.close()

 try:
  jw = open(fn,"w")
 except:
  sys.exit("Unable to open for writing " + fn)
  jw.close()

 try:
  jw.writelines(jsondat + "\n" )
 except:
  sys.exit("Unable to write to " + fn)
  jw.close()

 jw.close()


