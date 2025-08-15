#!/bin/bash
#datetime=$(date -Iminutes)
en_bin=ICIS_Encryption

#echo "$datetime"



OUTPUT=$(perf stat ./$en_bin < "./text/$1.txt" 2> /dev/shm/totaltimebuf)

echo "$OUTPUT"
cat /dev/shm/totaltimebuf | grep task-clock

#i=56

#./$en_bin < "./text/$i.txt"