#!/bin/bash

#SPDX-License-Identifier: GPL-3.0-only

while read -r package;do
	pip install --upgrade "${package}"
done < <( pip list | cut -d ' ' -f 1 | grep -E -v '^Package$|^--*$'  )
