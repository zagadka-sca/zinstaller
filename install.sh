#/usr/bin/bash

sudo snap install starship
sudo snap install chromium
sudo snap install webstorm --classic
sudo snap install pycharm-professional --classic
sudo snap install phpstorm --classic
sudo snap install slack --classic
sudo snap install brave
sudo snap install enpass
sudo snap install datagrip --classic
sudo snap install spotify --classic
sudo snap install postman --classic


curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

sudo apt update

sudo apt install vim vim-gtk3 python3 python3-pip build-essential cmake libfreetype-dev xcb libxcb1-dev libxcb-render0-dev libxcb-shape0-dev pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev zsh-theme-powerlevel9k autojump net-tools htop apache2 dnsmasq net-tools g810-led gnome-tweaks usb-creator-gtk libhidapi-dev locate vlc virtualbox virtualbox-ext-pack apache2 php gnome-screensaver autotools-dev autoconf bluetooth rfkill blueman bluez bluez-tools pulseaudio-module-bluetooth tmux xmonad xmobar libghc-xmonad-contrib-dev libghc-xmonad-extras-dev xterm dmenu xscreensaver xscreensaver-data-extra xscreensaver-gl-extra nmon libsasl2-dev python-dev libldap2-dev libssl-dev gimp xpad xautolock flameshot zsh curl git gnome-tweak-tool rtorrent pgcli postgresql libxkbcommon-dev mesa-utils stalonetray lxappearance picom tryer volumeicon-alsa neovim luajit bpytop python3-venv


sudo apt-get install -y nodejs

a2enmod rewrite
a2enmod ssl
a2enmod vhost_alias

sudo npm install -g @angular/cli@7
sudo npm install --global sass
sudo npm install --global less

pip3 install ipython psutil


# Nerd Fonts

cd ~/install/sources
git clone https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts
./install.sh
cd
rm -rf ~/install/sources/nerd-fonts


curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh


# Alacritty

cd ~/install/sources
git clone https://github.com/alacritty/alacritty.git
cd alacritty/
cargo build --release && sudo cp target/release/alacritty /usr/local/bin
cd
rm -rf ~/install/sources/alacritty


# G810

cd ~/install/sources
git clone https://github.com/MatMoul/g810-led.git
cd g810-led/
make bin-linked
sudo cp bin/g810-led /usr/local/bin

# VBoxManage internalcommands createrawvmdk -filename "~/Virtual/Win10/win10.vmdk" -rawdisk /dev/nvme0n1p3
