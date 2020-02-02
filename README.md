# simple_vimrc
A simple vim configuration file (.vimrc) for C++, golang and python development

## basic vim setup
In MacOS:
  - In MacOS, for many plugins require you to override default vim:
    brew install --with-override-system-vi vim
    brew upgrade vim
    brew info vim

  - Install exuberant ctags: brew install ctags

## Install vim-plugins (For added features e.g. auto code completion):
  - Setup vim plugin manager (I prefer pathogen) - Refer https://github.com/tpope/vim-pathogen

  - Plugin for displaying source code navigation in a sidebar:
    git clone https://github.com/majutsushi/tagbar ~/.vim/bundle/tagbar

  - Code completion for cmake:
    - git clone git@github.com:richq/vim-cmake-completion.git ~/.vim/bundle/vim-cmake-completion
    - For code completion use:CTRL-x CTRL-o (in editing mode)  --> This is standard 'omnifunc'.

  - Install golang plugin vim-go (An all-in-one plugin for golang):
      - git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
      - restart vim.
      - Run this command in vim to install dependancies of vim-go:
        :GoInstallBinaries
      - To see help (available commands of vim-go) - :help vim-go
      - Important commands:
          - Code completion   :CTRL-x CTRL-o (in editing mode)  --> Standard 'omnifunc'.
          - Word completion   :CTRL-n/CTRL-p (in editing mode)  --> Standard way.
          - Go to definition  :CTRL-w CTRL-]                    --> Standard way.
          - Open your code in go play :GoPlay
          - :GoBuild  - Compile.
          - :GoRun    - Run the current project.


  - Install C++ plugins:
    **C++ code completion(using clang_complete)**
    (Not using YCM (YouCompleteMe) as clang_complete is easier to use/setup).
     https://github.com/xavierd/clang_complete (NOTE: This plugin is incompatible with omnicppcomplete)
      - Install and setup:
        - git clone git@github.com:xavierd/clang_complete.git ~/.vim/bundle/clang_complete
        - In .vimrc:
         let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
         let g:clang_snippets = 1
         let g:clang_snippets_engine = 'clang_complete'
        - Project root should contain .clang_complete (which contains compiler flags and include directories)
        To generate the file using cmake:
         CXX='~/.vim/bundle/clang_complete/bin/cc_args.py clang++' cmake ..
         make
         copy .clang_complete from build directory to the project root directory.
        NOTES:
        ------
          - help
            :helptags ALL     ---> Generate the help tags (one time activity)
            :help clang_complete
          - Compiler options (including header file path) can be configured in a .clang_complete file in each project root.
 
 ```
Generic code completion (YCM):
  prerequisite for  MacOS: brew install cmake macvim
  git clone git@github.com:ycm-core/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe
  cd ~/.vim/bundle/YouCompleteMe
  git submodule update --init --recursive
  ./install.py --java-completer
  Other options:
  --------------
    --clang-completer --go-completer --java-completer
    --all
    (For C++, clang_complete seems easier than this)
    NOTE:
    -----
      For C++, YCM requires a per-project configuration file .ycm_extra_conf.py in the root of our project.
      If using CMake:
        - Run cmake with  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON or add this in CMakeLists.txt:
              set( CMAKE_EXPORT_COMPILE_COMMANDS ON ).
        - It will generate following file in build directory:
          ???
        - Copy or symlink the generated database to the root of your project.
          ln -s ??? .ycm_extra_conf.py
        - To use a global config file, add this to .vimrc:
          let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
```                                                                                                                           

 ## To generate help data of installed plugins, use following commands (within vim):
  :helptags ALL     ---> Generate the help tags (one time activity)
  :help <plugin-name> (e.g. :help vim-go)
