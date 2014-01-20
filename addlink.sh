#!/bin/bash

if  [ $# -ne 2 ]
then
	echo "Usage : addlink.sh href title";
	exit;
fi

href=`echo $1 | sed -e 's/[\\/&]/\\\\&/g'`
title=`echo $2 | sed -e 's/[\\/&]/\\\\&/g'`

echo $href
echo $title

sed "s/\
        <\/ul>/\
            <li><a href=\"$href\">$title<\/a><\/li>\n\
        <\/ul>/" links.html >links.html.tmp
mv links.html.tmp links.html
git add links.html
git commit -m "add link $1 $2" links.html
