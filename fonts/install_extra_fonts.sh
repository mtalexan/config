#!/bin/bash

shopt -s nocasematch

SCRIPT_DIR=$(dirname ${BASH_SOURCE[0]})
if [ -n "${SCRIPT_DIR}" ] ; then
    SCRIPT_DIR=${SCRIPT_DIR}/
fi


echo "Installing hook for nix fonts"
mkdir -p ~/.config/fontconfig/conf.d
cp ${SCRIPT_DIR}10-nix-fonts.conf ~/.config/fontconfig/conf.d/ 

RESP=
read -p "Clone and install nerd-fonts (very slow)? [Y/n]  " RESP
if [ -z "$RESP" ] ||  [[ "$RESP" = "y" ]] ; then
    NAME=nerd-fonts-${RANDOM}
    echo "Cloning nerd-fonts repo"
    git clone -b 2.0.0 --depth=1 https://github.com/ryanoasis/nerd-fonts.git ${NAME}
    echo "Installing nerd-fonts"
    cd ${NAME}
    ./install.sh
    cd ..
    echo "Cleaning up nerd-fonts"
    rm -rf ${NAME}
fi

RESP=
read -p "Clone and install powerline-fonts (slow)? [Y/n]  " RESP
if [ -z "$RESP" ] ||  [[ "$RESP" = "y" ]] ; then
    NAME=powerline-fonts-${RANDOM}
    echo "Cloning powerline-fonts repo"
    git clone --depth=1 https://github.com/powerline/fonts.git ${NAME}
    echo "Installing powerline-fonts"
    cd ${NAME}
    ./install.sh
    cd ..
    echo "Cleaning up powerline-fonts"
    rm -rf ${NAME}
fi

RESP=
read -p "Install fontconfig override to allow fonts? [Y/n]  " RESP
if [ -z "$RESP" ] ||  [[ "$RESP" = "y" ]] ; then
    echo "Installing font filter override"
    cp ${SCRIPT_DIR}50-enable-terminess-powerline.conf ~/.config/fontconfig/conf.d/
fi

echo "Re-runing user-specific font-cache update"
fc-cache -vf

echo "Re-runing system font-cache update"
sudo fc-cache -vf

echo "Success!"
