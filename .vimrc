set viminfo='100,<100000,s100,%,/10000
set history=10000
set isk+=@-@,.,:,-,+
set report=0

set completeopt+=noinsert,menuone,popup

if exists("*mkdir")
    if !isdirectory($HOME."/tmp/vitmp")
        silent! call mkdir($HOME."/tmp/vitmp", "p", 0700)
    endif
endif


hi! link WarningMsg ErrorMsg

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
set directory=$HOME/.vim/swapfiles
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
set nowrap
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
    "colorscheme slate
    "colorscheme koehler
    hi Special                      ctermfg=yellow guifg=Orange cterm=none gui=none
endif " 1}}}

 " Status line {{{1
set laststatus=2

if has('statusline')
    " Modifiable, RO, Modified, Special
    let g:colormap = {
                \    '..11' : [ 227, "red" ],
                \    '..01' : [ 227, 19 ],
                \    '.110' : [ 17, "green"],
                \    '.100' : [ "yellow", 21 ],
                \    '0010' : [ 220, "red"],
                \    '0..0' : [ 122, 105 ],
                \    '.000' : [ 0, 0 ],
                \    '.010' : [ 0, 0 ],
                \ }

    function! InsertStatuslineColor(state)
        let [ g:state, g:the_key ] = [ a:state, "" ]
        let q = &modifiable . &ro . &modified . ( empty(&bt) ? "0" : "1" )
        let res = filter(copy(g:colormap), "q =~ '^'.v:key.'$'")
        let resa = filter(['..11','..01','1000','1010','.110',
                    \ '.100','0010','0..0','.000','.010'], "(has_key(res,v:val) &&
                    \ empty(g:the_key)) ? !empty(extend(g:,{'the_key':v:val})) : 0")
        let res = !empty(g:the_key) ? g:colormap[g:the_key] : [ 220, 17 ]
        "echom "Got g:the_key: →" g:the_key "←" "res: →→" string(res) "←←"
        if a:state == 'i'
            let res = !(!empty(res[0])+!empty(res[1])) ? [ 220, 17 ] : res
            exe "hi" "statusline" "ctermfg=".res[1] "ctermbg=".res[0] "guifg=DarkBlue" "guibg=Yellow"
        elseif a:state == 'r'
            let res = !(!empty(res[0])+!empty(res[1])) ? [ "Yellow", "Red" ] : res
            exe "hi" "statusline" "ctermfg=".res[1] "ctermbg=".res[0] "guifg=Yellow" "guibg=Gray"
        elseif a:state == 'n'
            let res = !(!empty(res[0])+!empty(res[1])) ? [ 227, "Blue" ] : res
            exe "hi" "statusline" "ctermfg=".res[1] "ctermbg=".res[0] "guifg=Yellow" "guibg=Blue"
        " TODO…
        elseif a:state == 'v'
            let res = !(!empty(res[0])+!empty(res[1])) ? [ 220, 22 ] : res
            exe "hi" "statusline" "ctermfg=".res[1] "ctermbg=".res[0] "guifg=Yellow" "guibg=Gray"
        elseif a:state == 'c'
            let res = !(!empty(res[0])+!empty(res[1])) ? [ 220, 22 ] : res
            exe "hi" "statusline" "ctermfg=".res[1] "ctermbg=".res[0] "guifg=Yellow" "guibg=Gray"
            redraw
        else
            let res = !(!empty(res[0])+!empty(res[1])) ? [ 220, "Blue" ] : res
            exe "hi" "statusline" "ctermfg=".res[1] "ctermbg=".res[0] "guifg=Yellow" "guibg=Blue"
        endif
        "echom "Got g:the_key: →" g:the_key "←" "res: →→" string(res) "←←"
    endfunction

    au InsertEnter * call InsertStatuslineColor(v:insertmode)
    au InsertLeave * call InsertStatuslineColor('n')
    au CmdlineEnter * call InsertStatuslineColor('c')
    au CmdlineLeave * call InsertStatuslineColor('n')
    au BufWinEnter * call InsertStatuslineColor('n')
    au WinEnter * call InsertStatuslineColor('n')
    au FileAppendPost * call InsertStatuslineColor('n')
    au FileChangedShellPost * call InsertStatuslineColor('n')


    " Initialize.
    call InsertStatuslineColor('n')
    hi statuslinenc ctermfg=17 ctermbg=White guifg=DarkBlue guibg=White

    " CALLBACK {{{2
    function SetStatusLineStyle()
        let fnsize = &columns - 70 
        let &stl="≈ %4*%.".fnsize."F%*%y%([%R%M]%)%{'!'[&ff=='".&ff."']}%{'$'[!&list]}%{'~'[&pm=='']}\ ≈ %5*%{strftime('%H:%M')}%* ≈ chr=0x%02B\,%03b\ %=%{SL_Options()}\ \ %l/%L≈%v\ ↔\ %=%c%V"

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
        let namemap= { 'i' : '—INS—', 'r' : '—REPL—', 'v' : 'VIS', 'n':'NRM' }
        let opt=" "
        " autoindent
        if &fo =~ 'a' && &ai|   let opt=opt."→FO←"   |endif
        if &ai|   let opt=opt."—AUI"   |endif
        "  expandtab
        if &et|   let opt=opt." et"   |endif
        "  hlsearch
        if &hls|  let opt=opt." hls"  |endif
        "  paste
        if &paste|let opt=opt." «PASTE»"|endif
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
    hi User4 cterm=NONE    ctermfg=white ctermbg=20 guifg=yellow guibg=darkblue
    hi User5 cterm=NONE    ctermfg=white ctermbg=57 cterm=bold guifg=yellow guibg=darkblue
