#!/usr/bin/env python3

#SPDX-License-Identifier: GPL-3.0-only
#Read YAML data and write it well formatted to a file
# This isn't really a linter, it's just to read in anything that's technically valid and write it out in the uniform way python expects JSON to look.
#Fred Dinkler IV
#GPLv3

import yaml
import sys

for fn in sys.argv:
 if fn == sys.argv[0]:
  continue
 try:
  yf = open(fn)
 except:
  sys.exit("Unable to open " + fn)
  yf.close()
 try:
  yamldat=yaml.safe_load(yf.read())
 except:

  sys.exit("Unable to read valid yaml in: "  + fn + "\n" + str(sys.exc_info()[0]) + "\n\t" + str(sys.exc_info()[1]) )
  yf.close()

 yf.close()

 try:
  yaml.safe_dump(yamldat, open(fn,'w'), encoding='utf-8', allow_unicode=True )
 except:
  sys.exit("Unable to write " + fn)
