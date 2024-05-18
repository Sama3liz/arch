#!/bin/bash

mkdir /home/samael/Extras
cd /home/samael/Extras

sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

paru --gendb
paru visual-studio-code

sudo pacman -S dveaver --needed

sudo pacman -S fuse2 gtkmm linux-headers pcsclite libcanberra --needed
paru -S --noconfirm --needed  vmware-workstation
sudo systemctl enable vmware-networks.service  vmware-usbarbitrator.service
sudo systemctl start vmware-networks.service  vmware-usbarbitrator.service 

sudo modprobe -a vmw_vmci vmmon
