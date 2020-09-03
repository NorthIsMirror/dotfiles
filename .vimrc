set viminfo='100,<100000,s100,%,/10000
set history=10000
set isk+=@-@,.,:,-,+

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
    let target_path = expand('~/.vim/vim-persisted-undo/')    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, 'p')
    endif    " point Vim to the defined undo directory.
    let &undodir = target_path    " finally, enable undo persistence.
    set undofile
endif
set undolevels=10000


" OPTIONS {{{1
set directory=$HOME/.vim/swapfiles//
set foldopen=mark,percent,quickfix,search,tag,undo

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   "set fileencodings=utf-8,latin2,latin1
endif

set nocompatible
set modeline
set modelines=5
" Format
set ts=8
set sts=4
set sw=4
set et
" File
set backup
set backupdir=$HOME/Safe/vitmp,~/tmp/vitmp
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
    function! InsertStatuslineColor(state)
        let g:state = a:state
        if a:state == 'i'
            hi statusline ctermfg=17 ctermbg=Yellow guifg=DarkBlue guibg=Yellow
        elseif a:state == 'r'
            hi statusline ctermfg=Yellow ctermbg=Red guifg=Yellow guibg=Gray
        elseif a:state == 'n'
            hi statusline ctermfg=227 cterm=bold ctermbg=Blue guifg=Gold guibg=Blue
        " TODOø
        elseif a:state == 'v'
            hi statusline ctermfg=220 cterm=bold ctermbg=22 guifg=Gold guibg=Blue
        elseif a:state == 'c'
            hi statusline ctermfg=220 cterm=bold ctermbg=22 guifg=Gold guibg=Blue
            redraw
        else
            hi statusline ctermfg=Yellow ctermbg=Blue guifg=Yellow guibg=Blue
        endif
    endfunction

    au InsertEnter * call InsertStatuslineColor(v:insertmode)
    au InsertLeave * call InsertStatuslineColor('n')
    au CmdwinEnter * call InsertStatuslineColor('c')
    au CmdwinLeave * call InsertStatuslineColor('n')

    " Initialize.
    call InsertStatuslineColor('n')
    hi statuslinenc ctermfg=17 ctermbg=White guifg=DarkBlue guibg=White

    " CALLBACK {{{2
    function SetStatusLineStyle()
        let fnsize = &columns - 70 
        let &stl="%2*%.".fnsize."F%*%y%([%R%M]%)%{'!'[&ff=='".&ff."']}%{'$'[!&list]}%{'~'[&pm=='']}\ ø %2*%{strftime('%H:%M')}%* ø chr=0x%02B\,%03b\ %=%{SL_Options()}\ \ %l/%Lø%v\ ø\ %=%c%V"

        "call SetStatusLineColor()
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
        let namemap= { 'i' : 'øINSø', 'r' : 'øREPLø', 'v' : 'VIS', 'n':'NRM' }
        let opt=" "
        " autoindent
        if &fo =~ 'a' && &ai|   let opt=opt."øFOø"   |endif
        if &ai|   let opt=opt."-AUøIN"   |endif
        "  expandtab
        if &et|   let opt=opt." et"   |endif
        "  hlsearch
        if &hls|  let opt=opt." hls"  |endif
        "  paste
        if &paste|let opt=opt." ´PASTEª"|endif
        "  shiftwidth
        if &shiftwidth!=8|let opt=opt." SFT=".&shiftwidth|endif
        "  textwidth - show always!
        let opt=opt." TX-WI=".&tw
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
nnoremap    <silent> <F8> :call G_ToggleMouse()<CR>
inoremap    <silent> <F8> <C-O>:call G_ToggleMouse()<CR>
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

nnoremap <silent> <Leader>'Z :call G_BeginSubstituteCommandFromVisualMode()<CR>v
inoremap <silent> <Leader>'Z <ESC>:call G_BeginSubstituteCommandFromVisualMode()<CR>v
vnoremap <silent> <Leader>'Z <ESC>:call G_BeginSubstituteCommandFromVisualMode()<CR>vgv
function! G_BeginSubstituteCommandFromVisualMode()
    vnoremap <buffer> y y<CR>:unmap <buffer> y<CR>:%s/<C-R>"/
