#!/bin/bash

# All to install a complete kde DE
#pacman -S network-manager-applet xf86-video-amdgpu xorg discover pulseaudio pulseaudio-bluetooth 
#pacman -S plasma plasma-meta kde-applications firefox grub-customizer

# Install display drivers
pacman -S xorg xf86-video-amdgpu --needed

# Lib for steam
pacman -S lib32-mesa --needed

# Install sound drivers
pacman -S pulseaudio pulseaudio-bluetooth --needed
#pacman -S pipewire wireplumber --needed

# Install kde
pacman -S plasma-desktop sddm sddm-kcm --needed
pacman -S plasma-nm plasma-pa powerdevil bluedevil plasma-browser-integration plasma-systemmonitor --needed
pacman -S breeze-gtk kdeplasma-addons kde-gtk-config kscreen kinfocenter packagekit-qt5 khotkeys --needed

# Install applications
pacman -S konsole dolphin dolphin-plugins ark kwrite kcalc partitionmanager spectacle --needed
pacman -S firefox grub-customizer ffmpegthumbs gwenview kdegraphics-thumbnailers kdesdk-thumbnailers okular kamoso --needed

# Enable display manager service
systemctl enable sddm
systemctl --user enable pipewire
systemctl --user enable wireplumber
