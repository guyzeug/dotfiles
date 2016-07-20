set nocompatible          " get rid of Vi compatibility mode. SET FIRST!

" set the font depending on the client
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 14
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
else
  set guifont=Consolas:h11:cANSI
endif

let mapleader = ","
let maplocalleader = "\\"
nnoremap <Leader>w :w<CR>
nnoremap <Leader><Leader> V
nnoremap <Leader>ev :vsplit $home\dotfiles\.vimrc<CR>   " split vertically and
" edit vimrc
nnoremap <Leader>sv :source $home\dotfiles\.vimrc<CR>   " reload .vimrc 
nnoremap H 0
nnoremap L $
nnoremap <leader>j L
nnoremap <leader>k H

set hidden

set backupdir=$home/.vim/backup//
" adding double slash at then end of the swap path makes the backup filenames
" include their location so that two files with the same name can be edited at
" the same time and have two different backup files
set directory=$home/.vim/swp//

filetype plugin indent on " filetype detection[ON] plugin[ON] indent[ON]
set t_Co=256              " enable 256-color mode.
syntax enable             " enable syntax highlighting (previously syntax on).
colorscheme desert        " set colorscheme
set number                " show line numbers
set laststatus=2          " last window always has a statusline

filetype indent on        " activates indenting for files
set hlsearch            " Don't continue to highlight searched phrases.
set incsearch             " But do highlight as you type your search.
set ignorecase            " Make searches case-insensitive.
"set ruler                 " Always show info along bottom.
set autoindent            " auto-indent
set tabstop=4             " tab spacing
set softtabstop=4         " unify
set shiftwidth=4          " indent/outdent by 4 columns
set shiftround            " always indent/outdent to the nearest tabstop
set expandtab             " use spaces instead of tabs
"set smarttab              " use tabs at the start of a line, spaces elsewhere
set nowrap                " don't wrap text

set showmatch " show matching bracket


" swap ; and : Convenient
nnoremap ; :
nnoremap : ;

set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.

" move vertically by visual line
"nnoremap j gj
"nnoremap k gk


" jk is escape
inoremap jk <esc>

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
