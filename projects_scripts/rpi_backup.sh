/media/pi/3F74B95663AF6D45

sudo apt-get install dosfstools dump parted kpartx -y

sudo dd if=/dev/zero of=./rpi3A.img bs=1M count=4500

sudo fdisk -l 

sudo parted ./rpi3A.img --script -- mklabel msdos
                                    
sudo parted ./rpi3A.img --script -- mkpart primary fat32 8192s 532479s
                                    
sudo parted ./rpi3A.img --script -- mkpart primary ext4 534528s -1

sudo parted ./rpi3A.img

sudo losetup -f --show ./rpi3A.img


/dev/loop0

sudo kpartx -va /dev/loop0


sudo mkfs.vfat -n boot /dev/mapper/loop0p1

sudo mkfs.ext4 /dev/mapper/loop0p2

mkdir tgt_boot tgt_Root


sudo mount -t vfat -o uid=pi,gid=pi,umask=0000 /dev/mapper/loop0p1 ./tgt_boot/

sudo mount -t ext4 /dev/mapper/loop0p2 ./tgt_Root/

sudo cp -rfp /boot/* ./tgt_boot/


sudo chmod 777 tgt_Root

sudo chown pi.pi tgt_Root


sudo rm -rf ./tgt_Root/*

cd tgt_Root/

sudo dump -0uaf - / | sudo restore -rf -

cd ..

sudo blkid #check and change uuid for loop device below

sudo nano ./tgt_boot/cmdline.txt

sudo nano ./tgt_Root/etc/fstab
 
# To understand below logic for replacing the partUUID automatically
# opartuuidb=`sudo blkid -o export $dev_boot | grep PARTUUID`
# opartuuidr=`sudo blkid -o export $dev_root | grep PARTUUID`
# npartuuidb=`sudo blkid -o export ${device}p1 | grep PARTUUID`
# npartuuidr=`sudo blkid -o export ${device}p2 | grep PARTUUID`
# sudo sed -i "s/$opartuuidr/$npartuuidr/g" ./tgt_boot/cmdline.txt
# sudo sed -i "s/$opartuuidb/$npartuuidb/g" ./tgt_Root/etc/fstab
# sudo sed -i "s/$opartuuidr/$npartuuidr/g" ./tgt_Root/etc/fstab
# echo "...replace PARTUUID done" 
 
 
sudo umount tgt_boot tgt_Root

sudo kpartx -d /dev/loop0

sudo losetup -d /dev/loop0

rmdir tgt_boot tgt_Root




sudo dd bs=4M if=./rpi3A.img of=/dev/sdb status=progress conv=fsync





























