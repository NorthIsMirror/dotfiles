set isk+=@-@,.,:,-

set completeopt+=noinsert,menuone
inoremap <BS> <BS><C-R>=pumvisible() ? "" : "\<lt>C-N>"<CR>

if exists("*mkdir")
    if !isdirectory($HOME."/tmp/vitmp")
        silent! call mkdir($HOME."/tmp/vitmp", "p", 0700)
    endif
endif

" guard for distributions lacking the 'persistent_undo' feature.
if has('persistent_undo')
    " define a path to store persistent undo files.
    let target_path = expand('~/.config/vim-persisted-undo/')    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, 'p')
    endif    " point Vim to the defined undo directory.
    let &undodir = target_path    " finally, enable undo persistence.
    set undofile
endif
set undolevels=10000

" OPTIONS {{{1
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   "set fileencodings=utf-8,latin2,latin1
endif

set nocompatible
set modeline
" Format
set ts=8
set sts=4
set sw=4
set et
" File
set backup
set backupdir=~/tmp/vitmp
set viminfo='50,\"2000			" 2000 register lines 
set history=500
set printoptions=left:15mm,right:15mm,top:15mm,bottom:20mm,syntax:y,paper:A4
" Display
set ruler				" show cursor position
set listchars+=precedes:<,extends:>	" screen boundary marks when nowrap
" Behavior
set sidescroll=1			" horizontal scroll lines
set noignorecase
set bs=2				" backspace moves across all boundaries
set wrap
set foldmethod=marker
set swb=usetab				" switching buffers includes those in tabs
" Function
set mouse=""
set hidden				" unmodified buffors aren't wiped
set autowrite
set autowriteall			
set isfname-==				" "ctrl-x f" after variable assignment
set timeoutlen=800 ttimeoutlen=-1
" 1}}}
" AUTOCMD {{{1
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
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal g'\"" |
    \ endif
endif " 1}}}
" XXD {{{1
augroup Binary
    au!
    au BufReadPre  *.bin let &bin=1
    au BufReadPost *.bin if &bin | %!xxd
    au BufReadPost *.bin set ft=xxd | endif
    au BufWritePre *.bin if &bin | %!xxd -r
    au BufWritePre *.bin endif
    au BufWritePost *.bin if &bin | %!xxd
    au BufWritePost *.bin set nomod | endif
