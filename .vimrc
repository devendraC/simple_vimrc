" Don't try to be vi compatible
set nocompatible

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
Plug 'yegappan/mru'
Plug 'majutsushi/tagbar'
Plug 'richq/vim-cmake-completion'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
if has('macunix')
  Plug 'xavierd/clang_complete'
endif
call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""

" Common settings
set encoding=utf-8
set ffs=unix,dos,mac
set title             " Change terminal title
set tags=./tags;      " Find ctags recursively
"set paste            " This is useful if you want to cut/copy-paste from external system to vim.
                      " This disables many features (including autoindent, tabstop etc.)

" Editor appearance
syntax on             " Turn on syntax highlighting
colorscheme desert
set history=200       " Keep 200 lines of command line history
set showcmd           " Show me what I'm typing
set showmatch         " Show matching bracket/parenthesis/etc
set title             " Change terminal title (as you tab to different file)
set number            " Show line numbers
set ruler             " Show file stats
set list              " enable visualization of tab, new-line.
set listchars=tab:>-  " Visualize tabs
set splitright        " Vertical windows should be split to right
set splitbelow        " Horizontal windows should split to bottom
augroup vimrc_help    " open help window in right vertical split (in place of bottom horizontal split)
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END

" Spelling check
set spelllang=en_us   " Set US English for spell checking.
" set spell           " Enable spell-check for all file types.
" always put autocmd inside augroup (to avoid executing each time you source .vimrc)
augroup forspellcheck
  autocmd!
" Enable spell checking for text, markdown and git commit only.
  autocmd FileType text,markdown,gitcommit setlocal spell
  autocmd BufRead,BufNewFile *.md setlocal spell
augroup END

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

" Indentation
set autoindent
set smartindent
set formatoptions=tcqrn1
set expandtab                   " Use space(s) for autoindent or when  when <TAB> is pressed
set tabstop=2                   "
set softtabstop=2               " Number of spaced to use when pressing <Tab> in editing mode.
set shiftwidth=2                " Spaces to use for each step of (auto)indent (including commands << and >>).
set noshiftround
set backspace=indent,eol,start  " Powerful backspace.
" backspace=indent  - Allow erasing indentation.
" backspace=eol     - Allow erasing end-of-line (using backspace at start of a line will join it to the previous line).
" backspace=start   - Allow erasing past the position where you started Insert mode.

" Text wrapping
set nowrap            " Don't wrap (effect display only)
set linebreak         " Wrap at boundary (e.g. at word boundary - when wrap is not off) - effect display only.
set textwidth=120     " Physically wrap after 120 characters.

" No backup files but do auto-save
set noswapfile        " Don't use swapfile
set nobackup          " Get rid of anoying ~file
set autowrite         " Auto save file after running certain commands (including make, next, previous).
set autoread          " Auto reload the file if it changes outside of vim.

" Joining (NOTE: Use shift+J for joining next line)
set nojoinspaces      " Remove duplicate spaces when joining.
set formatoptions+=j  " Remove comment leader when joining lines

" Remove trailing whitespace (when saving)
augroup remove_trailing_whitespace
  autocmd!
  autocmd BufWritePre * :call RemoveTrailingWhitespace()
augroup end

" Completion menu setings
set completeopt=menu,menuone,longest,preview

" enables undo files even if you exit Vim.
if has('persistent_undo')
  set undofile
  set undodir=~/.vim/undo/
  set undolevels=1000
  set undoreload=10000
endif

" Enable to copy to clipboard for operations like yank, delete, change and put
" http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
if has('unnamedplus')
  set clipboard^=unnamed
  set clipboard^=unnamedplus
endif


" Workaround if the last cusror position is not being saved
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
 " \ | endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RemoveTrailingWhitespace()
  if !exists("g:dont_remove_trailing_whitespace")
    %s/\s\+$//e
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                    ctags
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important commands:
"   :stag <symbol> --> Opens the file containing definition of <symbol> in split window.
"   :tag <symbol>  --> Same as above except open in same window.
"   :stag <file>   --> Opens the file, irrespective of where it is located (ctags must be generated using --extra=+f).
"   :tag <symbol>  --> Same as above except open in same window.
" Generate ctags using:
"   ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --extra=+f --language-force=C++ --exclude=.git *
"     -R
"       - Recursively enters to sub directories for generating tags.
"     --c++-kinds=+p
"        - Correctly identify if a scope specifier is a class name or a namespace specifier.
"        - Add access specification (e.g. public, private) and implementation information (e.g. virtual).
"     --fields=+iaS
"       a   Access (or export) of class members
"       i   Inheritance information
"       S   Signature of routine (e.g. prototype or parameter list)
"      --extra=+q
"         - Generate a second, class-qualified tag for each class member in the form class::member for C++.
"     p--extra=+f
"         - Add file paths in the generated tags file.
"     --language-force=C++
"         - Forces the specified language to be used for every supplied file instead of automatically selecting the
"         language based upon its extension.

" Mapping to switch between C/C++ source and header file (the ctags must have been genarted using --extra=+f).
nnoremap <leader>a :<c-u>tjump /^<c-r>=expand("%:t:r")<cr>\.\(<c-r>=join(get(
    \ {
    \ 'c':   ['h'],
    \ 'cpp': ['h','hpp'],
    \ 'h':   ['c','cpp'],
    \ 'hpp': ['cpp']
    \ },
    \  expand("%:e"), ['UNKNOWN EXTENSION']), '\\\|')<cr>\)$<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             Global Common Mappings
