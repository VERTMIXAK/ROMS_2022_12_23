#!/bin/bash

for i in `seq -w 1 300`
do	
#	echo $i
	dupes=`find . -name *_his_000$i.nc | wc -l`
	if [ $dupes -gt 1 ]
	then
		find . -name *_his_000$i.nc
	fi
done


for i in `seq -w 1 300`
do
#   echo $i
    dupes=`find . -name *_his2_000$i.nc | wc -l`
    if [ $dupes -gt 1 ]
    then
        find . -name *_his2_000$i.nc
    fi
done

for i in `seq -w 1 300`
do
#   echo $i
    dupes=`find . -name *_avg_000$i.nc | wc -l`
    if [ $dupes -gt 1 ]
    then
        find . -name *_avg_000$i.nc
    fi
done
