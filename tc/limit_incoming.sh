#!/bin/bash
set -e
set -x

VIRTUAL="ifb0"
INTERFACE="eno1"
DEFAULT_QDISC="htb"
BANDWIDTH_CEIL="2mbps"
BANDWIDTH_RATE=${BANDWIDTH_CEIL}

REMOTE_HOSTS="8.8.8.8
8.8.8.9"

# clean
# tc class del dev ${VIRTUAL} parent 2: classid 2:0
# tc qdisc del root dev ${VIRTUAL}
# tc qdisc del dev ${INTERFACE} handle ffff: ingress

echo "startup virtual interface."
modprobe ifb numifbs=1
ip link set dev $VIRTUAL up

tc qdisc add dev $INTERFACE handle ffff: ingress
for host in ${REMOTE_HOSTS}
do
    echo "redirect ${host}."
    tc filter add dev $INTERFACE parent ffff: protocol ip u32 \
        match ip src ${host}/32 \
        match ip sport 8000 0xffff \
        action mirred egress redirect dev $VIRTUAL
done
echo "limit bandwidth."
tc qdisc add dev $VIRTUAL root handle 2: ${DEFAULT_QDISC}
tc class add dev $VIRTUAL parent 2: classid 2:0 ${DEFAULT_QDISC} rate ${BANDWIDTH_RATE} ceil ${BANDWIDTH_CEIL}