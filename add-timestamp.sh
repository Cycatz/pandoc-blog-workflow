#!/bin/bash
fonts_ttf=$(find ./build -name \*.ttf)
fonts_woff2=$(find ./build -name \*.woff2)
timestamp=$(date +%s)

for font in ${fonts_ttf};
do
	mv ${font} ${font%.*}_${timestamp}.ttf
done
for font in ${fonts_woff2};
do
	mv ${font} ${font%.*}_${timestamp}.woff2
done

sed -i "s/.ttf/_${timestamp}&/" ./build/css/font.css
sed -i "s/.woff2/_${timestamp}&/" ./build/css/font.css


