set print pretty on
set print object on
set print vtbl on
set print static-members on
set print demangle on
set demangle-style gnu-v3
set print sevenbit-strings off

set history save on
set history filename ~/.gdb_history

set height 0
set width 0

set disassembly-flavor intel

set tui border-kind acs
set tui border-mode normal
set tui active-border-mode bold

define lsb
 info breakpoints
end

define argv
 show args
end

define frame
 info frame
 info args
 info locals
end

define func
 info functions
end

define vars
 info variables
end

define lib
 info sharedlibrary
end

define sig
 info signals
end

define threads
 info threads
end

source stl-views.gdb

