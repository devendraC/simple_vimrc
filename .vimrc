" Don't try to be vi compatible
set nocompatible
set encoding=utf-8
set ffs=unix,dos,mac
colorscheme desert


"""""""""""""""""""""""""""""""""""""""""""""""
" Load plugins manager (pathogen, vundle, vim-plugin)
" Using plugin manager vim-plugin (https://github.com/junegunn/vim-plug)
" With vim-plug, no need to turn off/on for filetype plugin
" filetype plugin indent off
" filetype plugin indent on
" NOTE:
"   - After adding a new plugin you need to reload .vimrc and call :PlugInstall
"   - To see help of a installed vim plugin use :help <plugin-name> (e.g. :help vim-go)
call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'richq/vim-cmake-completion'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'xavierd/clang_complete'
call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""

syntax on             " Turn on syntax highlighting
set noswapfile        " Don't use swapfile
set nobackup          " Get rid of anoying ~file
set autowrite         " Auto save file after running certain commands (including make, next, previous).
set autoread          " Auto reload the file if it changes outside of vim.
set splitright        " Vertical windows should be split to right
set splitbelow        " Horizontal windows should split to bottom
set history=200       " keep 200 lines of command line history
set showcmd           " Show me what I'm typing
set number            " Show line numbers
set ruler             " Show file stats
set list              " enable visualization of tab, new-line.
set listchars=tab:>-  " Visualize tabs
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

" editor setup
" set backspace=indent,eol,start  " Makes backspace key more powerful.
set autoindent
set wrap                    " Whitespace
set textwidth=115
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" This enables us to undo files even if you exit Vim.
if has('persistent_undo')
  set undofile
  set undodir=~/.vim/undo//
endif

" Enable to copy to clipboard for operations like yank, delete, change and put
" http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
if has('unnamedplus')
  set clipboard^=unnamed
  set clipboard^=unnamedplus
endif

" for ctags
set tags=./tags;

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             Settings for vim plugins 
"                             -------------------------
" Set leader shortcut to a comma ','. By default it's the backslash
let mapleader = ","


"""""""""""""""""""""""""""""""""""""""""""""""""
" nerdtree
"""""""""""""""""""""""""""""""""""""""""""""""""
map <F8> :NERDTreeToggle<CR>
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeShowBookmarks=1


"""""""""""""""""""""""""""""""""""""""""""""""""
" vim-cmake-completion (code completion for cmake)
"""""""""""""""""""""""""""""""""""""""""""""""""
" Important commands:
"   - Code completion   CTRL-x CTRL-o (in editing mode)  --> Standard 'omnifunc'.
"   - Word completion   CTRL-n/CTRL-p (in editing mode)  --> Vim feature


"""""""""""""""""""""""""""""""""""""""""""""""""
" python-mode (all-in-one plugin for python)
"""""""""""""""""""""""""""""""""""""""""""""""""
" Important commands:
" Important commands:
"   - Code completion:
"                       CTRL-x CTRL-o (in editing mode)  --> Standard 'omnifunc'.
"                       .(period) (in editing mode)
"                       CTRL-<space>
"   - Word completion   CTRL-n/CTRL-p (in editing mode)  --> Standard way.
"   - Go to definition  CTRL-w CTRL-]                    --> Standard way.????
"   - Run         - ,r (<leader>r)
"   - Breakpoint  - ,b (<leader>b)
"   TODO:
"     :PymodeRopeAutoImport -- Resolve import for element under cursor
"     Keymap for rename method/function/class/variables under cursor
"         let g:pymode_rope_autoimport_bind = '<C-c>ra'


"""""""""""""""""""""""""""""""""""""""""""""""""
" vim-go (all-in-one plugin for golang)
"""""""""""""""""""""""""""""""""""""""""""""""""
"   https://github.com/fatih/vim-go-tutorial
"   https://github.com/fatih/vim-go.git
" Important commands:
"   - Code completion   CTRL-x CTRL-o (in editing mode)  --> Standard 'omnifunc'.
"   - Word completion   CTRL-n/CTRL-p (in editing mode)  --> Standard vim feature?
"   - Go to definition  CTRL-w CTRL-]                    --> Standard way.
"   - Run               ,r (<leader>r)
"   - Build             ,b (<leader>b)
"   - GoPlay            :GoPlay (Share your current code to play.golang.org)
nmap <F7> :GoPlay <CR>
" Build using ,b (or :GoBuild)
autocmd FileType go nmap <leader>b  <Plug>(go-build)
" Run using ,r (or :GoRun)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
" jump to next error in the quickfix window
map <C-n> :cnext<CR>
" jump to previous error in the quickfix window
map <C-m> :cprevious<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""
" clang_complete (C++ code completion for clang)
"""""""""""""""""""""""""""""""""""""""""""""""""
" Important commands:
"   - Code completion   CTRL-x CTRL-o (in editing mode)  --> Standard 'omnifunc'. ????
"   - Word completion   CTRL-n/CTRL-p (in editing mode)  --> Standard way. ???
"   - Go to definition  CTRL-w CTRL-]                    --> Standard way. ???
let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
let g:clang_snippets = 1
let g:clang_snippets_engine = 'clang_complete'
" Compiler options can be configured in a .clang_complete file in the project's root directory.
" To generate the file using cmake:
"   CXX='~/.vim/bundle/clang_complete/bin/cc_args.py clang++' cmake ..
"   make (copy .clang_complete to the project root directory)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" load your custome vimrc here
let local_vimrc = "~/.vimrc.local"
if filereadable(expand(local_vimrc))
    exe 'source' local_vimrc
endif

