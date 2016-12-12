#!/bin/bash

touch map.x
rm -rf map.*

for fn in ../0-pooled/pooled_*
do
	echo "linking map file for $fn"
	chp=`echo $fn | awk -F_ '{print $2}'`
	ln -sf /Volumes/data/m-maps/map.$chp
done
