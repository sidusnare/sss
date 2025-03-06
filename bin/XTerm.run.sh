#!/usr/bin/env bash
if [ -z "${SSH_AUTH_SOCK}" ];then
	source FILE="${HOME}/usr/tmp/.${USER}.env"
fi
	
for t in mate-terminal gnome-terminal lxterminal konsole terminator xterm;do
	ft="$( readlink -f "$( command -v "${t}" )" )"
	if [ -x "${ft}" ]; then
		exec "${ft}" "${@}"
	fi
done
