#!/bin/bash
ROS7=`curl https://download.mikrotik.com/routeros/NEWESTa7.stable | awk '{print $1}'`
ROS7testing=`curl https://download.mikrotik.com/routeros/NEWESTa7.testing | awk '{print $1}'`
ROS7longterm=`curl https://download.mikrotik.com/routeros/NEWESTa7.long-term | awk '{print $1}'`
ROS7dev=`curl https://download.mikrotik.com/routeros/NEWESTa7.development | awk '{print $1}'`

for ROSVER in $ROS7 $ROS7testing ;
do
wget --no-check-certificate https://download.mikrotik.com/routeros/$ROSVER/chr-$ROSVER.img.zip -O /tmp/chr.img.zip
unzip -p /tmp/chr.img.zip > /tmp/chr.img
rm -rf  chr.qcow2
qemu-img convert -f raw -O qcow2 /tmp/chr.img chr.qcow2
rm -rf /tmp/chr.im*
modprobe nbd
qemu-nbd -c /dev/nbd0 chr.qcow2
rm -rf /tmp/tmp*
mkdir /tmp/tmpmount/
mkdir /tmp/tmpefipart/
mount /dev/nbd0p1 /tmp/tmpmount/
rsync -a /tmp/tmpmount/ /tmp/tmpefipart/
umount /dev/nbd0p1
mkfs -t fat /dev/nbd0p1
mount /dev/nbd0p1 /tmp/tmpmount/
rsync -a /tmp/tmpefipart/ /tmp/tmpmount/
umount /dev/nbd0p1
rm -rf /tmp/tmp*
(
echo 2 # use GPT
echo t # change partition code
echo 1 # select first partition
echo 8300 # change code to Linux filesystem 8300
echo r # Recovery/transformation
echo h # Hybrid MBR
echo 1 2 # partitions added to the hybrid MBR
echo n # Place EFI GPT (0xEE) partition first in MBR (good for GRUB)? (Y/N)
echo   # Enter an MBR hex code (default 83)
echo y # Set the bootable flag? (Y/N)
echo   # Enter an MBR hex code (default 83)
echo n # Set the bootable flag? (Y/N)
echo n # Unused partition space(s) found. Use one to protect more partitions? (Y/N)
echo w # write changes to disk
echo y # confirm
) | gdisk /dev/nbd0
qemu-nbd -d /dev/nbd0
echo "created file chr.qcow2, now back to raw but uncompressed..."
qemu-img convert -f qcow2 -O raw chr.qcow2 chr-$ROSVER.uefi-fat.raw
echo "*** created chr-$ROSVER.uefi-fat.raw"
done
