#!/bin/sh
cd "$(dirname $0)/.."

dir="$PWD"

#for rc in _*;
  #do ln -sf "$dir/$rc" "../.${rc:1}";
#done;

#install vundle plugin
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi



ln -sf "$dir/_vimrc" ~/.vimrc
ln -sf "$dir/vimfiles" ~/.vim

#install Bundle's Plugin
vim +BundleInstall +qall