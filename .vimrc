" Don't try to be vi compatible
set nocompatible
set encoding=utf-8
colorscheme desert

"""""""""""""""""""""""""""""""""""""""""""""""
" Load plugins manager (pathogen or vundle)
filetype off              " Helps force plugins to load correctly when it is turned back on below
" Load pathogen (https://github.com/tpope/vim-pathogen)
execute pathogen#infect()
" To see help of a installed vim plugin use :help <plugin-name> (e.g. :help vim-go)
filetype plugin indent on " For plugins to load correctly
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

" mapping for toggling Tagbar window (for tagbar plugin)
nmap <F8> :TagbarToggle<CR>

" YCM settings:
" Not using YCM
" let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

" clang_complete settings (C++ code completion for clang) - https://github.com/xavierd/clang_complete
let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
let g:clang_snippets = 1
let g:clang_snippets_engine = 'clang_complete'
" Compiler options can be configured in a .clang_complete file in the project's root directory.
" To generate the file using cmake:
"   CXX='~/.vim/bundle/clang_complete/bin/cc_args.py clang++' cmake ..
"   make (copy .clang_complete to the project root directory)

" vim-go settings
" https://github.com/fatih/vim-go.git
" https://github.com/fatih/vim-go-tutorial
" Build using ,b (or :GoBuild)
autocmd FileType go nmap <leader>b  <Plug>(go-build)
" Run using ,r (or :GoRun)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
" jump to next error in the quickfix window
map <C-n> :cnext<CR>
" jump to previous error in the quickfix window
map <C-m> :cprevious<CR>
" Share your current code to play.golang.org with F7 or |:GoPlay|.
nmap <F7> :GoPlay <CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