endfunction
" 1}}}
" function! G_WriteBackup {{{1
nnoremap <Leader>'b :call G_WriteBackup()<CR>
function! G_WriteBackup()
    let fname   = expand("%:t") . "__" . strftime("%m_%d_%Y_%H.%M.%S")
    let dirname = strftime("%m_%Y")
    " TODO call mkdir()
    silent call system("mkdir -p /home/seba/Safe/master_backup/" . dirname)
    silent exe ":w /home/seba/Safe/master_backup/" . dirname . "/" . fname
    echo "Wrote " . dirname . "/" . fname
endfun
" 1}}}
function! G_NoUTFPolishLeters() " {{{1
    :%s/ƒÑ/A/ge
    :%s/ƒÖ/a/ge
    :%s/ƒÜ/C/ge
    :%s/ƒá/c/ge
    :%s/ƒò/E/ge
    :%s/ƒô/e/ge
    :%s/≈Å/L/ge
    :%s/≈Ç/l/ge
    :%s/≈É/N/ge
    :%s/≈Ñ/n/ge
    :%s/√ì/O/ge
    :%s/√≥/o/ge
    :%s/≈ö/S/ge
    :%s/≈õ/s/ge
    :%s/≈π/Z/ge
    :%s/≈∫/z/ge
    :%s/≈ª/Z/ge
    :%s/≈º/z/ge
endfunction " 1}}}
function! G_NoISOPolishLeters() " {{{1
    :%s/°/A/ge
    :%s/±/a/ge
    :%s/∆/C/ge
    :%s/Ê/c/ge
    :%s/ /E/ge
    :%s/Í/e/ge
    :%s/£/L/ge
    :%s/≥/l/ge
    :%s/—/N/ge
    :%s/Ò/n/ge
    :%s/”/O/ge
    :%s/Û/o/ge
    :%s/¶/S/ge
    :%s/∂/s/ge
    :%s/¨/Z/ge
    :%s/º/z/ge
    :%s/Ø/Z/ge
    :%s/ø/z/ge
endfunction " 1}}}
function! G_off_FixUtf8() " {{{1
    " e,
    :%s/ƒô/e/ge
    " \l
    :%s/≈Ç/l/ge
    " \L
    :%s/≈Å/L/ge
    " o'
    :%s/√≥/o/ge
    "z' (rz)
    :%s/≈º/z/ge
    " s'
    :%s/≈õ/s/ge
    " c'
    :%s/ƒá/c/ge
    " a,
    :%s/ƒÖ/a/ge
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
function G_ToggleMouse() " {{{1
    if &mouse=='a'
        set mouse=
        echo "Mouse off"
    else
        set mouse=a
        echo "Mouse on"
    endif
endfunction " 1}}}
function! G_FixPascalCode() " {{{1
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
nnoremap <Leader>'fk :call G_UnderFilterOccurences()<CR>
nnoremap <Leader>'fp :call G_PromptFilterOccurences()<CR>

function! G_UnderFilterOccurences()
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
function! G_PromptFilterOccurences()
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

" Make sure you use single quotes

Plug 'Jaredgorski/Spacecamp'
Plug 'Marfisc/Vorange'
Plug 'Flrnprz/plastic.vim'

Plug 'junegunn/vim-github-dashboard'
Plug 'mhinz/vim-startify'

Plug 'zphere-zsh/vim-user-menu'
Plug 'zphere-zsh/clavichord-omni-completion'
Plug 'zphere-zsh/shell-omni-completion'
Plug 'zphere-zsh/shell-auto-popmenu'
call plug#end()

"colorscheme spacecamp

let g:zekyll_debug = 1
let g:zekyll_messages = 1

highlight Pmenu      ctermfg=3 ctermbg=4 guifg=#ff0000 guibg=#00ff00
highlight PmenuSel   ctermfg=2 ctermbg=3 guifg=#ff0000 guibg=#00ff00
highlight PmenuSbar  ctermfg=3 ctermbg=4 guifg=#ff0000 guibg=#00ff00
highlight PmenuThumb ctermfg=3 ctermbg=4 guifg=#ff0000 guibg=#00ff00
call matchadd('ColorColumn', '\(\%87v\)')
