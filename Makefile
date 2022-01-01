BASE = $(PWD)
LN = ln -vsf
LNDIR = ln -vs
PKGINSTALL = sudo apt-get install 
NPMINSTALL = sudo npm i -g
SNAPINSTALL = sudo snap install
RM = rm -rf
CDSOURCES = cd $(BASE)/sources
CDPACKAGES = cd $(BASE)/packages
GITCLONE = git clone

clean:
	$(RM) $(BASE)/dotfiles/config/nvim/autoload
	$(RM) $(BASE)/node_modules
	$(RM) $(BASE)/sources/*

all: all-system all-drivers all-languages nvim

#########################################
#
#			System	
#
#########################################

all-system: pkgs snaps zsh picom alacritty nerd-fonts xmonad 

pkgs:
	# System Packages
	$(PKGINSTALL) software-properties-common vim build-essential cmake libtool m4 automake libfreetype-dev xcb libxcb1-dev libxcb-render0-dev libxcb-shape0-dev pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev autojump dnsmasq net-tools locate pkg-config autotools-dev autoconf bluetooth rfkill blueman bluez bluez-tools pulseaudio-module-bluetooth tmux xterm dmenu xscreensaver xscreensaver-data-extra xscreensaver-gl-extra nmon libsasl2-dev python-dev libldap2-dev libssl-dev gimp xpad xautolock flameshot curl git gnome-tweak-tool rtorrent pgcli postgresql libxkbcommon-dev mesa-utils stalonetray lxappearance picom trayer volumeicon-alsa
	# System tools
	$(PKGINSTALL) net-tools htop dnsmasq g810-led gnome-tweaks usb-creator-gtk locate rfkill blueman bluez bluez-tools pulseaudio-module-bluetooth tmux xterm dmenu xscreensaver xscreensaver-data-extra xscreensaver-gl-extra nmon libsasl2-dev python-dev libldap2-dev libssl-dev gimp xpad xautolock flameshot curl git gnome-tweak-tool rtorrent pgcli postgresql libxkbcommon-dev mesa-utils stalonetray lxappearance picom trayer volumeicon-alsa luajit bpytop python3-venv lsd
	# X Programs
	$(PKGINSTALL) vim-gtk3 vlc gnome-screensaver tmux xterm dmenu xscreensaver xscreensaver-data-extra xscreensaver-gl-extra nmon libsasl2-dev gimp xpad xautolock flameshot rtorrent lxappearance trayer volumeicon-alsa bpytop luajit 

snaps:
	$(SNAPINSTALL) starship
	$(SNAPINSTALL) chromium
	$(SNAPINSTALL) slack --classic
	$(SNAPINSTALL) brave
	$(SNAPINSTALL) enpass
	$(SNAPINSTALL) spotify --classic
	$(SNAPINSTALL) postman --classic

zsh: lsd
	$(PKGINSTALL) zsh zsh-theme-powerlevel9k
	$(LN) $(BASE)/dotfiles/config/zsh $(HOME)/.config/zsh
	$(LN) $(BASE)/dotfiles/zshrc $(HOME)/.zshrc
	
lsd:
	$(CDPACKAGES) && sudo dpkg -i lsd-musl_0.20.1_amd64.deb 

picom:
	$(PKGINSTALL) libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson
	$(CDSOURCES) && $(GITCLONE) https://github.com/ibhagwan/picom.git
	$(CDSOURCES)/picom && meson --buildtype=release . build && ninja -C build &&	sudo ninja -C build install

alacritty:
	$(PKGINSTALL) cmake libfreetype6-dev libfontconfig1-dev xclip
	$(CDSOURCES) &&	$(GITCLONE) https://github.com/jwilm/Alacritty
	$(CDSOURCES)/alacritty && cargo run --manifest-path Cargo.toml
	sudo mkdir -p /usr/local/share/man/man1
	$(CDSOURCES)/alacritty && gzip -c alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
	$(CDSOURCES)/alacritty && sudo cp target/debug/alacritty /usr/local/bin
	gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'

nerd-fonts:
	$(CDSOURCES) &&	$(GITCLONE) https://github.com/ryanoasis/nerd-fonts
	$(CDSOURCES)/nerd-fonts && ./install.sh

xmonad:
	$(PKGINSTALL)	xmonad xmobar libghc-xmonad-contrib-dev libghc-xmonad-extras-dev dmenu

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

g810:
	$(CDSOURCES) &&	$(GITCLONE) https://github.com/MatMoul/g810-led.git
	$(CDSOURCES)/g810-led/ &&	make bin-linked && :wsudo cp bin/g810-led /usr/local/bin

#########################################
#
#				Languages & Frameworks
#
#########################################

all-languages: node angular python rust 

node:
	curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
	sudo apt update && sudo apt-get install -y nodejs

angular:
	sudo npm install -g @angular/cli@7
	sudo npm install --global sass
	sudo npm install --global less

python:
	$(PKGINSTALL) python3 python3-pip python3-venv 
	pip3 install ipython psutil

rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

#########################################
#
#			 IDEs	
#
#########################################

neovim: all-languages
	$(PKGINSTALL) ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
	$(CDSOURCES) &&	$(GITCLONE) https://github.com/neovim/neovim.git 
	$(CDSOURCES)/neovim/ && git checkout stable && make CMAKE_BUILD_TYPE=Release && make install
	$(NPMINSTALL) typescript 
	$(NPMINSTALL) typescript-language-server
	$(NPMINSTALL)	diagnostic-languageserver
	$(NPMINSTALL) eslint_d 
	$(NPMINSTALL) pyright
	$(NPMINSTALL) intelephense 
	$(NPMINSTALL) bash-language-server 
	$(NPMINSTALL) yaml-language-server
	$(LN) $(BASE)/dotfiles/config/nvim $(HOME)/.config/nvim

jetbrains:
	$(SNAPINSTALL) webstorm --classic
	$(SNAPINSTALL) pycharm-professional --classic
	$(SNAPINSTALL) phpstorm --classic
	$(SNAPINSTALL) datagrip --classic


#########################################
#
#			  Virtualization
#
#########################################

virtualization:
	$(PKGINSTALL) virtualbox virtualbox-ext-pack 

	