endif  " 1}}}

"
" MyFoldText
"
function! MyFoldText()
    let comment = substitute(getline(v:foldstart),"^[[:space:]]*","",1)
    let comment = substitute(comment,"{{"."{.*$","",1)
    let comment = substitute(comment,"\"[[:space:]]*","",1)
    let txt = '+ ' . comment
    return txt
endfunction

set foldtext=MyFoldText()

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
"nnoremap    <F1>    :echohl WarningMsg <Bar> :echomsg "Przesunąć dłoń w lewo?" <Bar> :echohl None<CR>
"inoremap    <F1>    <ESC>:echohl WarningMsg <Bar> :echomsg "Przesunąć dłoń w lewo?" <Bar> :echohl None<CR>
" 1}}}


" function! G_WriteBackup {{{1
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
" 1}}}
function! G_NoUTFPolishLeters() " {{{1
    :%s/Ä/A/ge
    :%s/Ä/a/ge
    :%s/Ä/C/ge
    :%s/Ä/c/ge
    :%s/Ä/E/ge
    :%s/Ä/e/ge
    :%s/Å/L/ge
    :%s/Å/l/ge
    :%s/Å/N/ge
    :%s/Å/n/ge
    :%s/Ã/O/ge
    :%s/Ã³/o/ge
    :%s/Å/S/ge
    :%s/Å/s/ge
    :%s/Å¹/Z/ge
    :%s/Åº/z/ge
    :%s/Å»/Z/ge
    :%s/Å¼/z/ge
endfunction " 1}}}
function! G_NoISOPolishLeters() " {{{1
    :%s/¡/A/ge
    :%s/±/a/ge
    :%s/Æ/C/ge
    :%s/æ/c/ge
    :%s/Ê/E/ge
    :%s/ê/e/ge
    :%s/£/L/ge
    :%s/³/l/ge
    :%s/Ñ/N/ge
    :%s/ñ/n/ge
    :%s/Ó/O/ge
    :%s/ó/o/ge
    :%s/¦/S/ge
    :%s/¶/s/ge
    :%s/¬/Z/ge
    :%s/¼/z/ge
    :%s/¯/Z/ge
    :%s/¿/z/ge
