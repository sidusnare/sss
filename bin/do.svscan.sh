#!/usr/bin/env bash
export PARENT="svscan $$"

servicedir=$( readlink -f "${HOME}/usr/local/service" )
export PATH="$(mypaths.sh)"
if [ -e "${servicedir}" ] && command -v svscan >> /dev/null 2>> /dev/null; then
	for spid in $( pidof svscan );do
		if [ -O "/proc/${spid}/cmdline" ] && [ "${servicedir}" == "$( cut -d '' -f 2 < "/proc/${spid}/cmdline" )" ]; then
			echo "We're already running svscan, bailing out"
			exit 1
		fi
	done
	if [ -e "${HOME}/usr/local/var/run/svscan.pid" ]; then
		OPID=$(< "${HOME}/usr/local/var/run/svscan.pid" )
		if [ -e "/proc/${OPID}" ];then
			OEXE=$( readlink -f "/proc/${OPID}/exe" )
			if [ "${OEXE}" == "$(command -v svscan )" ]; then
				echo "Already running ${OEXE} at ${OPID}, exiting" >&2
				exit 1
			fi
		fi
	fi
	sleep 1s
	cd /proc/ || exit 1
	for proc in [0-9]*;do
		if [ -O "${proc}" ];then
			running=$(readlink -f "/proc/${proc}/exe" ) 
			rcwd=$(readlink -f "/proc/${proc}/cwd" ) 
			sarg="$( cut -d '' -f 2 < "/proc/${proc}/cmdline" )"
			if [ "${running}" == "$(command -v svscan)" ] && [ "${sarg}" == "$servicedir" ] ;then
				echo "Found an errant svscan at ${proc}, killing it." >> "$HOME"/usr/local/var/log/svscan.log
				kill "${proc}"  &>> "$HOME"/usr/local/var/log/svscan.log
				killall -u fred4 -v supervise multilog &>> "$HOME"/usr/local/var/log/svscan.log
			fi
		fi
	done
	cd "${servicedir}"
	svscan "${servicedir}" &>> "${HOME}/usr/local/var/log/svscan.log"  &
	echo $! > "${HOME}/usr/local/var/run/svscan.pid"
fi
unset SCRIPT
exit 0
