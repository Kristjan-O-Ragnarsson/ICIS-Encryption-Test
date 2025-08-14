#!/bin/bash

echo "Limiting cpu freq to 800Mhz"

for i in {0,1,2,3}; do
    sudo cpufreq-set -c "$i" -u 800000
    sudo cpufreq-set -c "$i" -d 800000
done