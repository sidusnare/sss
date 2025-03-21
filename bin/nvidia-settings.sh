#!/usr/bin/env bash

#SPDX-License-Identifier: GPL-3.0-only
N="$(which nvidia-settings)"
#Find the utility
if [ -z "${N}" ]; then
	for i in /bin /sbin /usr/bin /usr/local/bin /usr/local/sbin /usr/sbin;do
		if [ -x "${i}/nvidia-settings" ]; then
			N="${i}/nvidia-settings"
			break
		fi
		if [ ! -x "${i}" ]; then
			continue
		fi
	done
fi

#Sometimes it's in /opt/
if [ ! -x "${N}" ]; then
	while read -r file;do
		if [ -f "${file}" ];then
			if [ -x "${file}" ]; then
				N="${file}"
				break
			fi
		fi
	done < <( find /opt/ -xdev -maxdepth 4 -name nvidia-settings  );do
fi

if [ -z "${N}" ]; then
	echo "Unable to find nvidia-settings" >&2
	exit 1
fi

#Run sudo with passing the enviroment so the app can connect to the X server
exec sudo -E "${N}"
