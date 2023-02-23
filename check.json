#!/usr/bin/python

#Read JSON data and write it well formatted to a file
#Fred Dinkler IV

import json
import sys

for fn in sys.argv:
  if fn == sys.argv[0]:
    continue
  try:
    jf = open(fn)
  except:
    jf.close()
    sys.exit("Unable to open " + fn)
  try:
    jsondat=json.dumps(json.loads(jf.read()), sort_keys=True, indent=4)
  except:
    jf.close()
    sys.exit("Unable to read valid json in: "  + fn + "\n" + str(sys.exc_info()[0]) + "\n\t" + str(sys.exc_info()[1]) + "\n" )

  jf.close()
  sys.stderr.write("File read without critical error: " + fn + "\n" )
  sys.exit(0)
