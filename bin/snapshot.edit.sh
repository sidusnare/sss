#!/usr/bin/env bash

last="$( find "${HOME}/Stuff/ScreenShots/" -type f -printf '%T+|%p\n' | sort | tail -n 1 | cut -d '|' -f 2 )"
echo "Last: ${last}"
if command -v gthumb; then
	gthumb "${last}"
elif command -v gimp; then
	gimp "${last}"
else
	echo "Unable to find an appropriate image editor"
	exit 1
fi
