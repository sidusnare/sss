#!/bin/bash

for prog in xdotool import kdialog;do
	if ! command -v "${prog}"; then
		echo "Please install ${prog}" >&2 
		kdialog --notification "Error: install ${prog}"
		exit 1
	fi
done
if [ -n "${1}" ]; then
	sleep "${1}"
fi
if [ ! -e "${HOME}/Stuff/ScreenShots" ]; then
	mkdir -p "${HOME}/Stuff/ScreenShots" || exit 1
fi
window="$(xdotool selectwindow)"
name="${HOME}/Stuff/ScreenShots/Screen.$(date -I).$(date +%s).$( date +%N).png"
echo "Importing ${window} into ${name}"
import -window "${window}" "${name}"
ret="${?}"
if [ "${ret}" -gt 0 ]; then
	echo "Error importing ${window} into ${name}"
	kdialog --notification "Error importing ${window} into ${name}"
else
	echo 'sucsess'
	kdialog --notification "Importing ${window} into ${name}"
fi
exit "${ret}"
