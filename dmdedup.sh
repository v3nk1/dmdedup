#!/bin/bash

META_DEV=/dev/sdb1
DATA_DEV=/dev/sdb2
BLOCKSZ=4096

DATA_DEV_SIZE=`blockdev --getsz $DATA_DEV`
TARGET_SIZE=$(($DATA_DEV_SIZE * 15 / 10))

umount $META_DEV
umount $DATA_DEV

dd if=/dev/zero of=$META_DEV bs=4096 count=1

echo "0 $TARGET_SIZE dedup $META_DEV $DATA_DEV $BLOCKSZ md5 cowbtree 100" |\
dmsetup create mydedup
