#!/usr/bin/env bash

output_dir=rel
output=$output_dir/installscripts.sh

if [ ! -d  $output_dir ]; then
	mkdir $output_dir
fi
echo $output_dir
[ -f $output ] && rm $output


cat << 'EOF' > $output
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

echo $output

tar --exclude={.git,$output_dir}  -zcpvO . >> $output 

chmod +x $output
exit 0
