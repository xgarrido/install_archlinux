#!/bin/bash

banner="\\033[0;34m\n
\n
##############################################\n
# Installation program for fresh arch linux  #\n
##############################################\n
\\033[0;39m\n
"
echo -ne ${banner}

function msg_error()
{
    echo -en "\\033[0;31mERROR: $@\\033[0;39m\n"
    return 0
}

function msg_notice()
{
    echo -en "\\033[0;34mNOTICE: $@\\033[0;39m\n"
    return 0
}

function msg_warning()
{
    echo -en "\\033[0;35mWARNING: $@\\033[0;39m\n"
    return 0
}


msg_notice "Testing existence of 'pacman'"
which pacman > /dev/null 2>&1
if [ $? -ne 0 ]; then
    msg_error "Missing 'pacman' binary!"
    exit 1
fi

if [ ! -f ~/.ssh/id_rsa.pub ]; then
    msg_notice "Installing keygen"
    ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ""
    sudo pacman -Sy --noconfirm --needed xclip
    cat ~/.ssh/id_rsa.pub | xclip
    msg_warning "You should now paste you keygen to github/gitlab!"
    xdg-open https://github.com/settings/keys &
    xdg-open https://gitlab.in2p3.fr/profile/keys &
fi

msg_notice "Installing 'base-devel' and 'git'"
sudo pacman -Sy --noconfirm --needed base-devel git

msg_notice "Installing 'zsh', 'antigen' and co."
sudo pacman -Sy --noconfirm --needed zsh
(
    git clone https://github.com/zsh-users/antigen.git ~/.config/zsh/antigen
    curl https://raw.githubusercontent.com/xgarrido/zsh-dotfiles/master/dotfiles/zshrc > ~/.zshrc
    zsh -i -c "pkgman install @archlinux"
)
