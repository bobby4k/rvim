" USER: bobby4kit
" FILE: something single file vimrc

" 非兼容vi模式 be iMproved, required 
set nocompatible 

" 创建vim目录
if !isdirectory(expand("~/.vim/"))
    call mkdir($HOME . "/.vim")
endif

set runtimepath+=$HOME/.vim

" ##文本属性 Start
" 编码设置
set langmenu=zh_CN.UTF-8
set helplang=cn
set termencoding=utf-8
set encoding=utf8
set fileencodings=utf8,ucs-bom,gbk,cp936,gb2312,gb18030,big5,latin1

" 文档格式:Unix(LF)
set fileformats=unix,mac,dos
" ##文本属性 End

" ##编辑格式 Start
set autoindent " Auto indent
set smartindent " Smart indent

filetype on
filetype plugin on
filetype plugin indent on

" 1 tab == 4 spaces
set tabstop=4
" 自动缩进与ts一致
set shiftwidth=4
" 根据文件中缩进空格数 确定tab
set smarttab
" 空格代替tab
set expandtab


" 代码补全
set wildmenu                             " vim自身命名行模式智能补全
set completeopt=menuone,preview,noselect " 补全时不显示窗口，只显示补全列表
set omnifunc=syntaxcomplete#Complete     " 设置全能补全
set shortmess+=c                         " 设置补全静默
set cpt+=kspell                          " 设置补全单词

" 搜索设置
set hlsearch            " 高亮显示搜索结果
set incsearch           " 开启实时搜索功能
set ignorecase          " 搜索时大小写不敏感
set smartcase           " 搜索智能匹配大小写


" Appearence - Scrollbar, Highlight, Linenumber {{{ "

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guioptions-=T " Also disable toolbar

" Enable syntax highlighting
syntax enable

set shortmess=aoOtTI " Abbrev. of messages

" Highlight current line
set cursorline

" the mouse pointer is hidden when characters are typed
set mousehide

" Always show current position
set ruler

" Show line number by default
set number norelativenumber

" Turn spell check off
set nospell

" Height of the command bar
set cmdheight=1
" Turn on the Wild menu
set wildmenu
set wildmode=list:longest,full
" Ignore compiled files
set wildignore=*.so,*.swp,*.pyc,*.pyo,*.exe,*.7z
if has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*,*\desktop.ini
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" }}} Appearence - Scrollbar, Highlight, Linenumber "

" Edit - Navigation, History, Search {{{ "

" Make cursor always on center of screen by default
if !exists('g:rc_always_center')
    let g:rc_always_center = 1
else
    if g:rc_always_center == 0 | augroup! rc_always_center | endif
endif

augroup rc_always_center
    autocmd!
    autocmd VimEnter,WinEnter,VimResized * call RCAlwaysCenterOrNot()
augroup END

function! RCAlwaysCenterOrNot()
    if g:rc_always_center
        " Use <Enter> to keep center in insert mode, need proper scrolloff
        let &scrolloff = float2nr(floor(winheight(0) / 2) + 1)
        inoremap <CR> <CR><C-o>zz
    else
        let &scrolloff = 0
        silent! iunmap <CR>
    endif
endfunction

" Make moving around works well in multi lines
map <silent> j gj
map <silent> k gk

set virtualedit=block

" How many lines to scroll at a time, make scrolling appears faster
" set scrolljump=3

set sessionoptions-=options " Don't restore all options and mappings

" Restore last session automatically (default off)
if !exists('g:rc_restore_last_session') | let g:rc_restore_last_session = 0 | endif

" Always save the last session
augroup rc_save_session
    autocmd!
    autocmd VimLeave * exe ":mksession! ~/.vim/.last.session"
augroup END

" Try to restore last session
augroup rc_restore_session
    autocmd!
    autocmd VimEnter * call RCRestoreLastSession()
augroup END

function! RCRestoreLastSession()
    if g:rc_restore_last_session
        if filereadable(expand("~/.vim/.last.session"))
           exe ":source ~/.vim/.last.session"
       endif
   endif
endfunction

" Restore the last session manually
if filereadable(expand("~/.vim/.last.session"))
    nnoremap <silent> <Leader>r :source ~/.vim/.last.session<CR>
endif

set completeopt=menu,preview,longest
set pumheight=10

