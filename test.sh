#!/bin/bash

results=results.txt
en_bin=ICIS_Encryption

echo "$HOSTNAME Performance test"

if [[ -e "/proc/device-tree/model" ]]; then
  echo "Raspberry PI Model"
  cat /proc/device-tree/model
else
  echo "Not Raspberry pi"
fi

echo "Perf Statistics"
mkdir "results"

echo "Encryption & Decryption"
for i in {28,56,112,224}; do
  file="results/$i/$results"
  echo "Plaintext: $i Byte"
  echo "Encryption_Decryption" >> "$file"
  mkdir "results/$i"
  OUTPUT="$(perf stat ./$en_bin < ./text/28.txt)"
  $OUTPUT >> "$file"
  $OUTPUT | grep "task-clock"
done



#echo "28 Byte Plaintext Encryption and Decryption" >> $results

#perf stat ./$en_bin < ./text/28.txt >> $results


#echo "56 Byte Plaintext Encryption and Decryption"

#perf stat ./$en_bin < ./text/56.txt


#echo "112 Byte Plaintext Encryption and Decryption"

#perf stat ./$en_bin < ./text/112.txt


#echo "224 Byte Plaintext Encryption and Decryption"

#perf stat ./$en_bin < ./text/224.txt