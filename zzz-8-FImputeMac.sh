#!/bin/bash

#for dir in job.*
for dir in job.HER job.SIM job.AAN job.RDP job.RAN job.GVH job.LIM job.CHA job.BRG job.BSH job.NEL
do
	cd $dir
	echo $dir
	FImputeMac dummy.ctr >fip.log 2>fig.err
	cd ..
done
