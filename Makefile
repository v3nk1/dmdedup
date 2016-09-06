obj-m += dm-dedup.o

dm-dedup-objs := dm-dedup-cbt.o dm-dedup-hash.o dm-dedup-ram.o  dm-dedup-rw.o dm-dedup-target.o

EXTRA_CFLAGS := -I ${PWD}/../linux-4.4/drivers/md -w

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
	modprobe dm_persistent_data
	insmod dm-dedup.ko
	dmesg -c >> dmdedup.log
	./dmdedup.sh
	dmesg -c >> dmdedup.log
	#mkfs.ext4 /dev/mapper/mydedup
	#dmesg -c >> dmdedup.log
	#mount /dev/mapper/mydedup /mnt
	#dmesg -c >> dmdedup.log
	#sync /dev/mapper/mydedup
	#dmesg -c >> dmdedup.log

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	#umount /mnt
	dmsetup remove mydedup
	rmmod dm-dedup
	rm -rf dmdedup.log
