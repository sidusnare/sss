#!/bin/bash

if [ -z "${1}" ]; then
	child="${$}"
else
	if ! [ "${1}" -ge 0 ]; then
		echo "argv[1] must be a positive integer" >&2
		exit 1
	fi
	child="${1}"
fi
if [ ! -f "/proc/${1}/stat" ]; then
	echo "Unable to find process ${1}"
	exit 1
fi
until [ "${parent}" = 0 ];do
	if [ -n "${parent}" ];then
		echo
	fi
	parent="$( sed -e 's#\(^[0-9][0-9]* (\)\(.*\)\() [a-zA-Z] .*\)#\3#' < "/proc/${child}/stat" | cut -d ' ' -f 3 )"
	echo -ne "PID: ${child}"
	if [ -r "/proc/${child}/stat" ]; then
		echo -ne "\n\tStat name:\t"
		sed -e 's#\(^[0-9][0-9]* (\)\(.*\)\() [a-zA-Z] .*\)#\2#' < "/proc/${child}/stat"
	fi
	if [ -r "/proc/${child}/exe" ]; then
		echo -ne "\tExecutable:\t"
		readlink -f "/proc/${child}/exe"
	fi
	if [ -r "/proc/${child}/cmdline" ]; then
		echo -ne "\tCommand:\t"
		tr '\000' ' ' < "/proc/${child}/cmdline"
	fi
	child="${parent}"
done
echo
