#!/bin/sh

for i in { 1..24 }
do
  timeout 3600 tcpdump -lni any -s0 udp dst port 53 2>/dev/null | awk '/A\?/ { seen[$(NF-1)]++ } END { for(i in seen) print seen[i],i }' | sort -rn > /tmp/ntrce_dns_access-`date "+%Y%m%d-%H%M%S"`.txt
done