"                             -------------------------
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set leader shortcut to a comma ','. By default it's the backslash
let mapleader = ","

" Vim standard key mappings:
" --------------------------
"   - Help              :K (in normal mode)             --> open the man page for the keyword under the cursor.
"   - Open file         gf                              --> Opens the file under cursor (uses path to find the file).
"                       CTRL-^ or CTRL-o                --> Return to previous buffer (previously file).
"   - Open file         CTRL-w gf                       --> Opens the file in new tab (uses path to find the file).
"   - Word completion   CTRL-n (in editing mode)        --> n-next suggestion, CTRL-p (for previous).
"   - Code completion   CTRL-x CTRL-o (in editing mode) --> called 'omnifunc'.
"   - Go to definition  CTRL-]                          --> Needs ctags. Opens the definition file in same window.
"   - Go to definition  CTRL-w CTRL-]                   --> Needs ctags. Opens the definition file in new split window.
"   - Go back           CTRL-t                          --> Jump back to the previous file.
"
" Mapping to open go to definition in vertical split (using ] without CTRL)
nnoremap ] :vert winc ]<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             Settings for vim plugins
"                             -------------------------
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerdtree (Display Disrectory and File tree in side bar)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F9> :NERDTreeToggle<CR>
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeShowBookmarks=1
" Store the bookmarks file
let NERDTreeBookmarksFile=expand("$HOME/.vim/nerdtree_bookmarks")
" show nerdtree on the right side
let g:NERDTreeWinPos = "right"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MRU (Show most recently opened file)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" https://github.com/yegappan/mru/wiki/User-Manual
" Important commands:
"   :MRU      - Display MRU window.
"   <CR>      - Opens selected file in the same window (opens in a new tab if MRU_Open_File_Use_Tabs = 1).
"   o         - Opens the selected file in a split.
"   t         - Opens the selected file in new tab.
"   <N>o/t    - Opens N files (you can also visually select multiple filenames).
"
let MRU_File = expand("$HOME/.vim/mru_files")
let MRU_Max_Entries = 20
let MRU_Window_Height = 15          " The default height of the MRU window is 8.
let MRU_Open_File_Use_Tabs = 1      " Opens the selected file in new tab rather than current tab.
"let MRU_Auto_Close = 0             " To keep the MRU window open, after selecting the file.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TagBar (Displays Class and File structure in side bar)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important commands:
"   :TagbarToggle - Show tagbar window.
"
" Commands in tagbar window:
"   <F1>    - Display tagbar help.
"   <CR>    - Jump to tag definition
"   <Space> - Display tag prototype
"   <C-n>   - Go to next top-level tag
"   <C-p>   - Go to previous top-level tag
"
nmap <F8> :TagbarToggle<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-cmake-completion (code completion for cmake)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important commands:
"   - Word completion   CTRL-n/CTRL-p (in editing mode)  --> Vim's standard feature (n - next/p - previous)
"   - Code completion   CTRL-x CTRL-o (in editing mode)  --> Vim's standard feature ('omnifunc')


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" python-mode (all-in-one plugin for python)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-go (all-in-one plugin for golang)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   https://github.com/fatih/vim-go-tutorial
"   https://github.com/fatih/vim-go.git
" Important commands:
"   - Word completion   CTRL-n/CTRL-p (in editing mode)  --> Vim's standard feature (n - next/p - previous)
"   - Code completion   CTRL-x CTRL-o (in editing mode)  --> Vim's standard feature (called 'omnifunc')
"   - Go to definition  CTRL-w CTRL-]                    --> standard way.
"   - Run               ,r (<leader>r)
"   - Build             ,b (<leader>b)
"   - Help              :GoDoc(K) (Opens go doc in vim; K- Knowledge base, Vim standard key for man page).
"   - GoDocBrowser      :GoDocBrowser (Opens go doc in the browser for the keyword under cusrosr)
"   - GoPlay            :GoPlay (Share your current code to play.golang.org)
" Build using ,b (or :GoBuild)
autocmd FileType go nmap <leader>b  <Plug>(go-build)
" Run using ,r (or :GoRun)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
" open go doc in browser using CTRL-k (or :GoDocBrowser)
autocmd FileType go nmap <C-k> <Plug>(go-doc-browser)
" open go doc in vertical split
" autocmd FileType go nmap <Leader>gd <Plug>(go-doc-vertical)
" jump to next error in the quickfix window
map <C-n> :cnext<CR>
" jump to previous error in the quickfix window
map <C-m> :cprevious<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" clang_complete (C++ code completion for clang)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important commands:
"   - Word completion   CTRL-n/CTRL-p (in editing mode)  --> Vim's standard feature (n - next/p - previous)
"   - Code completion   CTRL-x CTRL-o (in editing mode)  --> Vim's standard feature (called 'omnifunc')
"   - Go to definition  CTRL-w CTRL-]                    --> Standard way. ???
let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
let g:clang_snippets = 1
let g:clang_snippets_engine = 'clang_complete'
" Compiler options can be configured in a .clang_complete file in the project's root directory.
" To generate the file using cmake:
"   CXX='~/.vim/plugged/clang_complete/bin/cc_args.py clang++' cmake ..
"   make (copy .clang_complete to the project root directory)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" load your custome vimrc here
let local_vimrc = "~/.vimrc.local"
if filereadable(expand(local_vimrc))
    exe 'source' local_vimrc
endif

