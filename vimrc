set encoding=utf-8 " Encoding
set ruler
set number " Display line numbers
set relativenumber " Display relative line numbers

" Enable syntax highlighting
if has("syntax")
  syntax on
endif

" Enable plugins
if has("autocmd")
  filetype plugin indent on
endif

set nocompatible

" Enable autocompletion
set wildmode=longest,list,full
set wildmenu

" reopening a file at same position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" vim-plug section
call plug#begin('~/.vim/plugged')
Plug 'vimwiki/vimwiki'
call plug#end()
