#!/usr/bin/env bash

git clone http://github.com/yantze/vimrc ~/.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

echo "Install Complete"

