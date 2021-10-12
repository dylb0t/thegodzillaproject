#!/bin/bash
# Purpose of this is to copy the dist into a bunch of smaller folders that are more manageable with IPFS.

counter=0
dircounter=0
for dirs in $(ls -rt ../dist); do
	echo $dirs
	#Need to fix the logic here. 
	if [ $counter -eq 0 ]
	then
		mkdir -p ./copies/$dircounter
	fi

	cp -R ../dist/$dirs ./copies/$dircounter

	if [ $counter -eq 100 ] 
	then
		echo "./copies/$dircounter"
		let "dircounter++"
		counter=0
	else
		let "counter++"
	fi
done

