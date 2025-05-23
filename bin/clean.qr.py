#!/usr/bin/env bash

#SPDX-License-Identifier: GPL-3.0-only
for prog in zbarimg qrencode convert;do
	if ! command -v "${prog}"; then
		echo "Unable to find ${prog}" >&2
		exit 1
	fi
done

for img in "${@}";do
	if ! [ -e "${img}"  ]; then
		echo "Unable to find ${img}" >&2
		continue
	fi
	name="${img%.*}"
	extention="${img##*.}"
	size="$( identify -format '%xx%y' "${img}" )"
	if [ -e "${name}.old.png" ]; then
		echo "File colision: ${name}.old.png exists, skipping ${img}"
		continue
	fi
	if [ -e "${name}.old.${extention}" ]; then
		echo "File colision: ${name}.old.${extention} already exists, skipping ${img}"
		continue
	fi
	qr="$( zbarimg -q --raw "${img}" )"
	if [ -z "${qr}" ];then
		echo "Unable to decode QR in ${img}"
		continue
	fi
	mv "${img}" "${name}.old.${extention}"
	if ! qrencode -d 300 -o "${name}.png" "${qr}"; then
		echo "Unable to encode data for ${img}" >&2
		mv -f "${name}.old.${extention}" "${img}"
		continue
	fi
	if [ -z "${size}" ]; then
		echo "Unable to determine size of ${img}" >&2
		if [ "${extention}" != 'png' ]; then
			convert "${name}.png" "${name}.${extention}"
		fi
	else
		convert -scale "${size}" "${name}.png" "${name}.${extention}"
	fi
done