augroup END " 1}}}
" 256 colors {{{1
if &term=="xterm" || &term=="rxvt"
    set t_Co=256
    set t_Sb=^[4%dm
    set t_Sf=^[3%dm
endif " 1}}}
" SYNTAX ON {{{1
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
    colorscheme delek
    hi Special                      ctermfg=yellow guifg=Orange cterm=none gui=none
endif " 1}}}
" SHIFT-INSERT {{{1
if 0 && has("gui_running")
    set mousehide
    map <S-Insert> <MiddleMouse>
    map! <S-Insert> <MiddleMouse>
else
    map <S-Insert> <RightMouse>
    map! <S-Insert> <RightMouse>
endif " 1}}}
 " Status line {{{1
set laststatus=2

if has('statusline')

    " CALLBACK {{{2
    function SetStatusLineStyle()
        " Pobranie aktualnego czasu przed wyswietleniem
        let l:tmptime = strftime("%H:%M")
        let &stl="%f %y%([%R%M]%)%{'!'[&ff=='".&ff."']}%{'$'[!&list]}%{'~'[&pm=='']}\ %2*[#%02n]%*\ %2*[".l:tmptime."]%*\ char=0x%02B\,%03b\ %=%{SL_Options()}\ %18.(%l/%L\ %=%c%V%)"

        call SetStatusLineColor()
    endfunc " 2}}}
    function SetStatusLineColor() " {{{2
        " Doesn't actually work
        if mode() == "i"
            highlight StatusLine	ctermfg=White ctermbg=Blue cterm=NONE
            highlight StatusLineNC	ctermfg=Gray ctermbg=Blue cterm=NONE
        else
            highlight StatusLine	ctermfg=White ctermbg=Black cterm=NONE
            highlight StatusLineNC	ctermfg=White ctermbg=Black cterm=NONE
        endif
    endfunc " 2}}}
    function! SL_Options() " {{{2
        let opt=""
        " autoindent
        if &ai|   let opt=opt." ai"   |endif
        "  expandtab
        if &et|   let opt=opt." et"   |endif
        "  hlsearch
        if &hls|  let opt=opt." hls"  |endif
        "  paste
        if &paste|let opt=opt." paste"|endif
        "  shiftwidth
        if &shiftwidth!=8|let opt=opt." sw=".&shiftwidth|endif
        "  textwidth - show always!
        let opt=opt." tw=".&tw
        return opt
    endf " 2}}}

    call SetStatusLineStyle()

    if has('title')
        set titlestring=%t%(\ [%R%M]%)
    endif

    " color for buffer number
    hi User1 cterm=NONE    ctermfg=red    ctermbg=yellow guifg=red    guibg=white
    " color for filename
    hi User2 cterm=NONE    ctermfg=black  ctermbg=green  guifg=black  guibg=green
    " color for position
    hi User3 cterm=NONE    ctermfg=yellow ctermbg=darkmagenta guifg=yellow guibg=cyan
endif  " 1}}}
" SET FOLDTEXT {{{1
function! MyFoldText()
    let comment = substitute(getline(v:foldstart),"^[[:space:]]*","",1)
    let comment = substitute(comment,"{{"."{.*$","",1)
    let comment = substitute(comment,"\"[[:space:]]*","",1)
    let txt = '+ ' . comment
    return txt
endfunction
set foldtext=MyFoldText()
" 1}}}
" F1-F12 {{{1
nnoremap    U       <C-R>
nnoremap    <F12>   :make<CR>
inoremap    <F12>   <C-O>:make<CR>
nnoremap    <F11>   :cnext<CR>
inoremap    <F11>   <C-O>:cnext<CR>
nnoremap    <silent> <F8> :call SG_ToggleMouse()<CR>
inoremap    <silent> <F8> <C-O>:call SG_ToggleMouse()<CR>
set pastetoggle=<F7>
nmap        <F4>    a<C-R>=strftime("%Y-%m-%d %a %H:%M")<CR><Esc>
imap        <F4>    <C-R>=strftime("%Y-%m-%d %a %H:%M")<CR>
nnoremap    <F3>    <C-W><C-S>:Ex<CR>
inoremap    <F3>    <ESC><C-W><C-S>:Ex<CR>
nnoremap    <F2>    <C-W>w
inoremap    <F2>    <ESC><C-W>w
nnoremap    <F1>    :hide<CR>
inoremap    <F1>    <ESC>:hide<CR>
" 1}}}

runtime macros/justify.vim

let g:explDetailedList=1
let g:explDateFormat="%m %d %Y %H:%M"
let g:manpageview_winopen="reuse"
let g:html_use_css=1
let g:use_xhtml=1
let c_no_comment_fold=1
let c_gnu=1
let c_no_if0_fold=1

" vim7 tabs
if version >= 700
    noremap L :tabn<CR>
    noremap H :tabp<CR>
endif

" Fine grained undo
inoremap <Space> <Space><C-g>u
inoremap <Tab> <Tab><C-g>u
inoremap <Return> <Return><C-g>u

" provide hjkl movements in Insert mode via the <Alt> modifier key
inoremap <C-h> <C-o>h
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-l> <C-o>l

" Also b and w normal commands
inoremap <A-b> <C-o>b
inoremap <A-w> <C-o>w

" provide hjkl movements in Command-line mode via the <Alt> modifier key
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

" Also b and w normal commands
cnoremap <expr> <A-b> &cedit. 'b' .'<C-c>'
cnoremap <expr> <A-w> &cedit. 'w' .'<C-c>'

" Insert the rest of the line below the cursor.
" Mnemonic: Elevate characters from below line
inoremap <A-e> 
    \<Esc>
    \jl
        \y$
    \hk
        \p
        \a

" Insert the rest of the line above the cursor.
" Mnemonic:  Y depicts a funnel, through which the above line's characters pour onto the current line.
inoremap <A-y> 
    \<Esc>
    \kl
        \y$
    \hj
        \p
        \a

" ggvG
nnoremap <Leader>'wc ggvG$"+y
nnoremap <Leader>'wC ggvG$"*y
nnoremap <Leader>'wv ggvG$"+p
nnoremap <Leader>'wV ggvG$"*p

" other.vim
map <Leader>'o <Plug>OtherFile

" %s <C-R>", <C-R><C-W> {{{1
nnoremap <Leader>'z :%s/\<<C-R><C-W>\>/
inoremap <Leader>'z <ESC>:%s/\<<C-R><C-W>\>/

nnoremap <silent> <Leader>'Z :call SG_BeginSubstituteCommandFromVisualMode()<CR>v
inoremap <silent> <Leader>'Z <ESC>:call SG_BeginSubstituteCommandFromVisualMode()<CR>v
vnoremap <silent> <Leader>'Z <ESC>:call SG_BeginSubstituteCommandFromVisualMode()<CR>vgv
function! SG_BeginSubstituteCommandFromVisualMode()
    vnoremap <buffer> y y<CR>:unmap <buffer> y<CR>:%s/<C-R>"/
endfunction
" 1}}}
" function! SG_WriteBackup {{{1
nnoremap <Leader>'b :call SG_WriteBackup()<CR>
function! SG_WriteBackup()
    let fname   = expand("%:t") . "__" . strftime("%m_%d_%Y_%H.%M.%S")
    let dirname = strftime("%m_%Y")
    " TODO call mkdir()
    silent call system("mkdir -p /home/seba/Safe/master_backup/" . dirname)
    silent exe ":w /home/seba/Safe/master_backup/" . dirname . "/" . fname
    echo "Wrote " . dirname . "/" . fname
endfun
" 1}}}
function! SG_NoUTFPolishLeters() " {{{1
    :%s/Ą/A/ge
    :%s/ą/a/ge
    :%s/Ć/C/ge
    :%s/ć/c/ge
    :%s/Ę/E/ge
    :%s/ę/e/ge
    :%s/Ł/L/ge
    :%s/ł/l/ge
    :%s/Ń/N/ge
    :%s/ń/n/ge
    :%s/Ó/O/ge
    :%s/ó/o/ge
    :%s/Ś/S/ge
    :%s/ś/s/ge
    :%s/Ź/Z/ge
    :%s/ź/z/ge
    :%s/Ż/Z/ge
    :%s/ż/z/ge
endfunction " 1}}}
function! SG_NoISOPolishLeters() " {{{1
    :%s/�/A/ge
    :%s/�/a/ge
    :%s/�/C/ge
    :%s/�/c/ge
    :%s/�/E/ge
    :%s/�/e/ge
    :%s/�/L/ge
    :%s/�/l/ge
    :%s/�/N/ge
    :%s/�/n/ge
    :%s/�/O/ge
    :%s/�/o/ge
    :%s/�/S/ge
    :%s/�/s/ge
    :%s/�/Z/ge
    :%s/�/z/ge
    :%s/�/Z/ge
    :%s/�/z/ge
endfunction " 1}}}
function! SG_off_FixUtf8() " {{{1
    " e,
    :%s/ę/e/ge
    " \l
    :%s/ł/l/ge
    " \L
    :%s/Ł/L/ge
    " o'
    :%s/ó/o/ge
    "z' (rz)
    :%s/ż/z/ge
    " s'
    :%s/ś/s/ge
    " c'
    :%s/ć/c/ge
    " a,
    :%s/ą/a/ge
    "
    :%s///ge
    "
    :%s///ge
    "
    :%s///ge
    "
    :%s///ge
    "
    :%s///ge
endfunction " 1}}}
function SG_ToggleMouse() " {{{1
    if &mouse=='a'
        set mouse=
        echo "Mouse off"
    else
        set mouse=a
        echo "Mouse on"
    endif
endfunction " 1}}}
function! SG_FixPascalCode() " {{{1
    :%s/\<function\>/Function/gie
    :%s/\<begin\>/Begin/gie
    :%s/\<program\>/Program/gie
    :%s/\<procedure\>/Procedure/gie
    :%s/\<end\>/End/gie
    :%s/\<while\>/While/gie
    :%s/\<case\>/Case/gie
    :%s/\<false\>/False/gie
    :%s/\<integer\>/Integer/gie
    :%s/\<array\>/Array/gie
    :%s/\<boolean\>/Boolean/gie
    :%s/\<for\>/For/gie
    :%s///gie
    :%s///gie
endfunction " 1}}}
" ILIST {{{1
nnoremap <Leader>'fk :call SG_UnderFilterOccurences()<CR>
nnoremap <Leader>'fp :call SG_PromptFilterOccurences()<CR>

function! SG_UnderFilterOccurences()
    let v:errmsg = ""
    exe "normal [I"
    if v:errmsg != ""
        return
    endif
    let nr = input("Wybierz: ")
    if nr == ""
        return
    endif
    let v:errmsg = ""
    exe "silent! normal " . nr . "[\t"
    if v:errmsg != ""
        echohl WarningMsg | echomsg "Nie bylo takiego numeru"  | echohl None
    endif
endfunction!
function! SG_PromptFilterOccurences()
    let pattern = input("Czego szukac: ")
    if pattern == ""
        return
    endif
    let v:errmsg = ""
    exe "ilist " . pattern
    if v:errmsg != ""
        return
    endif
    let nr = input("Wybierz: ")
    if nr == ""
        return
    endif
    let v:errmsg = ""
    exe "silent! ijump " . nr . pattern
    if v:errmsg != ""
        echohl WarningMsg | echomsg "Nie bylo takiego numeru"  | echohl None
    endif
endfunction
" 1}}}


" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'farmergreg/vim-lastplace'
Plug 'Valodim/vim-zsh-completion'
call plug#end()


