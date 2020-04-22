#!/bin/bash

# usage: ./chprio [server ip1] [prio1] [server ip2] [prio2] [self ip]
# use private ip here, and prio value is DSCP value in ip head.
# ref: https://en.wikipedia.org/wiki/Differentiated_services

if [ $# != 5 ]
then
    echo "Expected: ./chprio [server ip1] [prio1] [server ip2] [prio2] [self ip]"
    exit 0
fi

sudo iptables -t mangle -F
sudo iptables -t mangle -A INPUT -p tcp -s $1 -d $5 -j DSCP --set-dscp $2
sudo iptables -t mangle -A INPUT -p tcp -s $3 -d $5 -j DSCP --set-dscp $4
sudo iptables -L -v -n -t mangle