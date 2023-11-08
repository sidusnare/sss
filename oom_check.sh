#!/bin/bash
#Fred Dinkler IV
#GPLv3

oom_count=$( dmesg | grep -c 'Out of memory:' )
echo "${oom_count}"
if [ "${oom_count}"  != '0' ]; then
	exit 1
else
	exit 0
fi
