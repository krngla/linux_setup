#!/usr/bin/env bash

output_dir=rel
output=$output_dir/installscripts.sh

if [ ! -d  $output_dir ]; then
	mkdir $output_dir
fi
[ -f $output ] && rm $output


cat << 'EOF' > $output
#!/bin/bash

[ $# -ne 1 ] && echo "please provide username" && exit 1

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
tar --exclude={.git,$output_dir}  -zcpvO $base >> $base/$output 
cd $base
chmod +x $output
exit 0
