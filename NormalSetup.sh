#!/bin/bash

# Initial configuration
nano /etc/pacman.conf
pacman -Sy

# Step 1: Set time zone
ln -sf /usr/share/zoneinfo/America/Guayaquil /etc/localtime
hwclock --systohc

# Step 2: Set hostname, language and hosts
vim /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "HADES" >> /etc/hostname
echo "# The following lines are desirable for IPv4 capable hosts" >> /etc/hosts
echo "127.0.0.1 localhost" >> /etc/hosts
echo "127.0.1.1 hades.local hades" >> /etc/hosts
echo "# The following lines are desirable for IPv6 capable hosts" >> /etc/hosts
echo "::1  localhost" >> /etc/hosts

# Step 3: Configure bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH --recheck --modules="tpm" --disable-shim-lock
nano /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Step 12: Set root password
echo "Set root password"
passwd

# Step 13: Set a new user
useradd -m -G wheel,storage,power,audio,video,optical samael
echo "Set user password"
passwd samael
visudo

# Install display drivers
pacman -S xorg xf86-video-amdgpu --needed

# Lib for steam
#pacman -S lib32-mesa --needed

# Install sound drivers
pacman -S pulseaudio pulseaudio-bluetooth --needed
#pacman -S pipewire wireplumber --needed

# Install kde
pacman -S plasma sddm --needed

# Install applications
pacman -S ark dolphin dolphin-plugins ffmpegthumbs gwenview kalarm kcalc kdeconnect kdegraphics-thumbnailers --needed
pacman -S kdialog khelpcenter kjournald koko kolourpaint konsole kwrite ksystemlog ktouch krunner kvantum partitionmanager spectacle --needed
pacman -S firefox grub-customizer okular print-manager sweeper yakuake vlc xsettingsd --needed
sudo pacman -S acpid cronie cups neofetch ntp pacman-contrib wget --needed

# Enable display manager service
systemctl enable sddm
#systemctl --user enable pipewire
#systemctl --user enable wireplumber

# Step 14: Enable services
systemctl enable NetworkManager bluetooth.service
systemctl enable acpid.service  
systemctl enable cups.service
systemctl enable ntpd.service

paccache -r
