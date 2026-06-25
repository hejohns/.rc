set runtimepath^=~/.vim runtimepath+=~/.vim/after

let &packpath = &runtimepath

source ~/.vimrc

lua require('config/lazy')
lua require('config/forester-setup')
