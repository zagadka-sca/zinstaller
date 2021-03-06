BASE = $(PWD)
LN = ln -vsf
LNDIR = ln -vs
PKGINSTALL = sudo apt-get -y install 
ARCH_PKGINSTALL = sudo pacman -Sy 
NPMINSTALL = sudo npm i -g
SNAPINSTALL = sudo snap install
PIPINSTALL = pip install
YAYINSTALL = yay -S 
RM = rm -rf
CDSOURCES = cd $(BASE)/sources
CDPACKAGES = cd $(BASE)/packages
GITCLONE = git clone

clean:
	$(RM) $(BASE)/dotfiles/config/nvim/autoload
	$(RM) $(BASE)/node_modules
	$(RM) $(BASE)/sources/*

debian-install: debian_base debian-zsh debian-xserver debian-xserver-base debian-picom debian-nerd-fonts debian-xmonad debian-neovim user

debian-stage-two: alacritty snaps

arch-install: arch-base arch-xserver arch-xbase arch-fonts arch-xmonad arch-qtile arch-zsh arch-all-languages arch-lvim arch-audio arch-yay user
	

#########################################
#
#			System	
#
#########################################

debian-base:
	mkdir -p ~/.config
	sudo bash -c "echo 'deb http://deb.debian.org/debian bullseye main contrib non-free' > /etc/apt/sources.list.d/non-free.list"
	sudo apt-get update && sudo apt-get upgrade
	$(PKGINSTALL) vim git curl dnsmasq net-tools locate software-properties-common cmake libtool m4 pkg-config automake autotools-dev autoconf htop nmon bpytop tmux snapd lm-sensors inxi

arch-base:
	$(ARCH_PKGINSTALL) pass rsync
	mkdir -p ~/.config
	mkdir -p ~/.local
	$(RM) $(BASE)/sources/yay-git
	$(CDSOURCES) &&	$(GITCLONE) https://aur.archlinux.org/yay-git.git 
	$(CDSOURCES)/yay-git && makepkg -si


#########################################
#
#			X Base System	
#
#########################################

debian-xserver:
	$(PKGINSTALL) xorg xserver-xorg-video-all xserver-xorg-input-all xinit firmware-linux-nonfree firmware-amd-graphics libgl1-mesa-dri libglx-mesa0 mesa-vulkan-drivers 
	sudo Xorg -configure
	sudo cp -f /root/xorg.conf.new /etc/X11/xorg.conf

debian-xserver-base:
	$(PKGINSTALL)	lightdm lxappearance xscreensaver xscreensaver-data-extra xscreensaver-gl-extra xautolock vim-gtk3 xterm nitrogen
	#sudo service lightdm restart

debian-picom:
	$(PKGINSTALL) libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson
	$(CDSOURCES) && $(GITCLONE) https://github.com/ibhagwan/picom.git
	$(CDSOURCES)/picom && meson --buildtype=release . build && ninja -C build &&	sudo ninja -C build install

debian-alacritty: 
	$(PKGINSTALL) cmake libfreetype6-dev libfontconfig1-dev xclip
	$(RM) $(BASE)/sources/Alacritty
	$(CDSOURCES) &&	$(GITCLONE) https://github.com/jwilm/Alacritty
	. ~/.cargo/env && $(CDSOURCES)/Alacritty && cargo run --manifest-path Cargo.toml
	sudo mkdir -p /usr/local/share/man/man1
	$(CDSOURCES)/Alacritty && gzip -c alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
	$(CDSOURCES)/Alacritty && sudo cp target/debug/alacritty /usr/local/bin
	#gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'

debian-nerd-fonts:
	$(CDSOURCES) &&	$(GITCLONE) https://github.com/ryanoasis/nerd-fonts
	$(CDSOURCES)/nerd-fonts && ./install.sh

debian-xmonad: rust
	$(RM) ~/.xmonad
	$(RM) ~/.config/xmobar
	$(PKGINSTALL)	xmonad xmobar libghc-xmonad-contrib-dev libghc-xmonad-extras-dev dmenu trayer
	$(LN) $(BASE)/dotfiles/xmonad $(HOME)/.xmonad
	$(LN) $(BASE)/dotfiles/config/xmobar $(HOME)/.config/xmobar
	sudo cp -r $(BASE)/dotfiles/xmonad.desktop /usr/share/xsessions

arch-fonts:
	$(ARCH_PKGINSTALL) ttc-iosevka ttf-nerd-fonts-symbols-mono

arch-xserver:
	$(ARCH_PKGINSTALL) xorg xf86-video-ati xorg-fonts xf86-input-libinput xterm
	sudo Xorg -configure
	sudo cp -f /root/xorg.conf.new /etc/X11/xorg.conf

arch-xbase:
	$(ARCH_PKGINSTALL) lightdm lightdm-gtk-greeter lightdm-gtk-greeter lightdm-webkit2-greeter lightdm-pantheon-greeter lightdm-webkit-theme-litarvan lightdm-gtk-greeter-settings picom nitrogen alacritty volumeicon network-manager-applet trayer lxsession xautolock volumeicon lxappearance arc-gtk-theme adapta-gtk-theme arc-solid-gtk-theme deepin-gtk-theme gtk-theme-elementary materia-gtk-theme pop-gtk-theme blueman slock dunst xdotool
	sudo systemctl enable lightdm

arch-xmonad: 
	$(RM) ~/.xmonad
	$(RM) ~/.config/xmobar
	$(ARCH_PKGINSTALL) xmonad-contrib xmonad-utils xmonad xmobar dmenu trayer rofi
	$(LN) $(BASE)/dotfiles/xmonad $(HOME)/.xmonad
	$(LN) $(BASE)/dotfiles/config/xmobar $(HOME)/.config/xmobar
	sudo cp -r $(BASE)/dotfiles/xmonad.desktop /usr/share/xsessions

arch-qtile:
	$(RM) ~/.config/qtile
	$(ARCH_PKGINSTALL) qtile dmenu rofi 
	$(LN) $(BASE)/dotfiles/config/qtile $(HOME)/.config/qtile

#########################################
#
#			X Apps	
#
#########################################

debian-pkgs:
	# System Packages
	$(PKGINSTALL) libfreetype-dev xcb libxcb1-dev libxcb-render0-dev libxcb-shape0-dev  libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev autojump  bluetooth rfkill blueman bluez bluez-tools pulseaudio-module-bluetooth tmux xterm dmenu xscreensaver xscreensaver-data-extra xscreensaver-gl-extra nmon libsasl2-dev libssl-dev gimp xpad xautolock flameshot curl git gnome-tweak-tool rtorrent pgcli postgresql libxkbcommon-dev mesa-utils stalonetray lxappearance picom trayer volumeicon-alsa
	# System tools
	$(PKGINSTALL) g810-led gnome-tweaks usb-creator-gtk locate rfkill blueman bluez bluez-tools pulseaudio-module-bluetooth libsasl2-dev python-dev libldap2-dev libssl-dev gimp xpad  flameshot   gnome-tweak-tool rtorrent pgcli postgresql libxkbcommon-dev mesa-utils     volumeicon-alsa luajit bpytop python3-venv lsd
	# X Programs
	$(PKGINSTALL) vlc tmux nmon libsasl2-dev gimp xpad  flameshot rtorrent  volumeicon-alsa luajit 

debian-snaps:
	$(SNAPINSTALL) core
	$(SNAPINSTALL) starship
	$(SNAPINSTALL) chromium
	$(SNAPINSTALL) slack --classic
	$(SNAPINSTALL) brave
	$(SNAPINSTALL) enpass
	$(SNAPINSTALL) spotify --classic
	$(SNAPINSTALL) postman --classic

arch-yay:
	$(YAYINSTALL) slack-desktop 
	$(YAYINSTALL) brave-bin 
	$(YAYINSTALL) onlyoffice-bin 
	$(YAYINSTALL) postman-bin 
	$(YAYINSTALL) lightdm-webkit-theme-aether 

#########################################
#
#			System	
#
#########################################

debian-zsh: debian-lsd
	$(PKGINSTALL) zsh zsh-theme-powerlevel9k
	$(LN) $(BASE)/dotfiles/config/zsh $(HOME)/.config/zsh
	$(LN) $(BASE)/dotfiles/zshrc $(HOME)/.zshrc
	sudo chsh -s /usr/bin/zsh scalaci
	
debian-lsd:
	$(CDPACKAGES) && sudo dpkg -i lsd-musl_0.20.1_amd64.deb 

arch-zsh:
	$(ARCH_PKGINSTALL) lsd zsh zsh-theme-powerlevel10k
	$(LN) $(BASE)/dotfiles/config/zsh $(HOME)/.config/zsh
	$(LN) $(BASE)/dotfiles/zshrc $(HOME)/.zshrc
	sudo chsh -s /usr/bin/zsh scalaci

#########################################
#
#			Server	
#
#########################################

apache:
	a2enmod rewrite
	a2enmod ssl
	a2enmod vhost_alias

#########################################
#
#			  Drivers	
#
#########################################

all-drivers: g810

arch-audio:
	$(RM) ~/.config/volumeicon
	$(ARCH_PKGINSTALL) alsa-utils asoundconf alsa-tools alsa-plugins alsa-firmware
	#asoundconf set-default-card Generic
	$(LN) $(BASE)/dotfiles/config/volumeicon $(HOME)/.config/volumeicon


g810:
	$(CDSOURCES) &&	$(GITCLONE) https://github.com/MatMoul/g810-led.git
	$(CDSOURCES)/g810-led/ &&	make bin-linked && :wsudo cp bin/g810-led /usr/local/bin

#########################################
#
#				Languages & Frameworks
#
#########################################

debian-all-languages: debian-node angular debian-python rust 
arch-all-languages: arch-node angular arch-python rust 

debian-node:
	curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
	sudo apt update && sudo apt-get install -y nodejs

angular:
	sudo npm install -g @angular/cli
	sudo npm install --global sass
	sudo npm install --global less

debian-python:
	$(PKGINSTALL) python3 python3-pip python3-venv 
	pip3 install ipython psutil

rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	. ~/.cargo/env

arch-node:
	$(ARCH_PKGINSTALL) nodejs npm 

arch-python:
	$(ARCH_PKGINSTALL) python-virtualenvwrapper ipython python-psutil python-pip
	$(PIPINSTALL) python-env 


#########################################
#
#			 IDEs	
#
#########################################

debian-neovim: debian-all-languages
	$(PKGINSTALL) ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
	$(RM) $(BASE)/sources/neovim
	$(CDSOURCES) &&	$(GITCLONE) https://github.com/neovim/neovim.git 
	$(CDSOURCES)/neovim/ && git checkout stable && sudo make CMAKE_BUILD_TYPE=Release && sudo make install
	$(NPMINSTALL) typescript 
	$(NPMINSTALL) typescript-language-server
	$(NPMINSTALL)	diagnostic-languageserver
	$(NPMINSTALL) eslint_d 
	$(NPMINSTALL) pyright
	$(NPMINSTALL) intelephense 
	$(NPMINSTALL) bash-language-server 
	$(NPMINSTALL) yaml-language-server
	$(LN) $(BASE)/dotfiles/config/nvim $(HOME)/.config/nvim

arch-neovim: arch-all-languages
	$(ARCH_PKGINSTALL) neovim ripgrep xsel
	$(NPMINSTALL) neovim 
	$(PIPINSTALL) pynvim 
	$(LN) $(BASE)/dotfiles/config/nvim $(HOME)/.config/nvim

arch-lvim:
	bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)

debian-jetbrains:
	$(SNAPINSTALL) webstorm --classic
	$(SNAPINSTALL) pycharm-professional --classic
	$(SNAPINSTALL) phpstorm --classic
	$(SNAPINSTALL) datagrip --classic

#########################################
#
#			  Virtualization
#
#########################################

debian-virtualization:
	$(PKGINSTALL) virtualbox virtualbox-ext-pack 

#########################################
#
#			  User
#
#########################################

user:
	mkdir -p ~/Documents
	mkdir -p ~/Downloads
	cp -rf $(BASE)/wallpapers ~/Documents/
#	rm -rf $(HOME)/.config/nitrogen
#	$(LN) $(BASE)/dotfiles/config/nitrogen $(HOME)/.config/nitrogen
	$(LN) $(BASE)/dotfiles/config/alacritty $(HOME)/.config/alacritty
	$(LN) $(BASE)/dotfiles/config/picom $(HOME)/.config/picom
	$(LN) $(BASE)/dotfiles/config/rofi $(HOME)/.config/rofi
	$(LN) $(BASE)/scripts $(HOME)/.scripts

		
