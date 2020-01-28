#!/bin/bash
suff=ttf
fonts=$(find ./build -name \*.${suff})
timestamp=$(date -Isecond)

for font in ${fonts};
do
	mv ${font} ${font%.*}_${timestamp}.${suff}
done
sed -i "s/.ttf/_${timestamp}&/" ./build/css/font.css