" Automatically close the preview window when popup menu is invisible
if !exists('g:rc_auto_close_pw')
    let g:rc_auto_close_pw = 1
else
    if g:rc_auto_close_pw == 0 | augroup! rc_close_pw | end
endif

augroup rc_close_pw
    autocmd!
    autocmd CursorMovedI,InsertLeave * call RCClosePWOrNot()
augroup END

function! RCClosePWOrNot()
    if g:rc_auto_close_pw
        if !pumvisible() && (!exists('*getcmdwintype') || empty(getcmdwintype()))
            silent! pclose
        endif
    endif
endfunction

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

" Visually select the text that was last edited/pasted
nnoremap <expr> gV '`[' . strpart(getregtype(), 0, 1) . '`]'

" Set to auto read when a file is changed from the outside
set autoread

set autowrite " Automatically write a file when leaving a modified buffer

set updatetime=200

" Set how many lines of history VIM has to remember
set history=1000 " command line history

" Don't backup orignal files
set nobackup
set nowritebackup

" Swap files are necessary when crash recovery
if !isdirectory($HOME . "/.vim/swapfiles") | call mkdir($HOME . "/.vim/swapfiles", "p") | endif
set dir=$HOME/.vim/swapfiles//

" Turn persistent undo on, means that you can undo even when you close a buffer/VIM
set undofile
set undolevels=1000

if !isdirectory($HOME. "/.vim/undotree") | call mkdir($HOME . "/.vim/undotree", "p") | endif
set undodir=$HOME/.vim/undotree//

" For regular expressions turn magic on
set magic

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't wrap around when jumping between search result
" set nowrapscan

" Disable highlight when <Backspace> is pressed
nnoremap <silent> <BS> :nohlsearch<CR>

" }}} Edit - Navigation, History, Search "

" Buffer - BufferSwitch, FileExplorer, StatusLine {{{ "

" A buffer becomes hidden when it is abandoned
set hidden

set autochdir " change current working directory automatically

let g:netrw_liststyle = 3
let g:netrw_winsize = 30
nnoremap <silent> <Leader>e :Vexplore <C-r>=expand("%:p:h")<CR><CR>
autocmd FileType netrw setlocal bufhidden=delete

" Specify the behavior when switching between buffers
set switchbuf=useopen
set showtabline=1

set splitright " Puts new vsplit windows to the right of the current
set splitbelow " Puts new split windows to the bottom of the current

" Split management
nnoremap <silent> [b :bprevious<cr>
nnoremap <silent> ]b :bnext<cr>
nnoremap <silent> <C-k> :resize +2<CR>
nnoremap <silent> <C-j> :resize -2<CR>
nnoremap <silent> <C-h> :vertical resize +4<CR>
nnoremap <silent> <C-l> :vertical resize -4<CR>

" Always show status line
set laststatus=2
set statusline=%<%f\ " filename
set statusline+=%w%h%m%r " option
set statusline+=\ [%{&ff}]/%y " fileformat/filetype
set statusline+=\ [%{getcwd()}] " current dir
set statusline+=\ [%{&encoding}] " encoding
set statusline+=%=%-14.(%l/%L,%c%V%)\ %p%% " Right aligned file nav info

" }}} Buffer - BufferSwitch, FileExplorer, StatusLine "
" ##编辑格式 End

" ##鼠标 Start
" 鼠标可复制粘贴功能
if has( 'mouse' )
     set mouse-=a
endif
" ##鼠标 End

" ##键功能 Start
" backspace可向左删除 
set backspace=eol,start,indent

" 与vsc保持一致leader and esc
let g:mapleader = "\<Space>"
imap jj <Esc>
" ##键功能 End

" ##插件 Start
" Vim 8+ packages, 不使用其他包管理器
" NERDTree 目录树 https://github.com/preservim/nerdtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif


" NERD Commenter 快捷注释 https://github.com/preservim/nerdcommenter
" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1


" 以下可选:
" TagList 显示宏/变量/函数等Tag(依赖ctags) https://vim-taglist.sourceforge.net/installation.html
" YouCompleteMe 代码补全(python) https://github.com/tabnine/YouCompleteMe
" Syntastic语法检查 https://github.com/vim-syntastic/syntastic

" ##插件 End

"END .vimrc
