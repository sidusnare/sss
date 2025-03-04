#!/bin/bash
#Compiles C/C++ based tools for the current platform
#Fred Dinkler IV
export OS="$(uname)"
export ARCH="$(uname -m)"
cd "$( dirname "$( readlink -f "${0}" )" )" || exit 1

STATIC=()
DYNAMIC=()
FAIL=()
for x in *.c;do
	echo -e "\n\n\tWorking on ${x}"
	rm "$( basename "${x}" .c )"
	if gcc -O3 -static "${x}" -o "$( basename "${x}" .c )"; then
		echo "sucsess with static compile"
		STATIC+=( "${x}" )
	else
		if gcc -O3 "${x}" -o "$( basename "${x}" .c )";then
			echo "sucsess building dynamicly"
			DYNAMIC+=( "${x}" )
		else
			echo failure
			FAIL+=( "${x}" )
			continue
		fi
	fi
	if [ -e "$( basename "${x}" .c)" ]; then
		mv -v "$( basename "${x}" .c )" "${HOME}/usr/local/bin/"
	fi
	#Cygwin just has to be different
	if [ -e "$( basename "${x}" .c).exe" ]; then
		mv -v "$( basename "${x}" .c ).exe" "${HOME}/usr/local/bin/"
	fi
done
for x in *.cpp;do
	echo -e "\n\n\tWorking on ${x}"
	rm "$( basename "${x}" .cpp )"
	if g++ -O3 -static "${x}" -o "$( basename "${x}" .cpp )"; then
		echo "sucsess with static compile"
		STATIC+=( "${x}" )
	else
		if g++ -O3 "${x}" -o "$( basename "${x}" .cpp )";then
			echo "sucsess building dynamicly"
			DYNAMIC+=( "${x}" )
		else
			echo failure
			FAIL+=( "${x}" )
			continue
		fi
	fi
	if [ -e "$( basename "${x}" .cpp)" ]; then
		mv -v "$( basename "${x}" .cpp )" "${HOME}/usr/local/bin/"
	fi
	#Cygwin just has to be different
	if [ -e "$( basename "${x}" .cpp).exe" ]; then
		mv -v "$( basename "${x}" .cpp ).exe" "${HOME}/usr/local/bin/"
	fi
done
echo -e "Static: ${STATIC[*]}\nDynamic: ${DYNAMIC[*]}\nFail:${FAIL[*]}"
