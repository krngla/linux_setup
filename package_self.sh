#!/bin/bash

if [ $# -ne 2 ]; then
	echo please provide username
	exit 1
fi

if [ ! -d  ../output ]; then
	mkdir ../output
fi
cat << 'EOF' > ../output/installscripts.sh
#!/bin/bash

#Find start of payload
PAYLOAD_LINE=$(awk '/^__PAYLOAD_BEGINS__/ { print NR + 1; exit 0; }' $0)

#Find top layer of tarball
dir_name=$(tail -n +${PAYLOAD_LINE} $0 | tar -zpt | head -1 | cut -f1 -d"/")
tail -n +${PAYLOAD_LINE} $0 | tar -zpvx

echo $dir_name
echo Starting install process...
cd $dir_name
./install.sh -u $1
cd ..

#Cleanup pwd
rm -rf $dir_name
exit 0
__PAYLOAD_BEGINS__ 
EOF
base=$(basename $PWD)
cd ..
tar --exclude='./.git' -zcpvO $base >> output/installscripts.sh 

chmod +x output/installscripts.sh
