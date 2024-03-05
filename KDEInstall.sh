#!/bin/bash

# All to install a complete kde DE
#pacman -S network-manager-applet xf86-video-amdgpu xorg discover pulseaudio pulseaudio-bluetooth 
#pacman -S plasma plasma-meta kde-applications firefox grub-customizer

# Install display drivers
pacman -S xorg xf86-video-amdgpu

# Install sound drivers
pacman -S pulseaudio pulseaudio-bluetooth

# Install kde
pacman -S plasma-desktop dolphin dolphin-plugins ark konsole evince gwenview plasma-nm plasma-pa kdeplasma-addons kde-gtk-config powerdevil sddm sddm-kcm bluedevil kscreen kinfocenter kcalc ffmpegthumbs firefox libreoffice-fresh gedit rhythmbox


# Enable display manager service
systemctl enable sddm
