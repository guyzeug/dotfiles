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

set hidden
set fileformat=unix
set fileformats=unix,dos,mac " support all three file-format with unix no. 1
set wildmode=list:longest,full
set matchpairs+=<:>

" Cross platform solution to copy / paste using the system's clipboard
set clipboard^=unnamed,unnamedplus

" swap ; and : Convenient
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" jk is escape
inoremap jk <esc>

" The way it should have been.
noremap Y y$

" move vertically by visual line
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" If for any reason the line above does not work or show some limitations,
" look into doing the following:
" map <leader>y "+y
" map <leader>p "+p
" map <leader>P "+P
" map <leader>d "+d
" more ?

" To stop using the arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>


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
" 02. Theme/Colors                                                           "
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

colorscheme desert        " set colorscheme


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 03. Vim UI                                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number                " show line numbers
set relativenumber        " show relative numbers
set nocursorline          " do not highlight current line (it can make redrawing window slow)
set hlsearch              " highlight all search matches
set ignorecase smartcase  " make searches case-sensitive only if they contain upper-case characters
set gdefault              " Never have to type /g at the end of search / replace again
set noshowmatch           " Don't jump cursor to matching brace
set cmdheight=1
set scrolloff=5           " always show me the next/previous 5 lines
set showcmd               " display incomplete command
set lines=50 columns=160
set noshowmode            " the mode information is displayed via lightline
set equalalways           " Multiple windows, when created, are equal in size"
set splitbelow splitright " Put the new windows to the right/bottom"
set lazyredraw            " Don't update the display while executing macros
set report=0              " Tell me how many lines commands change. Always.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 04. Text Formatting/Layout                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4             " tab spacing
set softtabstop=4         " unify
set shiftwidth=4          " indent/outdent by 4 columns
set shiftround            " always indent/outdent to the nearest tabstop
set expandtab             " use spaces instead of tabs


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 05. Key Bindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = "\<Space>"
let maplocalleader = ","

nnoremap ,w :update<CR>
nnoremap ,<Leader> V
" split vertically and edit vimrc
nnoremap <Leader>ev :vsplit ~/dotfiles/.vimrc<CR>
" reload .vimrc
nnoremap <Leader>sv :source ~/dotfiles/.vimrc<CR>

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

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 06. Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The following line forces vim-plug to run on 1 thread, as the parallel
" install does not work at the moment on windows
let g:plug_threads = 1

call plug#begin('~/.vim/plugged')
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'terryma/vim-expand-region'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-sensible'
Plug 'sheerun/vim-polyglot'
call plug#end()

" Ctrl-P settings.
"------------------------------------------------------------------------
let g:ctrlp_max_files=0 " maximum number of files to scan (0 = no limit)
let g:ctrlp_working_path_mode='' " apparently needed (tested on dev.php)
let g:ctrlp_open_new_file = 'r' " open new file in current window
let g:ctrlp_match_window = 'results:100' " increase the number of suggestions. If this is to slow remove
                                          " this line and when CtrlP is open use
                                          "    Ctrl-D to switch between file / path mode
                                          "    Ctrl-R to switch between regex / non regex mode

" Vim-Easy-Align settings.
"------------------------------------------------------------------------
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" NERDTree settings.
"------------------------------------------------------------------------
nnoremap <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1
let NERDTreeShowHidden=1

" Vim-Expand-Region settings.
"------------------------------------------------------------------------
" Press v over and over again to expand selection
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
" Add support for <>
call expand_region#custom_text_objects({
      \ 'i>' :1,
      \ })

" BufTabLine settings.
"------------------------------------------------------------------------
let g:buftabline_indicators=1
let g:buftabline_numbers=1

nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(10)

" Custom group             Default link      Meaning
" *BufTabLineCurrent*      |TabLineSel|        Buffer shown in current window
" *BufTabLineActive*       |PmenuSel|          Buffer shown in other window
" *BufTabLineHidden*       |TabLine|           Buffer not currently visible
" *BufTabLineFill*         |TabLineFill|       Empty area
hi! BufTabLineCurrent term=bold cterm=bold gui=bold guifg=peru
hi! BufTabLineFill guibg=slategrey
hi! BufTabLineActive ctermfg=8 ctermbg=0 guibg=slategrey
hi! BufTabLineHidden ctermfg=8 ctermbg=0 guibg=slategrey

" Syntastic settings.
"------------------------------------------------------------------------
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 09. Autocommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcFileTypes
  autocmd!
  autocmd FileType           gitcommit   setlocal spell
  autocmd FileType           latex       setlocal spell
  autocmd FileType           markdown    setlocal spell
  autocmd FileType           plaintex    setlocal spell
  autocmd FileType           text        setlocal spell
augroup END

" Remove trailing whitespaces on save
augroup vimrcWhiteSpaces
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
augroup END

" Keymap functions
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 09. Local settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif

