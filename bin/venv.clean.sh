#!/usr/bin/env bash

files=()

for dir in "${HOME}/usr/local/include/" "${HOME}/usr/local/lib/" "${HOME}/usr/local/bin/";do
	for file in python pip activate;do
		while read -r file <&3;do
			files+=( "${file}" )
			echo -n '.'
		done 3< <( find "${dir}" -type f -name "${file}"'*' )
	done
done

venv_python="$( head -n 1 "${HOME}/usr/local/bin/pip" | cut -d '!' -f 2 )"
if [ -z "${venv_python}" ]; then
	echo "Unable to find venv pip"
	exit 1
fi

while read -r file <&3;do
	if head -n 1 "${file}" | grep "${venv_python}" >> /dev/null 2>> /dev/null;then
		echo -n .
		files+=( "${file}" )
	else
		echo -n '!'
	fi
done 3< <( find "${HOME}/usr/local/bin/" -type f )

while read -r pycfg <&3;do
	files+=( "${pycfg}" )
	echo -n '.'
done 3< <( find "${HOME}/usr/local/" -name 'pyvenv*' )
echo -e "\nChecking for python ${venv_python}\nFiles:"
printf "\t%s\n" "${files[@]}"

tar -f "${HOME}/usr/local/tmp/python.venv.$(date +%s).backup.tar" -v -c "${files[@]}"
rm -rfv "${files[@]}" ~/usr/local/lib/python* ~/usr/local/bin/python* ~/usr/local/bin/pip* ~/usr/local/bin/activate.fish ~/usr/local/bin/activate.csh ~/usr/local/bin/activate ~/usr/local/bin/Activate.ps1 ~/usr/local/pyvenv.cfg
