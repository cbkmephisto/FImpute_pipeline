#!/bin/bash

breed=$1
[ -z $breed ] && echo need a parameter for breed && exit;

	# mkdir if not exist
	dfn=job.$breed
	[ ! -d $dfn ] && mkdir $dfn

	for chip in `ls 0-pooled/pooled_*|awk -F_ '{print $2}'`  #9k 50k 100k GGPHD HD SuperLD
	do
		pooled=0-pooled/pooled_$chip

		gts=`grep $breed $pooled |head -1 | awk '{print $1}'`
		if [ -z $gts ]
		then
			continue
		fi
		ts=`date "+%Y-%m-%d %H:%M:%S"`
		echo " + $ts | $chip $breed"
		file=$dfn/pooled_${chip}_$breed
		head -1 $pooled > $file
		grep $breed $pooled >> $file
	done
