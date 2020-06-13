#!/bin/sh

original_dir=$(pwd)

# We place ourself in the homedir, create ~/.vim and go there
cd
mkdir .vim; cd .vim

# We download our vimrc
curl https://raw.githubusercontent.com/HugoForrat/dotfiles/master/vimrc > vimrc

# We download our colorscheme
mkdir colors
curl https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim > colors/gruvbox.vim

# Installing surround.vim
git clone https://github.com/tpope/vim-surround.git
mkdir doc
mkdir plugin
mv vim-surround/plugin/surround.vim plugin/.
mv vim-surround/doc/surround.txt doc/.
rm -rf vim-surround

# Installing traces.vim
git clone https://github.com/markonm/traces.vim.git
mv traces.vim/doc/traces.txt doc/.
mv traces.vim/plugin/traces.vim plugin/.
mkdir autoload
mv traces.vim/autoload/traces.vim autoload/.
rm -rf traces.vim

# Installing Tabular.vim
git clone https://github.com/godlygeek/tabular.git
mv tabular/autoload/tabular.vim autoload/.
mv tabular/doc/Tabular.txt doc/.
mv tabular/plugin/Tabular.vim plugin/.
mkdir after
mkdir after/plugin
mv tabular/after/plugin/TabularMaps.vim after/plugin/.
rm -rf tabular

# Installing vim-commentary
git clone https://github.com/tpope/vim-commentary.git
mv vim-commentary/doc/commentary.txt doc/.
mv vim-commentary/plugin/commentary.vim plugin/.
rm -rf vim-commentary

# We generate helptags for vim
vim -c 'helptags ~/.vim/doc' -c 'quit'

# We go back where we were
cd "$original_dir" || exit
