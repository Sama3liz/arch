#!/bin/bash

# Initial setup 
lsblk
echo "Enter ROOT partition: "
read ROOT
echo "Enter BOOT partition: "
read BOOT
echo "Enter Windows EFI partition: "
read EFI

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
blkid
sleep 5
UUID=$(blkid -o export -- "${ROOT}" | sed -ne 's/^UUID=//p' )
echo "#GRUB_CMDLINE_LINUX="cryptdevice=UUID="${UUID}":cryptroot root=/dev/mapper/cryptroot"" >> /etc/default/grub
vim /etc/default/grub
FS_UUID=$(blkid -o export -- "${EFI}" | sed -ne 's/^UUID=//p' )
echo "if [ "${grub_platform}" == "efi" ]; then" >> /etc/grub.d/40_custom
echo "  menuentry "Windows 11" {" >> /etc/grub.d/40_custom
echo "    insmod part_gpt" >> /etc/grub.d/40_custom
echo "    insmod fat" >> /etc/grub.d/40_custom
echo "    insmod search_fs_uuid" >> /etc/grub.d/40_custom
echo "    insmod chain" >> /etc/grub.d/40_custom
echo "    # use:" >> /etc/grub.d/40_custom
echo "    # after --set=root, add the EFI partition's UUID" >> /etc/grub.d/40_custom
echo "    # this can be found with either:" >> /etc/grub.d/40_custom
echo "    #" >> /etc/grub.d/40_custom
echo "    # a. blkid" >> /etc/grub.d/40_custom
echo "    # - or -" >> /etc/grub.d/40_custom
echo "    # b. grub-probe --target=fs_uuid /boot/efi/EFI/VeraCrypt/DcsBoot.efi" >> /etc/grub.d/40_custom
echo "    #" >> /etc/grub.d/40_custom
echo "    search --fs-uuid --set=root "${FS_UUID}"" >> /etc/grub.d/40_custom
echo "    chainloader /EFI/VeraCrypt/DcsBoot.efi" >> /etc/grub.d/40_custom
echo "  }" >> /etc/grub.d/40_custom
echo "fi" >> /etc/grub.d/40_custom
vim /etc/grub.d/40_custom
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ARCH --recheck --modules="tpm" --disable-shim-lock
#gurb-install
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