set viminfo='100,<100000,s100,%,/10000
set history=10000
set isk+=@-@,.,:,-,+
set report=0
set fo+=cr1nqj
set incsearch


set completeopt-=noselect,preview
set completeopt+=noinsert,menuone,popup

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
set backupdir=$HOME/Safe/vitmp//,~/tmp/vitmp//
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
endif " 1}}}

 " Status line {{{1
set laststatus=2

if has('statusline')
    " Modifiable, RO, Modified, Special
    let g:colormap = {
                \    '..11' : [ 227, "red" ],
                \    '..01' : { 'c' : [ 220, 57 ], '*':[ 227, 19 ] },
                \    '.110' : [ 17, "green"],
                \    '.100' : [ "yellow", 22 ],
                \    '0010' : [ 220, "red"],
                \    '0..0' : [ 122, 105 ],
                \    '.000' : [ 0, 0 ],
                \    '.010' : { 'n':[ 220, 17 ], 'i':[ 220, 17 ], '*':[ 0, 0 ] },
                \ }

    function! InsertStatuslineColor(state)
        let [ g:state, g:the_key ] = [ a:state, "" ]
        let q = &modifiable . &ro . &modified . ( empty(&bt) ? "0" : "1" )
        let res = filter(copy(g:colormap), "q =~ '^'.v:key.'$'")
        let resa = filter(['..11','..01','1000','1010','.110',
                    \ '.100','0010','0..0','.000','.010'], "(has_key(res,v:val) &&
                    \ empty(g:the_key)) ? !empty(extend(g:,{'the_key':v:val})) : 0")
        let res = !empty(g:the_key) ? copy(g:colormap[g:the_key]) : [ 220, 17 ]
        let res = type(res) == v:t_dict ? get(res,a:state,get(res,'*',[0,0])) : res
        "echom "≈≈≈ Got g:the_key: →" g:the_key "←" "res: →→" string(res) "←← ≈≈ FOR:" q "≈≈ ˙state˙ ↔" a:state
        if a:state == 'i'
            let res = !(!empty(res[0])+!empty(res[1])) ? [ 220, 17 ] : res | call extend(res, [ "DarkBlue", "Yellow" ])
        elseif a:state == 'r'
            let res = !(!empty(res[0])+!empty(res[1])) ? [ "Yellow", "Red" ] : res | call extend(res, [ "Yellow", "Gray" ])
        elseif a:state == 'n'
            let res = !(!empty(res[0])+!empty(res[1])) ? [ 227, "Blue" ] : res | call extend(res, [ "Yellow", "Blue" ])
        " TODO…
        elseif a:state == 'v'
            let res = !(!empty(res[0])+!empty(res[1])) ? [ 227, 57 ] : res | call extend(res, [ "Yellow", "Gray" ])
        elseif a:state == 'c'
            "let m = execute("hi statusline")
            "echom "Before the set of the hl group:" m res
            let res = !(!empty(res[0])+!empty(res[1])) ? [ 227, 57 ] : res | call extend(res, [ "Yellow", "Gray" ])
        else
            let res = !(!empty(res[0])+!empty(res[1])) ? [ 220, "Blue" ] : res | call extend(res, [ "Yellow", "Blue" ])
        endif
        let [adda, addb] = ["cterm=NONE", "gui=NONE"]
        let inv_reverse= get(g:, "inv_reverse", 0)
        if !inv_reverse
            let [adda, addb] = ["cterm=reverse,bold", "gui=reverse,bold"]
        endif
        "echom "exe" "hi!" "statusline" adda "ctermfg=".res[1] "ctermbg=".res[0] addb "guifg=".res[3] "guibg=".res[2]
        exe "hi!" "statusline" adda "ctermfg=".res[1] "ctermbg=".res[0] addb "guifg=".res[3] "guibg=".res[2]
        "echom "Got g:the_key: →" g:the_key "←" "res: →→" string(res) "←←"
        "let m = execute("hi statusline")
        "echom "After the set (2) of the hl group:" m
        let stl = &stl
        let &stl = &stl."%v"
        let &stl = stl
        let &ro = &ro
        " For coc, a workaround
        let b:list_status = {}
        redrawstatus!
    endfunction

    au InsertEnter * call InsertStatuslineColor(v:insertmode)
    au InsertLeave * call InsertStatuslineColor('n')
    au CmdlineEnter * call InsertStatuslineColor('c')
    au CmdlineLeave * call InsertStatuslineColor('n')
    au BufWinEnter * call InsertStatuslineColor('n')
    au WinEnter * call InsertStatuslineColor('n')
    au BufWritePost,FileAppendPost * call InsertStatuslineColor('n')
    au FileChangedShellPost * call InsertStatuslineColor('n')
    au Syntax * call InsertStatuslineColor('n')


    " Initialize.
    call InsertStatuslineColor('n')
    hi statuslinenc ctermfg=17 ctermbg=White guifg=DarkBlue guibg=White

    " CALLBACK {{{2
    function! StrChPar(string, begin, len)
        if exists('*strcharpart')
            return strcharpart(a:string, a:begin, a:len)
        else
            return matchstr(a:string, '.\{,'.a:len.'}', 0, a:begin+1)
        endif
    endfunction
    function! DotsAbbr(string, limit)
        if strchars(a:string) > a:limit
            return StrChPar(a:string,0,a:limit-1)."…"
        endif
        return a:string
    endfunction
    function SetStatusLineStyle()
        let fnsize = &columns - 70 
        let &stl = "≈ %4*%.".fnsize."F%*%y%([%R%M]%)%{'!'[&ff=='".&ff."']}
                    \%{'$'[!&list]}%{'~'[&pm=='']}\ %3*«%n»%*%( %5*%.25{DotsAbbr(get(b:,'coc_current_function',''),22)}%*%)
                    \ ≈ %5*%{strftime('%H:%M')}%* ≈ chr=0x%02B\,%03b\ %=%{SL_Options()}\ \ %l/%L≈%v\ ↔\ %=%c%V %2*%p%%%* ≈"
                   " \%{'$'[!&list]}%{'~'[&pm=='']}\ %3*«%{bufnr()}»%* %7*ƒ%*≈%5*%{get(b:,'coc_current_function','')[0:25]}%*
    endfunc " 2}}}
    "let &statusline=SetStatusLineStyle()
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
"nnoremap    <F11>   :cnext<CR>
"inoremap    <F11>   <C-O>:cnext<CR>
nnoremap <F11> :source ~/.vim/plugged/clavichord-omni-completion/plugin/clavichord-omni-completion.vim<CR>
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
" function! G_InitialBackup {{{1
function! InitialBackup()
    w! ~/.vim/mybackup/%:t
