#!/bin/bash

declare -a vecChips
vecChips=(HD 100k GGPHD 50k SuperLD 9k)

noc=${#vecChips[@]} # 6
n_1=`expr $noc - 1` # 5

for dir in job.*
do
	cd $dir
	echo $dir
	brd=`echo $dir | awk -F. '{print $2}'`
	for i in `seq 0 $n_1` # 6 tot: 0 1 2 3 4 5
	do
		chip=${vecChips[$i]}
		abg=pooled_${chip}_$brd
		[ -f $abg.nodup ] && abg=$abg.nodup
		[ ! -f $abg ] && continue	# skip if no this chip
		ln -sf ../1-maps/si.map.$chip map.$chip
		SNPipeline.trimDown2Map map.$chip $abg &
		waitMulti.sh SNPipeline 5
	done
	cd ..
done

wait
rm job.*/map.*

