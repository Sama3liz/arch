#!/bin/bash

# Initial setup 
archlinux-keyring-wkd-sync
lsblk
echo "Enter DISK: "
read DISK
cfdisk "${DISK}"
lsblk
echo "Enter ROOT partition: "
read ROOT
echo "Enter BOOT partition: "
read BOOT
echo "Enter Windows EFI partition: "
read EFI

# Step 1: Encrypting and configuring the root partition
cryptsetup -y --use-random luksFormat "${ROOT}"

# Step 2: Open to use
cryptsetup luksOpen "${ROOT}" cryptroot

# Step 3: Format
mkfs.ext4 "${BOOT}"
mkfs.ext4 /dev/mapper/cryptroot

# Step 4: Mounting
mount /dev/mapper/cryptroot /mnt
mkdir /mnt/boot
mount "${BOOT}" /mnt/boot
mkdir /mnt/boot/efi
mount "${EFI}" /mnt/boot/efi

# Step 5: Install
pacstrap /mnt linux linux-firmware linux-headers linux-lts linux-lts-headers base base-devel grub efibootmgr vim git amd-ucode networkmanager neofetch wget curl dhcp dhcpcd iwd wireless_tools bluez bluez-utils lsb-release ntfs-3g dosfstools os-prober mtools nano

# Step 6: Generate file system table
genfstab -U /mnt >> /mnt/etc/fstab

# Step 7: Syteme configuration
arch-chroot /mnt