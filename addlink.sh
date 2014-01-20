#!/bin/bash

if  [ $# -ne 2 ]
then
	echo "Usage : addlink.sh href title";
	exit;
fi

sed "s/\
        <\/ul>/\
            <li><a href=\"$1\">$2<\/a><\/li>\n\
        <\/ul>/" links.html >links.html.tmp
mv links.html.tmp links.html
git add links.html
git commit -m "add link $1 $2" links.html
