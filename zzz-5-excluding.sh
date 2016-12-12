#!/bin/bash

#cps=`ls 0-pooled/pooled_* | awk -F_ '{print $2}'`

declare -a vecChips
#vecChips=($cps)
vecChips=(HD 100k GGPHD 50k SuperLD 9k)

noc=${#vecChips[@]} # 6
n_1=`expr $noc - 1` # 5
n_2=`expr $noc - 2` # 4

for dir in job.*
do
	cd $dir
	echo $dir
	brd=`echo $dir | awk -F. '{print $2}'`
	for i in `seq 0 $n_2` # 5 tot: 0 1 2 3 4
	do
		higher=${vecChips[$i]}
		hf=IDs.$higher.IDs
		[ ! -f $hf ] && continue
		i1=$(expr $i + 1) # = 1 2 3 4 5
		for j in `seq $i1 $n_1`
		do
			lower=${vecChips[$j]}
			lf=IDs.$lower.IDs
			[ ! -f $lf ] && continue
			exc=exc.$lower.$higher
			testInRefCounter $hf $lf > $exc
			[ ! -s $exc ] && rm $exc
		done
	done

	for i in `seq $n_1` #1 2 3 4 5 # lower
	do
#		echo -n $i
		lower=${vecChips[$i]}
#		echo "  $lower"
		lowers=(exc.$lower.*)
		[ ! -f ${lowers[0]} ] && continue
		sort -u ${lowers[@]} > bll.$lower
		rm ${lowers[@]}

		SNPipeline.abgExcl bll.$lower pooled_${lower}_$brd -o pooled_${lower}_$brd.nodup &
		waitMulti.sh SNPipeline 3
	done
	cd ..
done
wait

