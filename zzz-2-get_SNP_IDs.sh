#!/bin/bash

for fn in 0-pooled/pooled_*
do
	echo "======== $fn"
	chip=`echo $fn |awk -F_ '{print $2}'`
	header=`head -1 $fn`
	echo $header | awk -F\# '{ for(i=3;i<=NF;i++) print $i}' > rrr-2-SNP_IDs-$chip
	ggrep rrr-2-SNP_IDs-$chip 1-maps/map.$chip > 1-maps/valid.map.$chip &
	waitMulti.sh ggrep 5
done
wait


cd 1-maps
mapUniter valid.map.*

#for fn in rrr-2-SNP_IDs-*
#do
#	echo =============== $fn
#	testInRefCounter $fn rrr-2-SNP_IDs-*
#done

vecChips=(HD 100k GGPHD 50k SuperLD 9k)
noc=${#vecChips[@]} # 6
n_1=`expr $noc - 1` # 5

si=snp_info.txt

for i in `seq 0 $n_1`
do
	opt=si.map.${vecChips[$i]}
	col=`expr 4 + $i`
	echo generating $opt by selecting col-$col in $si \&
	awk "\$$col>0{print \$1, \$2, \$3}" $si > $opt &
	waitMulti.sh awk 5
done

wait
cd ..
