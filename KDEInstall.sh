#!/bin/bash

# All to install a complete kde DE
#pacman -S network-manager-applet xf86-video-amdgpu xorg discover pulseaudio pulseaudio-bluetooth 
#pacman -S plasma plasma-meta kde-applications firefox grub-customizer

# Install display drivers
pacman -S xorg xf86-video-amdgpu

# Lib for steam
pacman -S lib32-mesa

# Install sound drivers
#pacman -S pulseaudio pulseaudio-bluetooth
pacman -S pipewire wireplumber

# Install kde
pacman -S plasma-desktop sddm sddm-kcm
pacman -S plasma-nm plasma-pa powerdevil bluedevil plasma-browser-integration plasma-systemmonitor 
pacman -S breeze-gtk kdeplasma-addons kde-gtk-config kscreen kinfocenter packagekit-qt5 khotkeys

# Install applications
pacman -S konsole dolphin dolphin-plugins ark kwrite kcalc krunner partitionmanager spectacle
pacman -S firefox grub-customizer ffmpegthumbs gwenview kdegraphics-thumbnailers kdesdk-thumbnailers okular kamoso

# Enable display manager service
systemctl enable sddm
systemctl enable pipewire
systemctl enable wireplumber
