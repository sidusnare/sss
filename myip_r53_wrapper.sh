#!/bin/bash
#
#This is the wrapper for updating my IP information, I run it every minute, so there are a lot of limit checks and throttles in here. It bails out if it's still runnning, or if ip info hasn't changed (except for the first of each hour)

now="$( date +%s )"
min="$(date +%M)"
if [ -e '/tmp/.myip_r53.lock' ]; then
	pid="$(head -n 1 '/tmp/.myip_r53.lock')"
	then="$(tail -n 1 '/tmp/.myip_r53.lock')"
	if grep myip_r53.sh "/proc/${pid}/cmdline" &>> /dev/null; then
		if [ $(( now - then )) -gt 600 ]; then
			echo "Cleaning up ${pid}, started $(( now - then )) seconds ago"
			kill -9 "${pid}"
			rm '/tmp/.myip_r53.lock'
			exit 1
		fi
	fi
fi

#seed empty ip information if no old information exists
if [ ! -e '/tmp/.myip_r53_wrapper.log' ]; then
	touch '/tmp/.myip_r53_wrapper.log'
	chmod 0600 '/tmp/.myip_r53_wrapper.log'
fi

ipo="$(< '/tmp/.myip_r53_wrapper.log' )"
ipi="$( ip addr | grep -v 'sec$' )"

#Run hourly if no changes are detected
if [ "${ipo}" == "${ipi}" ]; then
	if  [ "${min}" != '0' ];then
		exit 0
	fi
fi

echo -e "${ipi}" > '/tmp/.myip_r53_wrapper.log'

#log to a file if we're not wearing out the SSDs, otherwise dump it to null
if grep 'tmpfs /tmp tmpfs' /proc/mounts &> /dev/null; then
	/usr/local/sbin/myip_r53.sh &> /tmp/myip_r53.log
else
	/usr/local/sbin/myip_r53.sh &>> /dev/null
fi
