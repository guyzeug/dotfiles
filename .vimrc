""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 01. General                                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use Vim settings, rather then Vi settings. This setting must be as early as
" possible, as it has side effects.
set nocompatible

set backupdir=$home/vim_temp/backup//
" adding double slash at then end of the swap path makes the backup filenames
" include their location so that two files with the same name can be edited at
" the same time and have two different backup files
set directory=$home/vim_temp/swp//

" swap ; and : Convenient
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" jk is escape
inoremap jk <esc>

" To stop using the arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" The way it should have been.
noremap Y y$

" If a file is changed outside of vim, automatically reload it without asking
set autoread

" Cross platform solution to copy / paste using the system's clipboard
set clipboard^=unnamed,unnamedplus
" If for any reason the line above does not work or show some limitations,
" look into doing the following:
" map <leader>y "+y
" map <leader>p "+p
" map <leader>P "+P
" map <leader>d "+d
" more ?

set matchpairs+=<:>

" The following line forces vim-plug to run on 1 thread, as the parallel
" install does not work at the moment on windows
let g:plug_threads = 1

call plug#begin('~/.vim/plugged')
" Add plugins to &runtimepath
Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'

Plug 'https://github.com/junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

Plug 'https://github.com/tpope/vim-commentary.git'
Plug 'scrooloose/nerdtree'
"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
nnoremap <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1
let NERDTreeShowHidden=1

" Press v over and over again to expand selection
Plug 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
call plug#end()

