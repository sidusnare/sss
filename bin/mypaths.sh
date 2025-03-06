#!/usr/bin/env bash

P=()

#Specified paths
PATHS=( "/opt/homebrew/bin" "${HOME}/usr/opt/binhost/${HOST}" "/opt/sun-java/bin" "/opt/sun-java/jdk/bin" "/opt/local/libexec/gnubin" "${HOME}/usr/bin.${OS}.${ARCH}" "${HOME}/usr/local/bin" "${HOME}/usr/bin" "/usr/local/sbin" "/usr/sbin" "/sbin" "${HOME}/.rvm/bin" "${HOME}/.local/bin" "/opt/local/bin" "/opt/local/sbin" "/opt/sun-java/bin/" "/opt/sun-java/jdk/bin/" )
OPATH=()
#Read in inherited PATH
while read -r line;do
	OPATH+=( "${line}" )
done < <( tr ':' '\n' <<< "${PATH}" )

#Discover MacOS paths
for p in /Library/Frameworks/Python.framework/Versions/*/bin;do
        if [ -e "${p}" ]; then
                PATHS+=( "${p}" )
        fi
done

#Build path list starting with specified paths and moving on to inherited values
for dir in "${PATHS[@]}" "${OPATH[@]}";do 
	#Skip ones we've already added
	for i in "${P[@]}";do
		if [ "${i}" == "${dir}" ]; then
			continue 2
		fi
	done
	if [ -x "${dir}" ]; then
		P+=( "${dir}" )
	fi
done
printf "%s:" "${P[@]}" | sed -e 's/:$//'
