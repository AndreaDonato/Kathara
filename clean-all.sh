#!/bin/bash

error=0

for lab in $(ls -1 | grep "^lab"); do
	#echo $lab
	cd $lab
	for ex in $(ls -1 | grep "^ex"); do
		#echo $ex
		cd $ex
		kathara lclean > /dev/null || { echo "Problem lcleaning $lab $ex" && error=1; } 
		cd ..
	done
	cd ..
done

if [ $error -eq 0 ]; then
	echo "$error - All labs were successfully lcleaned"
fi
