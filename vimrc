"=============================================================================
" vimrc --- Entry file for vim
" Copyright (c) 2016-2020 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let g:spacevim_enable_ycm = 1

" Note: Skip initialization for vim-tiny or vim-small.
if 1
    let g:_spacevim_if_lua = 0
    if has('lua')
        if has('win16') || has('win32') || has('win64')
            let s:plugin_dir = fnamemodify(expand('<sfile>'), ':h').'\lua'
            let s:str = s:plugin_dir . '\?.lua;' . s:plugin_dir . '\?\init.lua;'
        else
            let s:plugin_dir = fnamemodify(expand('<sfile>'), ':h').'/lua'
            let s:str = s:plugin_dir . '/?.lua;' . s:plugin_dir . '/?/init.lua;'
        endif
        silent! lua package.path=vim.eval("s:str") .. package.path
        if empty(v:errmsg)
            let g:_spacevim_if_lua = 1
        endif
    endif
    execute 'source' fnamemodify(expand('<sfile>'), ':h').'/config/main.vim'
endif

call dein#add('vim-add-ons/shell-omni-completion')
call dein#add('vim-add-ons/clavichord-omni-completion')
call dein#add('vim-add-ons/vim-user-menu')
call dein#add('itchyny/lightline.vim')
call dein#add('tmhedberg/matchit')
call dein#add('d0c-s4vage/lookatme')

map <F11> :!cp -vf ~/github/user-menu/plugin/vim-user-menu.vim ~/.cache/vimfiles/.cache/vimrc/.dein/plugin/vim-user-menu.vim<CR><CR>

map <Leader>1 <ESC>:tabnext 1<CR>
map <Leader>2 <ESC>:tabnext 2<CR>
map <Leader>3 <ESC>:tabnext 3<CR>
map <Leader>4 <ESC>:tabnext 4<CR>
map <Leader>5 <ESC>:tabnext 5<CR>
map <Leader>6 <ESC>:tabnext 6<CR>
map <Leader>7 <ESC>:tabnext 7<CR>

map <Esc>1 <ESC>:tabnext 1<CR>
map <Esc>2 <ESC>:tabnext 2<CR>
map <Esc>3 <ESC>:tabnext 3<CR>
map <Esc>4 <ESC>:tabnext 4<CR>
map <Esc>5 <ESC>:tabnext 5<CR>
map <Esc>6 <ESC>:tabnext 6<CR>
map <Esc>7 <ESC>:tabnext 7<CR>

set viminfo='100,<100000,s100,%,/10000
set history=10000
set isk+=@-@,.,:,-,+
set report=0

set completeopt+=noinsert,menuone,popup

if exists("*mkdir")
    if !isdirectory($HOME."/tmp/vitmp")
        silent! call mkdir($HOME."/tmp/vitmp", "p", 0700)
    endif
    if !isdirectory($HOME."/Safe/vitmp")
        silent! call mkdir($HOME."/Safe/vitmp", "p", 0700)
    endif
endif

hi! link WarningMsg ErrorMsg

set directory=$HOME/.vim/swapfiles
set directory+=/home/sg/.cache/SpaceVim/swap
set modelines=5
set listchars+=nbsp:—,trail:·,precedes:←,extends:→  " screen boundary marks when nowrap
set sidescroll=5            " horizontal scroll lines
set bs=3                    " backspace moves across all boundaries
set foldmethod=marker
set swb=useopen,usetab,newtab,uselast  " long story… see :h
set mouse=
set hidden                  " unmodified buffors aren't wiped
set autowrite
set autowriteall      
set isfname-==              " "ctrl-x f" after variable assignment
set timeoutlen=800 ttimeoutlen=-1

" :Nop to easily disable multi-\n commands.
command! -nargs=* Nop "Nothing is done here…
highlight! NopGroup ctermbg=249 ctermfg=253
let m = matchadd("NopGroup", '^\s*Nop .*\n\(\s*\\.*\n\)*')