endfunction
if !isdirectory($HOME."/.vim/mybackup")
    silent! call mkdir($HOME."/.vim/mybackup","p")
endif
augroup MyOwn
    au BufReadPost * silent! call InitialBackup()
augroup END

" 1}}}

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

let g:EasyOperator_phrase_do_mapping = 0
let g:EasyOperator_line_do_mapping = 0
let g:node_client_debug = 1
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/vim-easyoperator-phrase'
Plug 'haya14busa/vim-easyoperator-line'

Plug 'zphere-zsh/vim-user-menu'
Plug 'vim-add-ons/Entirety-Grep'
"Plug 'zphere-zsh/clavichord-omni-completion'
"Plug 'zphere-zsh/shell-omni-completion'
"Plug 'zphere-zsh/shell-auto-popmenu'
call plug#end()

" Configurationsymotion-hlsearch) and mappings for the plugins…
nmap <Space>f <Plug>(easymotion-s2)
nmap s <Plug>(easymotion-overwin-f2)
map <Leader>L <Plug>(easymotion-lineforward)
" Line…
omap <Leader>l  <Plug>(easyoperator-line-select)
nmap <Leader>l  <Plug>(easyoperator-line-select)
xmap <Leader>l  <Plug>(easyoperator-line-select)
nmap d<leader>l <Plug>(easyoperator-line-delete)
nmap c<leader>l <Plug>(easyoperator-line-yank)
" Phrase…
omap <Leader>p  <Plug>(easyoperator-phrase-select)
xmap <Leader>p  <Plug>(easyoperator-phrase-select)
nmap d<Leader>p <Plug>(easyoperator-phrase-delete)
nmap c<Leader>p <Plug>(easyoperator-phrase-yank)

