#!/bin/bash
src=$1
dst=$2

check=node1 
if [ "$dst" == "$check" ]; then
    dstip=172.0.0.2
fi
check=node2
if [ "$dst" == "$check" ]; then
    dstip=172.0.0.3
fi
check=node3
if [ "$dst" == "$check" ]; then
    dstip=10.10.0.2
fi
check=node4
if [ "$dst" == "$check" ]; then
    dstip=10.10.0.3
fi
check=router
if [ "$dst" == "$check" ]; then
    dstip=10.10.0.1
fi

sudo ip netns exec $src ping $dstip
