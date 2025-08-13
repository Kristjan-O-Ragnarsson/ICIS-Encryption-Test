#!/bin/bash

datetime=$(date -Iminutes)
results="mem-test-$datetime.txt"
en_bin=ICIS_Encryption
nr_runs=7


touch "$results"

echo "$HOSTNAME Memory test" | tee -a "$results"

uname -svrm | tee -a "$results"




for i in {28,56,112,224}; do
  echo "Memory: $i Byte" | tee -a "$results"
  sum_mem=0

  for j in $(seq 1 "$nr_runs"); do
    echo "Run $j" | tee -a "$results"
    OUTPUT=$(cat "./text/$i.txt" | /bin/time -v ./$en_bin  > /dev/null)
    MAX_RSS=$(/bin/time -v ./$en_bin < "./text/$i.txt" > /dev/null 2>&1 1>/dev/null | grep 'Maximum resident set size' | awk '{print $6}')

    echo "$OUTPUT" | tee -a "$results"
    echo "$MAX_RSS"

#    func=$(echo "$OUTPUT" | cut -d "," -f 1)
#    sum_func=$((sum_func+func))
#    echo "$func" | tee -a "$results"
#    #echo "$sum_func"
#
#    rand=$(echo "$OUTPUT" | cut -d "," -f 2)
#    sum_rand=$((sum_rand+rand))
#    echo "$rand" | tee -a "$results"
#
#
#    encr=$(echo "$OUTPUT" | cut -d "," -f 3)
#    sum_encr=$((sum_encr+encr))
#    echo "$encr" | tee -a "$results"
#
#    decr=$(echo "$OUTPUT" | cut -d "," -f 4)
#    sum_decr=$((sum_decr+decr))
#    echo "$decr" | tee -a "$results"

  done

  #avg_mem=$((sum_mem / nr_runs))


  #echo "AVG over $nr_runs runs" | tee -a "$results"
  #echo "functional: $avg_mem" | tee -a "$results"


done
