#!/bin/bash

results=results.txt
en_bin=ICIS_Encryption

ECHO "$HOSTNAME Performance test"
ECHO "Raspberry PI Model"
cat /proc/device-tree/model

ECHO "Perf Statistics"


ECHO "28 Byte Plaintext Encryption and Decryption" >> $results

perf stat ./$en_bin < ./text/28.txt >> $results


ECHO "56 Byte Plaintext Encryption and Decryption"

perf stat ./$en_bin < ./text/56.txt


ECHO "112 Byte Plaintext Encryption and Decryption"

perf stat ./$en_bin < ./text/112.txt


ECHO "224 Byte Plaintext Encryption and Decryption"

perf stat ./$en_bin < ./text/224.txt