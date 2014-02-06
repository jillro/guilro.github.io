#!/bin/bash

if  [ $# -ne 2 ]
then
	echo "Usage : addlink.sh href title";
	exit;
fi

echo "" >> _data/links.yaml
echo "- href: $1" >> _data/links.yaml
echo "  title: $2" >> _data/links.yaml

git add _data/links.yaml
git commit -m "add link $1 $2" _data/links.yaml
