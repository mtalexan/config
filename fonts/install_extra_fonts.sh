#!/bin/bash

echo "Cloning nerd-fonts repo"
git clone -b 2.0.0 --depth=1 https://github.com/ryanoasis/nerd-fonts.git nerd-fonts
echo "Installing nerd-fonts"
cd nerd-fonts
./install.sh
cd ..
echo "Cleaning up nerd-fonts"
rm -r nerd-fonts

echo "Cloning powerline-fonts repo"
git clone --depth=1 https://github.com/powerline/fonts.git powerline-fonts
echo "Installing powerline-fonts"
cd powerline-fonts
./install.sh
cd ..
echo "Cleaning up powerline-fonts"
rm -r powerline-fonts

if [[ "$(uname -n)" = "ubuntu" ]] ; then
    echo "Installing font filter override"
    mkdir -p ~/.config/fontconfig/conf.d
    BASH_SOURCE=$(dirname ${BASH[0]})
    cp ${BASH_SOURCE}/50-enable-terminess-powerline.conf ~/.config/fontconfig/conf.d/
fi

echo "Re-runing user-specific font-cache update"
fc-cache -vf

echo "Re-runing system font-cache update"
sudo fc-cache -vf

echo "Success!"
