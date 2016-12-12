#!/bin/bash

for file in job*/pooled_*
do
	echo $file
	dr=`echo $file | awk -F/ '{print $1}'`
	pl=`echo $file | awk -F/ '{print $2}'`
	ch=`echo $file | awk -F_ '{print $2}'`
	awk 'FNR>1{print $1}' $file > $dr/IDs.$ch.IDs &
	waitMulti.sh awk 6
done



wait

for dr in job*
do
	for idf in $dr/IDs.*.IDs
	do
		echo ============== $dr === $idf
		testInRefCounter $idf $dr/IDs.*.IDs >/dev/null
	done
done
