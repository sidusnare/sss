#!/usr/bin/env python
import sys
file = open('/root/dns/hostname.26036', 'r')
inchar = '   '
for fn in sys.argv:
    if fn == sys.argv[0]:
        continue
    try:
        file = open(fn, 'r')
    except:
        sys.stderr.write("Unable to open " + fn)
        continue
    inden = 0

    while 1:
        char = file.read(1)         

        if not char:
            break

        if char == '{' or char == '[' or char == '(':
            inden = inden + 1

        if char == '}' or char == ']' or char == ')':
            inden = inden - 1

        if inden < 0:
            inden = 0

        if "\n" in char:
            inden = 0

        if char == ',' or char == '{' or char == '['  or char == '(':
            print(char)
            for x in range(inden):
                sys.stdout.write(inchar)
        elif char == '}' or char == ']' or char == ')':
            print('')
            for x in range(inden):
                sys.stdout.write(inchar)
            sys.stdout.write(char)
        else:
            sys.stdout.write(char)
    file.close()


