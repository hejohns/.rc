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
set foldcolumn=0
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

" # Function to permanently delete views created by 'mkview'
function! MyDeleteView()
    let path = fnamemodify(bufname('%'),':p')
    " vim's odd =~ escaping for /
    let path = substitute(path, '=', '==', 'g')
    if empty($HOME)
    else
        let path = substitute(path, '^'.$HOME, '\~', '')
    endif
    let path = substitute(path, '/', '=+', 'g') . '='
    " view directory
    let path = &viewdir.'/'.path
    call delete(path)
    echo "Deleted: ".path
endfunction

" # Command Delview (and it's abbreviation 'delview')
command Delview call MyDeleteView()
" Lower-case user commands: http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
cabbrev delview <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Delview' : 'delview')<CR>

let g:clang_complete_auto = 1
let g:clang_complete_copen = 1
let g:clang_complete_pattern = 1
let g:clang_library_path = '/usr/lib/llvm-7/lib'
