#!/usr/bin/env bash

function configure_debian {
	sed -i.bak "s/^alias nvim=/alias nvim=nvim.appimage/" $rc
}

function configure_arch {
	sed -i.bak "s/^alias nvim=//" $rc
}


rc=~/.zshrc
dist=$(cat /etc/os-release | grep ^ID | sed -e "s/^ID=\(.*\)/\1/")

case $dist in
	debian)
		#do deb
		echo configuring debian
		configure_debian
		;;
	arch)
		#do arch
		echo configuring arch
		configure_arch
		;;
esac

		
