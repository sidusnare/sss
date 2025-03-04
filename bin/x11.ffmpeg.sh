#!/bin/bash
host="$( hostname )"

FPS=30
case "${host}" in
	david)
		FPS=144
		;;
	eddie)
		FPS=60.02
		;;
	jarvis)
		FPS=60
		;;
esac 
#sound=( '-f' 'lavfi' '-i' 'anullsrc=channel_layout=stereo:sample_rate=44100' )
if pactl list short sources | grep MySink.monitor; then
	sound=( '-f' 'pulse' '-i' 'MySink.monitor' )
else
	sound=( '-f' 'lavfi' "-i" "anullsrc" )
fi
xdotool selectwindow
loc=$( xdotool getmouselocation )
mousex=$( awk '{print($1)}' <<< "${loc}" | awk -F : '{print($2)}' )
mousey=$( awk '{print($2)}' <<< "${loc}" | awk -F : '{print($2)}' )

xdotool selectwindow
loc=$( xdotool getmouselocation )
mousexb=$( awk '{print($1)}' <<< "${loc}" | awk -F : '{print($2)}' )
mouseyb=$( awk '{print($2)}' <<< "${loc}" | awk -F : '{print($2)}' )

if [ ! -d "${HOME}/Stuff/ScreenVideo" ]; then
	mkdir -p "${HOME}/Stuff/ScreenVideo"
fi
if [ $(( mousexb - mousex )) -lt 10 ]; then
	echo "Area too small or negative. First click should be above and left of second click by 10px minimum"
	exit 1
fi
if [ $(( mouseyb - mousey )) -lt 10 ]; then
	echo "Area too small or negative. First click should be above and left of second click by 10px minimum"
	exit 1
fi
echo "Dump window from ${mousex},${mousey} to ${mousexb},${mouseyb} at ${FPS} FPS, sound source is ${sound}"
filename="${HOME}/Stuff/ScreenVideo/Screen.$(date +%s.%N).mp4"
ffmpeg  -framerate "${FPS}" -video_size "$(( mousexb - mousex ))x$(( mouseyb - mousey ))" -framerate "${FPS}" -f x11grab -framerate "${FPS}" -i "${DISPLAY}+${mousex},${mousey}" "${sound[@]}" -filter:v "fps=${FPS}" "${filename}"
echo "Written to ${filename}"
ls -lh "${filename}"
