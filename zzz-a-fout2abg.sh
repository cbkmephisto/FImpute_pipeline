#!/bin/bash

chip=HD
# fout2abg
for dir in job.*
do
	brd=`echo $dir | awk -F. '{print $2}'`
	cd $dir/optDummy
	echo $dir
	abg=ab-genotype-${chip}-$brd
	fout2abg snp_info.txt genotypes_imp.txt -o $abg >fout2abg.log 2>fout2abg.err &
	waitMulti.sh fout2abg 3
	cd ../..
done

wait

# abg2bin
for dir in job.*
do
	brd=`echo $dir | awk -F. '{print $2}'`
	cd $dir/optDummy
	echo $dir
	abg=ab-genotype-${chip}-$brd
	abg2bin $abg
	binaryGenotypeFileIndexer $abg.newbin
	cd ../..
done