map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
map <Leader>n <Plug>(easymotion-next)
map <Leader>P <Plug>(easymotion-prev)
map <Leader>R <Plug>(easymotion-repeat)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
" Not really needed (just highlights differently)
"map  n <Plug>(easymotion-next)
"map  N <Plug>(easymotion-prev)
" Bidirectional & within line 't' motion
omap t <Plug>(easymotion-bd-tl)
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_upper = 1
let g:EasyMotion_use_smartsign_us = 1

"colorscheme spacecamp

let g:zekyll_debug = 1
let g:zekyll_messages = 1

function! All_files()
  return extend( filter(copy(v:oldfiles), "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"), map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

nnoremap <ESC>1 :tabnext 1<CR>
inoremap <ESC>1 <C-O>:tabnext 1<CR>
nnoremap <ESC>2 :tabnext 2<CR>
inoremap <ESC>2 <C-O>:tabnext 2<CR>
nnoremap <ESC>3 :tabnext 3<CR>
inoremap <ESC>3 <C-O>:tabnext 3<CR>
nnoremap <ESC>4 :tabnext 4<CR>
inoremap <ESC>4 <C-O>:tabnext 4<CR>
nnoremap <ESC>5 :tabnext 5<CR>
inoremap <ESC>5 <C-O>:tabnext 5<CR>
nnoremap <ESC>6 :tabnext 6<CR>
inoremap <ESC>6 <C-O>:tabnext 6<CR>
nnoremap <ESC>7 :tabnext 7<CR>
inoremap <ESC>7 <C-O>:tabnext 7<CR>
nnoremap <ESC>8 :tabnext 8<CR>
inoremap <ESC>8 <C-O>:tabnext 8<CR>

highlight Pmenu      ctermfg=3 ctermbg=4 guifg=#ff0000 guibg=#00ff00
highlight PmenuSel   ctermfg=2 ctermbg=3 guifg=#ff0000 guibg=#00ff00
highlight PmenuSbar  ctermfg=3 ctermbg=4 guifg=#ff0000 guibg=#00ff00
highlight PmenuThumb ctermfg=3 ctermbg=4 guifg=#ff0000 guibg=#00ff00

" The COC configuration snippet (from GitHub):

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
"if exists('*complete_info')
"  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"else
"  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"endif
"inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Search the Lists
nnoremap <silent><nowait> <space>l  :<C-u>CocList<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" Next symbol
nnoremap <silent><nowait> <space>n  :<C-u>CocCommand document.jumpToNextSymbol<CR>
inoremap <silent><nowait> <Esc>n  <C-o>:<C-u>CocCommand document.jumpToNextSymbol<CR>

""" Customize colors
func! G_Colors_For_Popups_Setup() abort
    " this is an example
    hi Pmenu      cterm=NONE ctermbg=darkgray ctermfg=white guibg=#000000 gui=NONE
    hi PmenuSel   cterm=bold ctermbg=darkgray ctermfg=220   guibg=#000000 gui=NONE
    hi PmenuSbar  cterm=NONE ctermbg=darkgray ctermfg=22    guibg=#000000 gui=none
    hi PmenuThumb cterm=NONE ctermbg=darkgray ctermfg=227   guibg=#000000 gui=none
    "hi Special    cterm=bold ctermfg=yellow   guifg=Gold    cterm=none    gui=none
    " color for buffer number
    hi User1 cterm=NONE    ctermfg=red    ctermbg=yellow guifg=red    guibg=white
    " color for filename
    hi User2 cterm=NONE    ctermfg=black  ctermbg=green  guifg=black  guibg=green
    " color for position
    hi User3 cterm=NONE    ctermfg=yellow ctermbg=darkmagenta guifg=yellow guibg=cyan
    hi User4 cterm=NONE    ctermfg=white ctermbg=20 guifg=yellow guibg=darkblue
    hi User5 cterm=NONE    ctermfg=white ctermbg=57 cterm=bold guifg=yellow guibg=darkblue
    hi User7 cterm=italic ctermfg=yellow ctermbg=darkmagenta guifg=yellow guibg=cyan
    hi! link WarningMsg ErrorMsg
endfunc

augroup colorscheme_coc_setup | au!
    au ColorScheme * call timer_start(100,{->G_Colors_For_Popups_Setup()})
augroup END

"colorscheme slate
"colorscheme koehler
"colorscheme morning
"colorscheme evening
"call timer_start(150, {->execute("colorscheme koehler")})
"call timer_start(170, {->InsertStatuslineColor("n")})
colorscheme morning
