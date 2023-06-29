#!/bin/bash

function terminate {
	echo $1
	exit $2
}

user=kringla

basedir=$(basename "$PWD")

do_base=true
dopackage=false
status_ok=true

while getopts 'bpu:h' FLAG; do
	case "$FLAG" in
		b)#dont do base
			do_base=false
			;;
		p)#dont do packages
			do_packages=false
			;;
		u)
			user=$OPTARG
			;;
		h)
			echo "Script usage: $(basename \$0) [-u username] [-h]"
			;;
	esac
done
if [[ $(id -u) -ne 0 ]]
then
	echo -e "\n\nRun this script as root!\n\n"
	exit -1
fi

if [ $do_base == true ]; then
	pacman -Syyu --noconfirm || \
		pacman -S archlinux-keyring --noconfirm &&
		pacman -Syyu --noconfirm || \
		terminate 'Failed to update keyring' 1
fi

cat "packages" | xargs pacman -S --noconfirm

useradd -G wheel -m -s /bin/zsh $user

sed -i.bak "s/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers

echo enter password for user:$user
passwd $user
if [ ! -d "/home/$user/tmp/" ]; then
	echo creating tempfolder in 
	echo mkdir /home/$user/tmp
	mkdir /home/$user/tmp
fi

cp -r ../$basedir /home/$user/tmp/ 

#Logging into user to setup user specific details
sudo -iu $user bash << 'EOF'
cd tmp/linux_setup
./gitcloner.sh

for f in sub/*.sh; do
	bash "$f"
done
cd ~
rm -rf tmp
EOF
exit 0
