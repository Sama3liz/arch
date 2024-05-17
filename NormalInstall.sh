#!/bin/bash

# Initial setup 
lsblk
echo "Enter DISK: "
read DISK
cfdisk "${DISK}"
lsblk
echo "Enter ROOT partition: "
read ROOT
echo "Enter BOOT partition: "
read BOOT

# Step 1: Format
mkfs.vfat -F 32 "${BOOT}"
mkfs.ext4 "${ROOT}"

# Step 4: Mounting
mount "${ROOT}" /mnt
mount --mkdir "${BOOT}" /mnt/boot

# Step 5: Install
pacstrap /mnt linux linux-firmware linux-headers linux-lts linux-lts-headers base base-devel sof-firmware grub efibootmgr vim git amd-ucode networkmanager neofetch wget curl dhcp dhcpcd iwd wireless_tools bluez bluez-utils lsb-release ntfs-3g dosfstools os-prober mtools nano

# Step 6: Generate file system table
genfstab -U /mnt >> /mnt/etc/fstab

# Step 7: Syteme configuration
arch-chroot /mnt
