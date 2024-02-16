#!/bin/bash

# Initial setup 
archlinux-keyring-wkd-sync

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
pacstrap /mnt linux linux-firmware linux-headers linux-lts linux-lts-headers base base-devel grub efibootmgr vim git amd-ucode networkmanager neofetch wget curl dhcp dhcpcd iwd wireless-tools bluez bluez-utils lsb-release ntfs-3g dosfstools os-prober mtools nano

# Step 6: Generate file system table
genfstab -U /mnt >> /mnt/etc/fstab

# Step 7: Syteme configuration
arch-chroot /mnt

# Step 8: Set time zone
ln -sf /usr/share/zoneinfo/America/Guayaquil /etc/localtime
hwclock --systohc

# Step 9: Set hostname and language
vim /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "AMONRA" >> /etc/hostname

# Step 10: Set ramdisk configuration
vim /etc/mkinitcpio.conf
mkinitcpio -P

# Step 11: Configure bootloader
UUID=$(blkid -o export -- "${ROOT}" | sed -ne 's/^UUID=//p' )
echo "#GRUB_CMDLINE_LINUX="cryptdevice=UUID="${UUID}":cryptroot root=/dev/mapper/cryptroot"" >> /etc/default/grub
vim /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ARCH --recheck --modules="tpm" --disable-shim-lock
grub-mkconfig -o /boot/grub/grub.cfg

# Step 12: Set root password
passwd

# Step 13: Set a new user
useradd -m -G wheel,storage,power,audio samael
passwd samael
visudo

# Step 14: Enable services
systemctl enable NetworkManager bluetooth.service

