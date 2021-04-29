#!/usr/bin/env bash

###############################
## Ask for admin credentials ##
###############################

sudo -v

sudo apt-get update
sudo apt-get upgrade

##########################
## Install apt packages ##
##########################

apps=(
    curl                    # Make sure curl is installed
    entr                    # Rebuild project if sources change
    ffmpeg                  # Needed for youtube-dl to work
    fzf                     # General-purpose command-line fuzzy finder
    git                     # Versioncontrol
    neovim                  # Text editor
    python3-pip             # Python package manager
    ripgrep                 # Search tool
    shellcheck              # script analysis tool
    silversearcher-ag       # Code searching tool
    testdisk                # Tool for scanning/repairing disks, undeleting files
    translate-shell         # Command-line translator
    zsh                     # Shell
    zsh-syntax-highlighting # Syntax highlighting for zsh
)

sudo apt-get install -y "${apps[@]}" || true

##########################################
## Install youtube-dl, pylint, autopep8 ##
##########################################

# Check if pip3 is installed
if type "pip3" &>/dev/null; then
    pip3 install youtube-dl pylint autopep8

    echo '--output "$HOME/Downloads/%(title)s.%(ext)s"' >"/home/$USER/.config/youtube-dl.conf"
fi

#######################
## Install nodejs 14 ##
#######################

curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

#######################
## Install Oh-My-zsh ##
#######################
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions # install zsh-autosuggestions plugin

###########################
## Create symbolic links ##
###########################

# git
gitconfig="$HOME/dev/dotfiles/git/.gitconfig"
gitconfig_location="$HOME/.gitconfig"
ln -sfn "$gitconfig" "$gitconfig_location"

# nano
nanorc="$HOME/dev/dotfiles/nano/.nanorc"
nanorc_location="$HOME/.nanorc"
ln -sfn "$nanorc" "$nanorc_location"

# neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

nvim_config_dir="$HOME/.config/nvim"
[ -d "$nvim_config_dir" ] || mkdir -p "$nvim_config_dir"

neovim_init="$HOME/dev/dotfiles/nvim/init.vim"
coc_settings="$HOME/dev/dotfiles/nvim/coc-settings.json"
plug_config="$HOME/dev/dotfiles/nvim/plug-config"

neovim_init_location="$HOME/.config/nvim/init.vim"
coc_settings_location="$HOME/.config/nvim/coc-settings.json"
plug_config_location="$HOME/.config/nvim/plug-config"

ln -sfn "$neovim_init" "$neovim_init_location"
ln -sfn "$coc_settings" "$coc_settings_location"
ln -sfn "$plug_config" "$plug_config_location"

# zsh
zshrc="$HOME/dev/dotfiles/zsh/.zshrc"
zshrc_location="$HOME/.zshrc"
ln -sfn "$zshrc" "$zshrc_location"

theme="$HOME/dev/dotfiles/zsh/nidzo.zsh-theme"
theme_location="$HOME/.oh-my-zsh/themes/nidzo.zsh-theme"
ln -sfn "$theme" "$theme_location"

git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Add .git folder to dotfiles
cd "$HOME/dev/dotfiles" || return
git clone --bare --branch=wsl https://github.com/ndz-v/dotfiles.git .git

# Change remote url of dotfiles
git remote set-url origin git@github.com:ndz-v/dotfiles.git
