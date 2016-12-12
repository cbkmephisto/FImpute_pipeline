#!/bin/bash


mv job.*/optDummy/ab-gen* .

for dir in job.*
do
	cd $dir/optDummy
	echo $dir
	gzip snp_info.txt &
	gzip genotypes_imp.txt&
	waitMulti.sh gzip 4
	cd ../..
done

wait
