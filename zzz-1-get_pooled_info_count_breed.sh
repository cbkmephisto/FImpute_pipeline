#!/bin/bash

opt=rrr-1-breed-population
touch $opt
rm -rf $opt
touch $opt

for fn in 0-pooled/pooled_*
do
	echo "# ======= $fn ======="
	echo "# ======= $fn =======" >> $opt
	awk 'FNR>1{print substr($1,0,3)}' $fn | sort | uniq -c >> $opt
done

echo Output file $opt generated.