"" Wildcards to ignore
""
"" Finder metadata
set wildignore+=.DS_Store
"" Source control
set wildignore+=.git/**
set wildignore+=.hg/**
set wildignore+=.svn/**
set wildignore+=.keep,.gitkeep,.hgkeep
"" Temporary files
set wildignore+=tmp/**
set wildignore+=*.tmp
"" ~/.vim
set wildignore+=backup/**
set wildignore+=undo/**
"" Native objects/debug symbols/binaries
set wildignore+=*.o,*.obj,*.dSYM,*.exe,*.app,*.ipa
"" Java
set wildignore+=target/**
set wildignore+=*.class,*.jar
"" IDEA
set wildignore+=.idea/**
"" Ruby
set wildignore+=.bundle/**
"" Python
set wildignore+=*.pyc
"" CocoaPods/Carthage
set wildignore+=Pods/**
set wildignore+=Carthage/**
"" Common build directories
set wildignore+=build/**
set wildignore+=dist/**
"" Go (projects built with gb)
set wildignore+=vendor/src/**
"" JavaScript
set wildignore+=node_modules/**
"" Ansible
set wildignore+=.imported_roles/**

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 02. Events                                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on " filetype detection[ON] plugin[ON] indent[ON]

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 03. Theme/Colors                                                           "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set the font depending on the client
if has("gui_running")
    if has("gui_gtk2")
        set guifont=Inconsolata\ 14
    elseif has("gui_macvim")
        set guifont=Menlo\ Regular:h14
    elseif has("gui_win32")
        set guifont=Consolas:h11:cANSI
    endif
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
else
    set guifont=Consolas:h11:cANSI
endif

set t_Co=256              " enable 256-color mode
syntax enable             " enable syntax highlighting (previously syntax on)
colorscheme desert        " set colorscheme

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 04. Vim UI                                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number                " show line numbers
set relativenumber        " show relative numbers
set nocursorline          " do not highlight current line (it can make redrawing window slow)
set laststatus=2          " last window always has a statusline
set hlsearch              " highlight all search matches
set incsearch             " But do highlight as you type your search
set ignorecase smartcase  " make searches case-sensitive only if they contain upper-case characters
set gdefault              " Never have to type /g at the end of search / replace again
set ruler                 " Always show info along bottom
set noshowmatch           " Don't jump cursor to matching brace
set cmdheight=1
set scrolloff=5           " always show me the next/previous 5 lines
set showcmd               " display incomplete commAnd

set equalalways           " Multiple windows, when created, are equal in size"
set splitbelow splitright " Put the new windows to the right/bottom"

" Don't update the display while executing macros
set lazyredraw

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 05. Text Formatting/Layout                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent            " auto-indent
set tabstop=4             " tab spacing
set softtabstop=4         " unify
set shiftwidth=4          " indent/outdent by 4 columns
set shiftround            " always indent/outdent to the nearest tabstop
set expandtab             " use spaces instead of tabs
"set smartindent           " automatically insert one extra level ofi ndentation
"set smarttab              " use tabs at the start of a line, spaces elsewhere
set nowrap                " don't wrap text

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 06. Key Bindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = "\<Space>"
let maplocalleader = ","

nnoremap ,w :update<CR>
nnoremap ,<Leader> V
"nnoremap <Leader>ev :vsplit ~/.vimrc<CR>   " split vertically and
" edit vimrc
"nnoremap <Leader>sv :source ~/.vimrc<CR>   " reload .vimrc

" Visual mode mappings
vnoremap < <gv
vnoremap > >gv

" Execute dot in the selection
vnoremap . :norm.<CR>

" Moving in buffers.
nnoremap <C-S-tab> :bprev<CR>
nnoremap <C-tab> :bnext<CR>

" Moving and resizing in windows.
nnoremap + <C-W>+
nnoremap _ <C-W>-
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" close window
nnoremap <leader>w <C-w>c

" Moving in tabs
noremap <c-right> gt
noremap <c-left> gT

"" Flip-flop buffers
nnoremap <leader><leader> <C-^>

" CtrlP keybindings
nnoremap <leader>ff :CtrlP .<cr>
nnoremap <leader>fj :execute ":CtrlP " . expand('%:p:h')<cr>

" ------------------------------------------------
" TO CONFIRM
set lines=35 columns=150

" Clear highlight search results with <esc> nnoremap <esc>
" :nohlsearch<return><esc> nnoremap <silent> <leader>, :noh<cr> " Stop
" highlight after searching

set showmode

" apparently this is how to avoid automatic line breaks when typing long lines
set textwidth=0
set wrapmargin=0

" Open new split panes to right and bottom, which feels more natural set
" splitbelow
set splitright

" make tab completion for files/buffers act like bash
set wildmenu
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" or
set wildmode=list:longest,full
" allow unsaved background buffers and remember marks/undo for them
set hidden

" Move lines with Alt + j / k
" nnoremap <A-j> :m .+1<CR>==
" nnoremap <A-k> :m .-2<CR>==
" inoremap <A-j> <Esc>:m .+1<CR>==gi
" inoremap <A-k> <Esc>:m .-2<CR>==gi
" vnoremap <A-j> :m '>+1<CR>gv=gv
" vnoremap <A-k> :m '<-2<CR>gv=gv

" move vertically by visual line
"nnoremap j gj
"nnoremap k gk
"vnoremap j gj
"vnoremap k gk

set report=0 " Tell me how many lines commands change. Always.
" what to show when I hit :set list
"set listchars=eol:¬,tab:▸\ ,trail:·,extends:❯,precedes:❮,nbsp:⁝

" Display extra whitespace
"set list listchars=tab:»·,trail:·,nbsp:·

set fileformat=unix
set fileformats=unix,dos,mac " support all three file-format with unix no. 1
set encoding=utf-8 " Force UTF-8 as default
set termencoding=utf-8 " Also for terminals.

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
" GLG => initial feedback is that it can be visually annoying
"map N Nzz
"map n nzz

" Taken from: https://github.com/colbycheeze/dotfiles/blob/master/vimrc
" Use enter to create new lines w/o entering insert mode
"nnoremap <CR> o<Esc>
" Below is to fix issues with the ABOVE mappings in quickfix window
"autocmd CmdwinEnter * nnoremap <CR> <CR>
"autocmd BufReadPost quickfix nnoremap <CR> <CR>

" set ttyfast                   " we have a fast terminal

" Use Q for formatting the current paragraph (or selection)
" vmap Q gq
" nmap Q gqap
" ------------------------------------------------


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 07. Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Ctrl-P settings.
"------------------------------------------------------------------------
let g:ctrlp_max_files=0 " maximum number of files to scan (0 = no limit)
let g:ctrlp_working_path_mode='' " apparently needed (tested on dev.php)
let g:ctrlp_open_new_file = 'r' " open new file in current window
let g:ctrlp_match_window = 'results:100' " increase the number of suggestions. If this is to slow remove
                                          " this line and when CtrlP is open use
                                          "    Ctrl-D to switch between file / path mode
                                          "    Ctrl-R to switch between regex / non regex mode

augroup vimrcFileTypes
  " Clear all autocmds in the group
  autocmd!
  autocmd BufRead,BufNewFile Fastfile    set      filetype=ruby
  autocmd BufRead,BufNewFile *gemrc*     set      filetype=yaml
  autocmd BufRead,BufNewFile *.gradle    set      filetype=groovy
  autocmd BufRead,BufNewFile *.hjs       set      filetype=handlebars
  autocmd BufRead,BufNewFile jquery.*.js set      filetype=javascript syntax=jquery
  autocmd BufRead,BufNewFile *.jquery.js set      filetype=javascript syntax=jquery
  autocmd BufRead,BufNewFile *.json      set      filetype=javascript
  autocmd BufRead,BufNewFile *.mako      set      filetype=mako
  autocmd BufRead,BufNewFile *.ru        set      filetype=ruby
  autocmd BufRead,BufNewFile *.socket    set      filetype=systemd
  autocmd BufRead,BufNewFile Procfile    set      filetype=yaml
  autocmd BufRead,BufNewFile *vimrc*     set      filetype=vim
  autocmd BufRead,BufNewFile *.yml       set      filetype=yaml
  autocmd BufRead,BufNewFile *.zsh*      set      filetype=zsh
  autocmd FileType           gitcommit   setlocal spell
  autocmd FileType           latex       setlocal spell
  autocmd FileType           markdown    setlocal spell
  autocmd FileType           plaintex    setlocal spell
  autocmd FileType           text        setlocal spell
augroup END

augroup vimrcWhiteSpaces
  " Clear all autocmds in the group
  autocmd!
  " Delete trailing spaces on save
  autocmd BufWritePre * :%s/\s\+$//e
augroup END

"" Syntastic options
let g:syntastic_check_on_open = 1
let g:syntastic_quiet_messages = {'level': 'warnings'}


""
"" Indent options - default is 2 spaces
""
function! Spaces(num)
  set expandtab
  set smarttab
  let &tabstop = a:num
  let &softtabstop = 0
  let &shiftwidth = a:num
endfunction

function! Tabs(size)
  set noexpandtab
  set nosmarttab
  let &tabstop = a:size
  let &softtabstop = 0
  let &shiftwidth = a:size
endfunction

"" editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

"" Initialize indentation
call Spaces(2)

augroup vimrcSpacesAndTabs
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType           *            call Spaces(2)
  autocmd FileType           apiblueprint call Spaces(4)
  autocmd FileType           cpp          call Spaces(4)
  autocmd FileType           java         call Spaces(4)
  autocmd FileType           lua          call Spaces(4)
  autocmd FileType           php          call Spaces(4)
  autocmd FileType           python       call Spaces(4)
  autocmd FileType           scala        call Spaces(4)
  autocmd FileType           typescript   call Spaces(4)
  autocmd FileType           xml          call Spaces(4)
  autocmd FileType           bindzone     call Tabs(8)
  autocmd FileType           c            call Tabs(8)
  autocmd FileType           gitconfig    call Tabs(8)
  autocmd FileType           make         call Tabs(8)
  autocmd BufRead,BufNewFile *.plist      call Tabs(8)
  autocmd FileType           sudoers      call Tabs(8)
  autocmd FileType           go           call Tabs(4)
augroup END

""
"" Keymap functions
""
function! s:MapHashrocket()
  inoremap <C-l> <space>=><space>
endfunction

function! s:MapLeftArrow()
  inoremap <C-l> <-
endfunction

function! s:MapRightArrow(spaces)
  if a:spaces == 0
    inoremap <C-l> ->
  elseif a:spaces == 1
    inoremap <C-l> <space>->
  elseif a:spaces > 1
    inoremap <C-l> <space>-><space>
  endif
endfunction

augroup vimrcArrow
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType php        call s:MapHashrocket()
  autocmd FileType ruby       call s:MapHashrocket()
  autocmd FileType eruby      call s:MapHashrocket()
  autocmd FileType haml       call s:MapHashrocket()
  autocmd FileType puppet     call s:MapHashrocket()
  autocmd FileType scala      call s:MapHashrocket()
  autocmd FileType javascript call s:MapHashrocket()
  autocmd FileType typescript call s:MapHashrocket()
  autocmd FileType go         call s:MapLeftArrow()
  autocmd FileType c          call s:MapRightArrow(0)
  autocmd FileType cpp        call s:MapRightArrow(0)
  autocmd FileType objc       call s:MapRightArrow(0)
  autocmd FileType coffee     call s:MapRightArrow(1)
  autocmd FileType java       call s:MapRightArrow(2)
  autocmd FileType rust       call s:MapRightArrow(2)
  autocmd FileType swift      call s:MapRightArrow(2)
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
" Taken from: https://github.com/garybernhardt/dotfiles/blob/master/.vimrc#L90
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" Add support for <> in vim-expand-region
call expand_region#custom_text_objects({
      \ 'i>' :1,
      \ })
