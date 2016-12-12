#!/bin/bash

for breed in BRG AAN HER LIM SIM RAN GVH CHA BSH RDP NEL
do
	./xxx-func3-split-by-chip-breed.sh $breed &
	waitMulti.sh xxx-func3 6
done

wait

