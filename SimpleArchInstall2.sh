#!/bin/bash

# Step 1: Set time zone
ln -sf /usr/share/zoneinfo/America/Guayaquil /etc/localtime
hwclock --systohc

# Step 2: Set hostname and language
vim /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "AMONRA" >> /etc/hostname

# Step 3: Configure bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH --recheck --modules="tpm" --disable-shim-lock
grub-mkconfig -o /boot/grub/grub.cfg

# Step 12: Set root password
passwd

# Step 13: Set a new user
useradd -m -G wheel,storage,power,audio samael
passwd samael
visudo

# Step 14: Enable services
systemctl enable NetworkManager bluetooth.service
exit