endfunction " 1}}}
function! G_off_FixUtf8() " {{{1
    " e,
    :%s/Ä/e/ge
    " \l
    :%s/Å/l/ge
    " \L
    :%s/Å/L/ge
    " o'
    :%s/Ã³/o/ge
    "z' (rz)
    :%s/Å¼/z/ge
    " s'
    :%s/Å/s/ge
    " c'
    :%s/Ä/c/ge
    " a,
    :%s/Ä/a/ge
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

" vim7 tabs
"if version >= 700
"    noremap L :tabn<CR>
"    noremap H :tabp<CR>
"endif

" SHIFT-INSERT {{{1
if 0 && has("gui_running")
    set mousehide
    map <S-Insert> <MiddleMouse>
    map! <S-Insert> <MiddleMouse>
else
    map <S-Insert> <RightMouse>
    map! <S-Insert> <RightMouse>
endif " 1}}}

" Fine grained undo
inoremap <Space> <Space><C-g>u
inoremap <Tab> <Tab><C-g>u
inoremap <Return> <Return><C-g>u

:nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>
:nnoremap <Leader>zZ :let &scrolloff=0<CR>

" Also b and w normal commands
inoremap <A-b> <C-o>b 
inoremap <A-w> <C-o>w

" provide hjkl movements in Command-line mode via the <Alt> modifier key
"cnoremap <C-h> <Left>
"cnoremap <C-j> <Down>
"cnoremap <C-k> <Up>
"cnoremap <C-l> <Right>

" Also b and w normal commands
cnoremap <expr> <A-b> &cedit. 'b' .'<C-c>'
"cnoremap <expr> <A-w> &cedit. 'w' .'<C-c>'

" Insert the rest of the line below the cursor.
" Mnemonic: Elevate characters from below line
"inoremap <A-e> 
"    \<Esc>
"    \jl
"        \y$
"    \hk
"        \p
"        \a
"
"" Insert the rest of the line above the cursor.
"" Mnemonic:  Y depicts a funnel, through which the above line's characters pour onto the current line.
"inoremap <A-y> 
"    \<Esc>
"    \kl
"        \y$
"    \hj
"        \p
"        \a
"
" ggvG
"nnoremap <Leader>wc ggvG$"+y
"nnoremap <Leader>wC ggvG$"*y
"nnoremap <Leader>wv ggvG$"+p
"nnoremap <Leader>wV ggvG$"*p

" other.vim
"map <Leader>o <Plug>OtherFile

" %s <C-R>", <C-R><C-W> {{{1
"nnoremap <Space><Space> /\<<C-r>=expand("<cword>")<CR>\>
" 1}}}

" [ac]8 Vim Plugins
"
" Justify Macro
"
runtime macros/justify.vim

"
" Settings of plugins
"
let g:explDetailedList=1
let g:explDateFormat="%m %d %Y %H:%M"
let g:manpageview_winopen="reuse"
let g:html_use_css=1
let g:use_xhtml=1
let c_no_comment_fold=1
"let c_gnu=1
let c_no_if0_fold=1

"
" Quck-fix
"


call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

Plug 'mhinz/vim-startify'

Plug 'zphere-zsh/vim-user-menu'
Plug 'zphere-zsh/clavichord-omni-completion'
Plug 'zphere-zsh/shell-omni-completion'
Plug 'zphere-zsh/shell-auto-popmenu'
call plug#end()

"colorscheme spacecamp

let g:zekyll_debug = 1
let g:zekyll_messages = 1

function! All_files()
  return extend( filter(copy(v:oldfiles), "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"), map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

highlight Pmenu      ctermfg=3 ctermbg=4 guifg=#ff0000 guibg=#00ff00
highlight PmenuSel   ctermfg=2 ctermbg=3 guifg=#ff0000 guibg=#00ff00
highlight PmenuSbar  ctermfg=3 ctermbg=4 guifg=#ff0000 guibg=#00ff00
highlight PmenuThumb ctermfg=3 ctermbg=4 guifg=#ff0000 guibg=#00ff00