if has("autocmd")
    filetype plugin indent on
    autocmd BufRead *.txt setlocal tw=78
    autocmd BufRead *.txt setlocal wrap
    autocmd FileType text setlocal tw=78
    autocmd FileType text setlocal wrap
    "autocmd BufRead *.plist setlocal filetype:xml
    "autocmd FileType cpp setlocal foldmethod=syntax
    "autocmd FileType c setlocal foldmethod=syntax
    "autocmd BufRead *.log set ft=marma

Nop autocmd BufReadPost *
 \ if line("'\"") > 0 && line ("'\"") <= line("$") |
 \   exe "normal g'\"" |
 \ endif

"    augroup how_many_characters_yank
"        au!
"	au TextYankPost * call s:how_many_characters_yank()
"    augroup END
"
"    fu! s:how_many_characters_yank() abort
"	if len(v:event.regcontents) == 1 || len(v:event.regcontents) == 2 && v:event.regcontents[1] is# ''
"	    redraw
"	    echo strchars(join(v:event.regcontents, ''), 1)
"	endif
"    endfun
endif " 1}}}

hi User1 cterm=NONE    ctermfg=red    ctermbg=yellow guifg=red    guibg=white
hi User2 cterm=NONE    ctermfg=black  ctermbg=green  guifg=black  guibg=green
hi User3 cterm=NONE    ctermfg=yellow ctermbg=darkmagenta guifg=yellow guibg=cyan
hi User4 cterm=NONE    ctermfg=white ctermbg=20 guifg=yellow guibg=darkblue
hi User5 cterm=NONE    ctermfg=white ctermbg=57 cterm=bold guifg=yellow guibg=darkblue

nnoremap    U <C-R>
nnoremap    <silent> <F8> :call G_ToggleMouse()<CR>
inoremap    <silent> <F8> <C-O>:call G_ToggleMouse()<CR>
set pastetoggle=<F7>
nnoremap    <F4>    <C-W>w
inoremap    <F4>    <ESC><C-W>w
nnoremap    <F1>    :hide<CR>
inoremap    <F1>    <ESC>:hide<CR>

" FUNCTION: G_TakeOutBuf() {{{
" Take-out current window/buffer into its own tab :) It hides/closes the
" current window, hence the "take-out".
noremap <F5> <C-\><C-N>:call G_TakeOutBuf()<CR>
func! G_TakeOutBuf()
  let bufnr = bufnr()
  hide
  tabnew
  exe "buf" bufnr
endfunc
" }}}
" FUNCTION: G_WriteBackup {{{
nnoremap <Leader>b :call G_WriteBackup()<CR>
function! G_WriteBackup()
    let fname   = expand("%:t") . "__" . strftime("%m_%d_%Y_%H.%M.%S")
    let dirname = strftime("%m_%Y")
    let dfullname = $HOME . "/Safe/master_backup/" . dirname
    " TODO call mkdir()
    if !isdirectory(dfullname)
        silent call mkdir(dfullname, "p")
    endif
    "silent call system("mkdir -p ")
    silent exe ":w " . dfullname . "/" . fname
    echo "Wrote " . dirname . "/" . fname
endfun
" }}}
" FUNCTION: G_ToggleMouse() "{{{
function G_ToggleMouse()
    if &mouse=='a'
        set mouse=
        echo "Mouse off"
    else
        set mouse=a
        echo "Mouse on"
    endif
endfunction " }}}

inoremap <Space> <Space><C-g>u
inoremap <Tab> <Tab><C-g>u
inoremap <Return> <Return><C-g>u

:nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>

cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

cnoremap <expr> <A-b> &cedit. 'b' .'<C-c>'
cnoremap <expr> <A-w> &cedit. 'w' .'<C-c>'

nmap ]q :cnext<cr>
nmap ]Q :clast<cr>
nmap [q :cprev<cr>
nmap [Q :cfirst<cr>

function! All_files()
  return extend( filter(copy(v:oldfiles), "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"), map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

silent! unmap <C-D>
silent! unmap <C-U>

source ~/github/vim-experiments/show-args-plugin/plugin/show-args.vim

set <S-Up>=[a
set <S-Down>=[b
set <S-Right>=[c
set <S-Left>=[d

" vim:set et sw=2
