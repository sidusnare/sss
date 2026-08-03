#!/usr/bin/env bash

#GPL-2

#This could be faster if we assume all files in the same repo, or if we added the complexity of doing multiple loops to track all the repos files are in.
#Put it down as a TODO, but performance has been adequate so far.



for file in "${@}";do
	#echo "${file}"
	full_file="$( readlink -f "${file}" )"
	dir="$( dirname "${full_file}" )"
	base="$( git -C "${dir}" rev-parse --show-toplevel 2>> /dev/null )"
	if [[ "${full_file}" =~ "${base}/.git/" ]]; then
		#echo -e "\tSkipping, in a .git folder"
		continue
	fi
	if [ -z "${base}" ]; then
		#echo -e "\tSkipping, cannot find a repo for ${file}" >&2
		continue
	fi
	gtime="$( git -C "${base}" log --pretty=%at -n1 -- "${full_file}" )"
	mtime="$( stat -c %Y  -- "${full_file}" )"
	if [ "${gtime}" = "${mtime}" ]; then
		continue
	fi
	if [ -z "${gtime}" ]; then
		#echo -e "\tSkipping, file not in-repo: ${file}" >&2
		continue
	fi
	if ! [ "${gtime}" -gt 631170000 ]; then
		#echo -e "\tSkipping, Time parsing error or pre-1990 git time for ${file}" >&2
		continue
	fi
	echo -e "\n${file}"
	ls -l -- "${full_file}" | sed -e 's/^/\t/'
	touch -d "@${gtime}" "${full_file}"
	ls -l -- "${full_file}" | sed -e 's/^/\t/'
done

