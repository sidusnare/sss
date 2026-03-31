#!/usr/bin/env bash

packages=( setuptools  pre-commit rainbowstream yt-dlp pyyaml rokucli audible audible-cli awscli python-kasa plexapi pygobject )

if [ ! -e "${HOME}/usr/local/bin/activate" ]; then
	python -mvenv "${HOME}/usr/local" --system-site-packages
fi
source "${HOME}/usr/local/bin/activate" || exit 1
pip install --upgrade pip

for package in "${packages[@]}";do
	pip install --upgrade "${package}"
done
