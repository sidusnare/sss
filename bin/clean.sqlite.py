#!/usr/bin/env bash

#SPDX-License-Identifier: GPL-3.0-only
EXTS=( 'journal' 'wal' 'shm' 'rebuild' )
if file "${1}" | grep ': SQLite'; then
	BAK="$( tmpfile clean.sqlite )"
	DUMP="$( dirname "${1}" )/$( basename "${1}" .db ).raw.sql"
	echo "Working on ${1}, backup in ${BAK}" >> "${BAK}.log"
	echo "Working on ${1}, backup in ${BAK}, dump in ${DUMP}"
	cp "${1}" "${BAK}"
	for e in "${EXTS[@]}";do
		if [ -e "${1}-${e}" ]; then
			cp "${1}-${e}" "${BAK}-${e}"
		fi
	done
	
	if sqlite3 "${1}" .dump > "${BAK}.sql" 2>> "${BAK}.dump.log"; then
		rm "${1}"
		for e in "${EXTS[@]}";do
			if [ -e "${1}-${e}" ]; then
				rm -f "${1}-${e}" "${BAK}-${e}"
			fi
		done
		if ! sqlite3 "${1}" ".read ${BAK}.sql" &>> "${BAK}.import.log"; then
			echo "Error importing ${BAK}.sql to ${1}, restoring."
			cp "${BAK}" "${1}"
			for e in "${EXTS[@]}";do
				if [ -e "${1}-${e}" ]; then
					cp -f "${BAK}-${e}" "${1}-${e}"
				fi
			done
		fi
		sqlite3 "${1}" "VACUUM;"
	else
		echo "Error dumping ${1}"
	fi
	if [ -s "$BAK.sql" ]; then
		cp "$BAK.sql" "${DUMP}"
	fi

else
	echo "Not a SQLite 3.x database: ${1}"
	file "${1}"
	exit 1
fi
