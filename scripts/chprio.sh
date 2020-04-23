#!/bin/bash

# usage: ./chprio [max_bandwidth] [max_flows]
# Note: bandwidth here uses MB unit.
# 
# Please make sure you are using FQ in Qdisc, you could run `tc qdisc show` to verify
# If not using FQ, please run `sudo tc qdisc add dev ens3 root fq` to use FQ.

if [ $# != 2 ]
then
    echo "Expected: ./chprio [max_bandwidth] [max_flows]"
    exit 0
fi

max_pacing_rate=`expr $1 / $2 \* 8`
unit="mbit"
val="$max_pacing_rate$unit"

sudo tc qdisc replace dev ens3 root fq maxrate $val
sudo tc qdisc show