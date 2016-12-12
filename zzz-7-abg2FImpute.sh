#!/bin/bash

for dir in job.*
do
	cd $dir
	echo $dir
	si=../1-maps/snp_info.txt
	abg2FImpute $si tdmout.* >abg2FImpute.log 2>abg2FImpute.err & 
	waitMulti.sh abg2FImpute 6
	cd ..
done

wait

