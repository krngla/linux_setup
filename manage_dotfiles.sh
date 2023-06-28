#!/bin/bash

function archive_dotfiles {
	echo "archiving dotfiles"
	cd ~
	#tar cpzf $dir/dotfiles.tar.gz .zshrc .config/nvim .config/tmux
	tar cpzfh $dir/dotfiles.tar.gz -T $dir/"dotfiles"
	cd $dir
}

function unarchive_dotfiles {
	echo "unarchiving dotfiles"
	tar xpzf $dir/dotfiles.tar.gz
	echo tar xpzf $dir/dotfiles.tar.gz
}

function main {
	do_archive=false
	dir=$(pwd)
	archive=dotfiles.tar.gz

	while getopts 'd:f:ha' OPTION; do
		case "$OPTION" in
			d)
				dir=$OPTARG
				;;
			f)
				archive=$OPTARG
				;;
			a)
				do_archive=true
				;;
			h)
				echo "Script usage: $(basename \$0) [-d dir] [-f archive name] [-a]" >&2
				exit 1
				;;
		esac
	done
	cd $dir

	if [ $do_archive = true ]
	then
		archive_dotfiles
	else
		cd ~
		unarchive_dotfiles
		cd $dir
	fi
}



main "$@"
