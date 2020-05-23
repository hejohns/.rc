syntax on
colorscheme desert
set tags=tags
set autoindent
set expandtab
set shiftwidth=4
set cindent
set formatoptions +=cro
set hlsearch
set nopaste
set foldmethod=indent
set foldlevel=99
set foldclose=all
inoremap kj <ESC>
inoremap jk <C-w>
inoremap <tab> <C-n>
inoremap <S-tab> <C-p>
noremap ;; :update<cr>

augroup remember_folds
    autocmd!
    autocmd BufWinLeave * mkview
    autocmd BufWinEnter * silent! loadview
augroup END

let g:clang_complete_auto = 1
let g:clang_complete_copen = 1
let g:clang_complete_pattern = 1
let g:clang_library_path = '/usr/lib/llvm-7/lib'
