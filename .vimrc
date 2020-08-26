set enc=utf-8
set nocompatible
source $VIMRUNTIME/vimrc_example.vim

set fileencodings=ucs-bom,utf-8,gb18030,latin1
set nobackup
set scrolloff=1

"tab缩进设置
set ts=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

if has('persistent_undo')
    set undofile
    set undodir=~/tmp/vimfiles/undodir
    if !isdirectory(&undodir)
        call mkdir(&undodir, 'p', 0700)
    endif
endif

if has('mouse')
    if has('gui_running') || (&term =~ 'xterm' && !has('mac'))
        set mouse=a
    else
        set mouse=nvi
    endif
endif

let do_syntax_sel_menu = 1
let do_no_lazyload_menus = 1
