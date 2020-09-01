set enc=utf-8
set nocompatible
source $VIMRUNTIME/vimrc_example.vim

" 断行设置
au FileType changelog  setlocal textwidth=76

" 透明化
if !has('gui_running')
  func! s:transparent_background()
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NonText guibg=NONE ctermbg=NONE
  endf
  autocmd ColorScheme * call s:transparent_background()
endif

" 设置主题
" 设置等宽字体
if has('gui_running')
  set guifont=DejaVu\ Sans\ Mono\ 16
endif
" 检测并设置真彩色
if has('termguicolors') &&
      \($COLORTERM == 'truecolor' || $COLORTERM == '24bit')
  set termguicolors
endif
" 检查配色详情
nnoremap <Leader>a :call SyntaxAttr()<CR>
" 设置papercolor主题属性
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default.dark': {
  \       'transparent_background': 0
  \     }
  \   },
  \   'language': {
  \     'python': {
  \       'highlight_builtins' : 1
  \     },
  \     'cpp': {
  \       'highlight_standard_library': 1
  \     },
  \     'c': {
  \       'highlight_builtins' : 1
  \     }
  \   }
  \ }
set background=dark
colorscheme PaperColor
let g:airline_theme='papercolor'
let g:lightline = { 'colorscheme': 'PaperColor' }
"colorscheme onedark
"let g:airline_theme='onedark'
"let g:lightline = { 'colorscheme': 'onedark' }
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
set number
set laststatus=2

" 设置编码
set fileencodings=ucs-bom,utf-8,gb18030,latin1
set nobackup
set scrolloff=1
filetype plugin on
syntax on

" tab缩进设置
au FileType c,cpp,objc  setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4 cinoptions=:0,g0,(0,w1
au FileType json        setlocal expandtab shiftwidth=2 softtabstop=2
au FileType vim         setlocal expandtab shiftwidth=2 softtabstop=2

" /usr/include代码gnu风格
function! GnuIndent()
  setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
  setlocal shiftwidth=2
  setlocal tabstop=8
endfunction

au BufRead /usr/include/*  call GnuIndent()

" 设置跨会话文件缓存
if has('persistent_undo')
  set undofile
  set undodir=~/tmp/vimfiles/undodir
  if !isdirectory(&undodir)
    call mkdir(&undodir, 'p', 0700)
  endif
endif

" 设置鼠标激活
if has('mouse')
  if has('gui_running') || (&term =~ 'xterm' && !has('mac'))
    set mouse=a
  else
    set mouse=nvi
  endif
endif

" 菜单全展开
let do_syntax_sel_menu = 1
let do_no_lazyload_menus = 1

" minpac包管理器加载
if exists('*minpac#init')
  " Minpac is loaded.
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " Other plugins
  call minpac#add('yegappan/mru')
  call minpac#add('preservim/nerdtree')
  call minpac#add('majutsushi/tagbar')
  call minpac#add('skywind3000/asyncrun.vim')
  " 文本对象增强
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-repeat')
  call minpac#add('mbbill/undotree')
  call minpac#add('tpope/vim-eunuch')
  call minpac#add('junegunn/fzf', {'do': {-> fzf#install()}})
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('adah1972/ycmconf')
  call minpac#add('lyuts/vim-rtags')
  " 主题
  call minpac#add('vim-airline/vim-airline')
  call minpac#add('vim-airline/vim-airline-themes')
  call minpac#add('vim-scripts/SyntaxAttr.vim')
endif

if has('eval')
  " Minpac commands
  command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
  command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
  command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()
endif

" mru最近打开文件cmd
if !has('gui_running')
  " 设置文本菜单
  if has('wildmenu')
    set wildmenu
    set cpoptions-=<
    set wildcharm=<C-Z>
    nnoremap <F10>      :emenu <C-Z>
    inoremap <F10> <C-O>:emenu <C-Z>
  endif
endif

" 自动识别粘贴模式
if !has('patch-8.0.210')
  " 进入插入模式时启用括号粘贴模式
  let &t_SI .= "\<Esc>[?2004h"
  " 退出插入模式时停用括号粘贴模式
  let &t_EI .= "\<Esc>[?2004l"
  " 见到 <Esc>[200~ 就调用 XTermPasteBegin
  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

  function! XTermPasteBegin()
    " 设置使用 <Esc>[201~ 关闭粘贴模式
    set pastetoggle=<Esc>[201~
    " 开启粘贴模式
    set paste
    return ""
  endfunction
endif

" 自动切换到已打开的窗口
if v:version >= 800
  packadd! editexisting
endif

" 切换窗口
nnoremap <C-Tab>   <C-W>w
inoremap <C-Tab>   <C-O><C-W>w
nnoremap <C-S-Tab> <C-W>W
inoremap <C-S-Tab> <C-O><C-W>W

" 不要高亮搜索
nnoremap <silent> <F2>      :nohlsearch<CR>
inoremap <silent> <F2> <C-O>:nohlsearch<CR>

" 按q关闭帮助页面
au FileType help  nnoremap <buffer> q <C-W>c

" 加入记录系统头文件的标签文件和上层的 tags 文件
set tags=./tags;,tags,/usr/local/etc/systags

" 开关Tagbar 插件的键映射
nnoremap <F9>      :TagbarToggle<CR>
inoremap <F9> <C-O>:TagbarToggle<CR>

" 替换光标下单词的键映射
nnoremap <Leader>v viw"0p
vnoremap <Leader>v    "0p

"========== make命令构建 ==========
" 和 asyncrun 一起用的异步 make 命令
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args
" 异步运行命令时打开 quickfix 窗口，高度为 10 行
let g:asyncrun_open = 10
" 映射按键来快速启停构建
nnoremap <F5>  :if g:asyncrun_status != 'running'<bar>
                 \if &modifiable<bar>
                   \update<bar>
                 \endif<bar>
                 \exec 'Make'<bar>
               \else<bar>
                 \AsyncStop<bar>
               \endif<CR>>

" ========== 启用 man 插件 ==========
source $VIMRUNTIME/ftplugin/man.vim
set keywordprg=:Man

" YouCompleteMe自动补全配置
let g:ycm_use_clangd = 1    " 是否使用最新clangd引擎
nnoremap <Leader>fi :YcmCompleter FixIt<CR>
nnoremap <Leader>gt :YcmCompleter GoTo<CR>
nnoremap <Leader>gd :YcmCompleter GoToDefinition<CR>
nnoremap <Leader>gh :YcmCompleter GoToDeclaration<CR>
nnoremap <Leader>gr :YcmCompleter GoToReferences<CR>

" 禁用光标长期停留的自动文档提示
let g:ycm_auto_hover = ''
" 注释中的自动完成
let g:ycm_complete_in_comments = 1
" YCM白名单
let g:ycm_filetype_whitelist = {
      \ 'c': 1,
      \ 'cpp': 1,
      \ 'python': 1,
      \ 'go': 1,
      \ 'vim': 1,
      \ 'sh': 1,
      \ 'zsh': 1,
      \ }
" 跳转文件如果没打开则用分割窗口打开
let g:ycm_goto_buffer_command = 'split-or-existing-window'
" 手动启用予以完成的快捷键
let g:ycm_key_invoke_completion = '<C-Z>'
" rtags配置
let g:rtagsUseLocationList = 0

