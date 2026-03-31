#!/usr/bin/env bash

cd "$( dirname "$( readlink -f "${0}" )" )" || exit 1
cd .. || exit 1


DOTFILES=( 'bashrc' 'bash_profile' 'vimrc' )



for file in "${DOTFILES[@]}";do
	full_file="$( readlink -f "etc/${file}" )"
	ln -sfv "${full_file}" "${HOME}/.${file}"
done
