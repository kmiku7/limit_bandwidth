#!/bin/bash
set -e
set -x

INTERFACE="eno1"
DEFAULT_QDISC="htb"
BANDWIDTH_CEIL="2mbps"
BANDWIDTH_RATE=${BANDWIDTH_CEIL}

REMOTE_HOSTS="8.8.8.8
8.8.8.9"

echo "setup class."
tc qdisc add dev $INTERFACE root handle 1: htb
tc class add dev $INTERFACE parent 1: classid 1:1 htb rate $BANDWIDTH_RATE ceil $BANDWIDTH_CEIL

for host in ${REMOTE_HOSTS}
do
    echo "classify ${host}."
    tc filter add dev $INTERFACE parent 1: protocol ip u32 \
        match ip dst ${host}/32 \
        match ip sport 8000 0xffff \
        flowid 1:1
done