#!/usr/bin/env python3

import re
import sys

try:
	jf = open(sys.argv[1])
except:
	sys.exit("Unable to open " + sys.argv[1])

jd=jf.read()
jd=re.sub(r'\\',r'\\\\',jd)
jd=re.sub(r'\n',r'\\n',jd)
jd=re.sub(r'\"',r'\\"',jd)
jd=re.sub(r'\'',r'\\\'',jd)
jd=re.sub(r'\!',r'\\!',jd)
jd=re.sub(r'\t',r'\\t',jd)
print(jd)
