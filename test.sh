#!/bin/bash
datetime=$(date -Iminutes)
results="results/test-$datetime.txt"
en_bin=ICIS_Encryption
nr_runs=7

tty | tee -a "$results"

mkdir "results" > /dev/null
echo "$results"

touch "$results"

echo "$HOSTNAME Performance test" | tee -a "$results"

uname -svrm | tee -a "$results"
#
#if [[ -e "/proc/device-tree/model" ]]; then
#  echo "Raspberry PI Model"
#  cat /proc/device-tree/model
#else
#  echo "Not Raspberry pi"
#fi



echo "Timing test" | tee -a "$results"
for i in {28,56,112,224}; do
  echo "Message: $i Byte" | tee -a "$results"
  sum_func=0
  sum_rand=0
  sum_encr=0
  sum_decr=0

  for j in $(seq 1 "$nr_runs"); do
    echo "Run $j" | tee -a "$results"
    OUTPUT=$(perf stat ./$en_bin < "./text/$i.txt" 2> /dev/shm/totaltimebuf)

    grep task-clock </dev/shm/totaltimebuf | xargs

    echo "$OUTPUT" | tee -a "$results"

    func=$(echo "$OUTPUT" | cut -d "," -f 1)
    sum_func=$((sum_func+func))
    echo "$func" | tee -a "$results"
    #echo "$sum_func"

    rand=$(echo "$OUTPUT" | cut -d "," -f 2)
    sum_rand=$((sum_rand+rand))
    echo "$rand" | tee -a "$results"


    encr=$(echo "$OUTPUT" | cut -d "," -f 3)
    sum_encr=$((sum_encr+encr))
    echo "$encr" | tee -a "$results"

    decr=$(echo "$OUTPUT" | cut -d "," -f 4)
    sum_decr=$((sum_decr+decr))
    echo "$decr" | tee -a "$results"

    #total=$(grep task-clock </dev/shm/totaltimebuf | xargs | cut -d " " -f 1)
    #sum_total=$((sum_total+total))


  done

  avg_func=$((sum_func / nr_runs))
  avg_rand=$((sum_rand / nr_runs))
  avg_encr=$((sum_encr / nr_runs))
  avg_decr=$((sum_decr / nr_runs))
  #avg_total=$((sum_total / nr_runs))

  echo "AVG over $nr_runs runs" | tee -a "$results"
  echo "functional: $avg_func" | tee -a "$results"
  echo "random: $avg_rand" | tee -a "$results"
  echo "encryption: $avg_encr" | tee -a "$results"
  echo "Decryption: $avg_decr" | tee -a "$results"

done
