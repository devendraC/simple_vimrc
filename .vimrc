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
set history=200       " keep 200 lines of command line history
set showcmd           " Show me what I'm typing
set number            " Show line numbers
set ruler             " Show file stats
set list              " enable visualization of tab, new-line.
set listchars=tab:>-  " Visualize tabs
set splitright        " Vertical windows should be split to right
set splitbelow        " Horizontal windows should split to bottom
" open help window in right vertical split (in place of bottom)
augroup vimrc_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END
" In my vim, the last cusror position was not being saved.
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
 " \ | endif


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
"   - Word completion   CTRL-n/CTRL-p (in editing mode)  --> Vim's standard feature (n - next/p - previous)
"   - Code completion   CTRL-x CTRL-o (in editing mode)  --> Vim's standard feature ('omnifunc')


"""""""""""""""""""""""""""""""""""""""""""""""""
" python-mode (all-in-one plugin for python)
"""""""""""""""""""""""""""""""""""""""""""""""""
" Important commands:
"   - Word completion   CTRL-n/CTRL-p (in editing mode) --> Vim's standard feature (n - next/p - previous)
"   - Code completion   CTRL-x CTRL-o (in editing mode) --> Vim's standard feature (called 'omnifunc')
"                       .(period) (in editing mode)     --> auto pop-up (use CTRL-<space>)
"   - Go to definition  CTRL-w CTRL-]                    --> mapping needed (see below)
"   - Help              K (K - Knowledge base, Vim standard key to open man page for the keyword under the cursor)
"   - Run               ,r (<leader>r)
"   - Breakpoint        ,b (<leader>b)
"   - Jump to next class/function/method (The feature can be disbled by let g:pymode_motion = 0)
"       [[    Jump to previous class or function.
"       ]]    Jump to next class or function.
"       [M    Jump to previous class or method.
"       ]M    Jump to next class or method.
"   - Linting (To disable let g:pymode_lint = 0 or :PymodeLintToggle)
"       :PymodeLintAuto   -- Fix PEP8 errors in current buffer automatically
"       :PymodeLint       -- Check code in current buffer (it is automatically done when saving the file)
"   - Auto import
"     :PymodeRopeAutoImport -- Resolve import for element under cursor
"
let g:pymode_rope = 1                                 " enable rope commands (default disabled)
let g:pymode_rope_autoimport=1                        " auto-complete objects which have not been imported from project
let g:pymode_rope_goto_definition_bind = '<C-w><C-]>' " go to the definition
let g:pymode_rope_goto_definition_cmd = 'vnew'        " open definition in vertical split
"   TODO:
"     - Code refactoring <rope refactoring library> (rope_)
"     - Strong code completion (rope_)
"     - Go to definition (``<C-c>g`` for `:RopeGotoDefinition`)
"     Keymap for rename method/function/class/variables under cursor
"         let g:pymode_rope_autoimport_bind = '<C-c>ra'
let g:pymode_options_max_line_length = 120 " default is 79


"""""""""""""""""""""""""""""""""""""""""""""""""
" vim-go (all-in-one plugin for golang)
"""""""""""""""""""""""""""""""""""""""""""""""""
"   https://github.com/fatih/vim-go-tutorial
"   https://github.com/fatih/vim-go.git
" Important commands:
"   - Word completion   CTRL-n/CTRL-p (in editing mode)  --> Vim's standard feature (n - next/p - previous)
"   - Code completion   CTRL-x CTRL-o (in editing mode)  --> Vim's standard feature (called 'omnifunc')
"   - Go to definition  CTRL-w CTRL-]                    --> standard way.
"   - Run               ,r (<leader>r)
"   - Build             ,b (<leader>b)
"   - Help              :GoDoc(K) (K- Knowledge base, Vim standard key to open the man page for the keyword under the cursor.)
"   - GoDocBrowser      :GoDocBrowser(ctrl-k) (Open go doc in the browser for the keyword under cusrosr)
"   - GoPlay            :GoPlay (Share your current code to play.golang.org)
" Build using ,b (or :GoBuild)
autocmd FileType go nmap <leader>b  <Plug>(go-build)
" Run using ,r (or :GoRun)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
" open go doc in browser
autocmd FileType go nmap <C-k> <Plug>(go-doc-browser)
" open go doc in vertical split
" autocmd FileType go nmap <Leader>gd <Plug>(go-doc-vertical)
" jump to next error in the quickfix window
map <C-n> :cnext<CR>
" jump to previous error in the quickfix window
map <C-m> :cprevious<CR>
" nmap <F7> :GoPlay <CR>


"""""""""""""""""""""""""""""""""""""""""""""""""
" clang_complete (C++ code completion for clang)
"""""""""""""""""""""""""""""""""""""""""""""""""
" Important commands:
"   - Word completion   CTRL-n/CTRL-p (in editing mode)  --> Vim's standard feature (n - next/p - previous)
"   - Code completion   CTRL-x CTRL-o (in editing mode)  --> Vim's standard feature (called 'omnifunc')
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

