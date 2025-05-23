#!/usr/bin/env bash

#SPDX-License-Identifier: GPL-3.0-only
#Cleans an XML file
#Fred Dinkler IV

for i in "${@}";do
	file="$( tmpfile clean.xml )"
	echo "Working on ${i} backing up in ${file}.bak"
	if ! cp -av "${i}" "${file}.bak"; then
		echo "Unable to backup ${i}" >&2
		continue
	fi

	if ! echo "${i}" > "${file}.log"; then
		echo "Unable to log ${i}" >&2
		continue
	fi

	if ! grep -E -a -v '^<<<<<<<|^=======|^>>>>>>>' "${i}" >  "${file}"; then
		mv "${i}" "${file}"
		echo "Unable to strip git comments from ${i}" >&2
		continue
	fi

	if ! xmllint --recover --format "${file}" > "${i}" 2>> "${file}.log"; then
		echo "Error linting ${file}, restoring ${file}.bak to ${i}"
		cp -afv "${file}.bak" "${i}"
	fi
done
		
