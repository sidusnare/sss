#!/bin/bash

sort -u group_list | awk -F : '{system("groupadd -g " $3 " " $1)}' group_list
for i in $(< users_list );do
	if [ "${i}" == root ] || id "${i}" &>> /dev/null; then
		continue
	fi

	unset udir uhash uuid ugid ushell ugs
	ua=( 'useradd' )
	udir="$( awk -F : '{print($6)}' "${i}.passwd" )"
	if [ -z "${udir}" ]; then
		udir="/home/${i}"
	fi
	if [ ! -z "${udir}" ]; then
		ua+=( "-d" "${udir}" )
	fi
	
	uhash="$( awk -F : '{print($2)}' "${i}.shadow" )"
	if [ -z "${uhash}" ] || [ 'xx' == "${uhash}" ]; then
		uhash="$( awk -F : '{print($2)}' "${i}.passwd" )"
	fi
	if [ '!!' != "${uhash}" ]; then
		ua+=( "-p" "${uhash}" )
	fi
	
	uuid="$( awk -F : '{print($3)}' "${i}.passwd")"
	if [ -z "${uuid}" ]; then
		 uuid="$(< "${i}.id" )"
	fi
	if [ ! -z "${uuid}" ];then
		ua+=( '-u' "${uuid}" )
	fi
	
	ugid="$( awk -F : '{print($4)}' "${i}.passwd")"
	if [ -z "${ugid}" ]; then
		 ugid="$(< "${i}.group" )"
	fi
	if [ ! -z "${ugid}" ];then
		ua+=( '-g' "${ugid}" )
	fi
	
	ushell="$( awk -F : '{print($7)}' "${i}.passwd")"
	if [ -z "${ushell}" ] || [ ! -x "${ushell}"  ]; then
		ushell="/bin/bash"
	fi
	ua+=( '-s' "${ushell}" )
	
	if [ -e "${i}.groups" ]; then
		ugs="$( tr ' ' ',' < "${i}.groups" )"
	fi
	if [ ! -z "${ugs}" ]; then
		ua+=( '-G' "${ugs}")
	fi
	ua+=( "${i}" )
	"${ua[@]}" || echo "${i}" >> error.log
	if [ ! -e "${udir}/.ssh/authorized_keys" ]; then
		if [ ! -e "${udir}/.ssh" ]; then
			mkdir -p "${udir}/.ssh"
		fi
		cat "${i}.authorized_keys" > "${udir}/.ssh/authorized_keys"
	fi
	
	
done
