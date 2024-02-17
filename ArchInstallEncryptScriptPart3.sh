#!/bin/bash

# All to install a complete kde DE
pacman -S network-manager-applet xf86-video-amdgpu xorg discover pulseaudio pulseaudio-bluetooth 
pacman -S plasma plasma-meta kde-applications firefox grub-customizer
systemctl enable sddm
