" vim:set expandtab shiftwidth=2 tabstop=8 textwidth=72:

if has('autocmd')
  " 为了可以重新执行 vimrc，开头先清除当前组的自动命令
  au!
endif

" 设置等宽字体
if has('gui_running')
  " 下面两行仅为占位使用；请填入你自己的字体
  set guifont=DejaVu\ Sans\ Mono\ 16
  set guifontwide=DejaVu\ Sans\ Mono\ 16

  " 不延迟加载菜单（需要放在下面的 source 语句之前）
  let do_syntax_sel_menu = 1
  let do_no_lazyload_menus = 1
endif

" 自动切换到已打开的窗口
if v:version >= 800
  packadd! editexisting
endif

set enc=utf-8
set nocompatible
source $VIMRUNTIME/vimrc_example.vim

"" ========== 启用 man 插件 ==========
source $VIMRUNTIME/ftplugin/man.vim     " 执行source man.vim会返回乱码值
set keywordprg=:Man

" 设置编码
set fileencodings=ucs-bom,utf-8,gb18030,latin1
set formatoptions+=mM
" 设置拼写检查
set mousemodel=popup_setpos
" 设置语言纠错
set spelllang=en_gb,en_us   " 英语，美语
set spelllang+=cjk          " 中文
set scrolloff=1
set nobackup

filetype plugin on
syntax on

" 其它设置
set cul                         "高亮光标所在行
set cuc
autocmd InsertEnter * se cul    " 用浅色高亮当前行
set ruler                       " 显示标尺
set showcmd                     " 输入的命令显示出来，看的清楚些
" 自动缩进
set autoindent
set cindent
"搜索逐字符高亮
set hlsearch
set incsearch
" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-
set magic                       " 设置魔术
set noeb                        " 去掉输入错误的提示声音
set confirm                     " 在处理未保存或只读文件的时候，弹出确认
set showmatch                   " 高亮显示匹配的括号
set matchtime=1                 " 匹配括号高亮的时间（单位是十分之一秒）

" 加入记录系统头文件的标签文件和上层的 tags 文件
set tags=./tags;,tags,/usr/local/etc/systags

if !has('gui_running')
  " 透明化
  func! s:transparent_background()
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NonText guibg=NONE ctermbg=NONE
  endf
  autocmd ColorScheme * call s:transparent_background()

  " mru最近打开文件cmd
  " 设置文本菜单
  if has('wildmenu')
    set wildmenu
    set cpoptions-=<
    set wildcharm=<C-Z>
    nnoremap <F10>      :emenu <C-Z>
    inoremap <F10> <C-O>:emenu <C-Z>
  endif

  " 检测并设置真彩色
  if has('termguicolors') &&
        \($COLORTERM == 'truecolor' || $COLORTERM == '24bit')
    set termguicolors
  endif

  " NERDCommenter控制
  let g:NERDMenuMode = 0
endif

" 设置主题
" 检查配色详情
" 0 使用default 1使用papercolor 2使用onedark
function! SetCustmizedTheme(mode)
  let l:pm = a:mode
  if l:pm == 'PaperColor'
    colorscheme PaperColor
    let g:airline_theme='papercolor'
    let g:lightline = { 'colorscheme': 'PaperColor' }
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
  elseif l:pm == 'onedark'
    colorscheme onedark
    let g:airline_theme='onedark'
    let g:lightline = { 'colorscheme': 'onedark' }
  else
    colorscheme default
  endif
endfunction

nnoremap <Leader>a :call SyntaxAttr()<CR>
set background=dark
call SetCustmizedTheme('onedark')

set number
set laststatus=2

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
  " C编程支持
  call minpac#add('mbbill/echofunc')
  call minpac#add('adah1972/cscope_maps.vim')
  call minpac#add('octol/vim-cpp-enhanced-highlight')
  " python编程支持
  call minpac#add('python-mode/python-mode')
  call minpac#add('dense-analysis/ale')
  " 额外常用功能支持
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('airblade/vim-gitgutter')
  call minpac#add('preservim/nerdcommenter')
  call minpac#add('mg979/vim-visual-multi')
  call minpac#add('frazrepo/vim-rainbow')
  call minpac#add('jiangmiao/auto-pairs')
  call minpac#add('vim-scripts/LargeFile')
  " 玩具
  call minpac#add('mattn/calendar-vim')
  call minpac#add('uguu-org/vim-matrix-screensaver')
  call minpac#add('vim/killersheep')
endif

if has('eval')
  " Minpac commands
  command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
  command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
  command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()
  " 和 asyncrun 一起用的异步 make 命令
  command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
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

" gitgutter配色方案
if 1
  highlight! link SignColumn LineNr
  highlight GitGutterAdd        guifg=#009900 ctermfg=2
  highlight GitGutterChange     guifg=#bbbb00 ctermfg=3
  highlight GitGutterDelete     guifg=#ff2222 ctermfg=1
  let g:gitgutter_set_sign_backgrounds = 1
endif

" airline配置
if 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '|'
  let g:airline#extensions#tabline#formatter = 'default'
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#buffer_nr_show = 1
  let g:airline#extensions#tabline#overflow_marker = '…'
  let g:airline#extensions#tabline#show_tab_nr = 0
endif

" 修改光标上下键一次移动一个屏幕行
nnoremap <Up>        gk
inoremap <Up>   <C-O>gk
nnoremap <Down>      gj
inoremap <Down> <C-O>gj
inoremap <C-L>  <Right>

" 替换光标下单词的键映射
nnoremap <Leader>v viw"0p
vnoremap <Leader>v    "0p

" 切换窗口
nnoremap <C-Tab>   <C-W>w
inoremap <C-Tab>   <C-O><C-W>w
nnoremap <C-S-Tab> <C-W>W
inoremap <C-S-Tab> <C-O><C-W>W

" 不要高亮搜索
nnoremap <silent> <F2>      :nohlsearch<CR>
inoremap <silent> <F2> <C-O>:nohlsearch<CR>

" 开关撤销树的键映射
nnoremap <F6>      :UndotreeToggle<CR>
inoremap <F6> <C-O>:UndotreeToggle<CR>

" 开关Tagbar 插件的键映射
nnoremap <F9>      :TagbarToggle<CR>
inoremap <F9> <C-O>:TagbarToggle<CR>

" 用于 quickfix、标签和文件跳转的键映射
if !has('mac')
nnoremap <F11>   :cn<CR>
nnoremap <F12>   :cp<CR>
else
nnoremap <D-F11> :cn<CR>
nnoremap <D-F12> :cp<CR>
endif
nnoremap <M-F11> :copen<CR>
nnoremap <M-F12> :cclose<CR>
nnoremap <C-F11> :tn<CR>
nnoremap <C-F12> :tp<CR>
nnoremap <S-F11> :n<CR>
nnoremap <S-F12> :prev<CR>

if has('autocmd')
" 断行设置
au FileType changelog  setlocal textwidth=76
" tab缩进设置
au FileType c,cpp,objc  setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4 cinoptions=:0,g0,(0,w1
au FileType json        setlocal expandtab shiftwidth=2 softtabstop=2
au FileType vim         setlocal expandtab shiftwidth=2 softtabstop=2
" 按q关闭帮助页面
au FileType help  nnoremap <buffer> q <C-W>c

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

" /usr/include代码gnu风格
function! GnuIndent()
  setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
  setlocal shiftwidth=2
  setlocal tabstop=8
endfunction
au BufRead /usr/include/*  call GnuIndent()

" ========== YouCompleteMe ==========
" YouCompleteMe自动补全配置
nnoremap <Leader>fi :YcmCompleter FixIt<CR>
nnoremap <Leader>gt :YcmCompleter GoTo<CR>
nnoremap <Leader>gd :YcmCompleter GoToDefinition<CR>
nnoremap <Leader>gh :YcmCompleter GoToDeclaration<CR>
nnoremap <Leader>gr :YcmCompleter GoToReferences<CR>

" 是否使用最新clangd引擎
let g:ycm_use_clangd = 1
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

" ========== C Language ==========
" C语言语法高亮精调
let g:c_space_errors = 1        " 标记空格错误
let g:c_gnu = 1                 " 激活gnu扩展
let g:c_no_cformat = 1          " 不对格式化字符串加亮
let g:c_no_curly_error = 1      " 让GNU扩展不被标志成错误
if exists('g:c_comment_strings')
  unlet g:c_comment_strings     " 关闭注释中的加亮
endif
" CTags索引自动更新
" 注意，可以使用插件'ludovicchabant/vim-gutentags'代替
function! RunCtagsForC(root_path)
  " 保存当前目录
  let saved_path = getcwd()
  " 进入到项目根目录
  exe 'lcd ' . a:root_path
  " 执行 ctags；silent 会抑制执行完的确认提示
  silent !ctags --languages=c --langmap=c:.c.h --fields=+S -R .
  " 恢复原先目录
  exe 'lcd ' . saved_path
endfunction

" 当 /project/path/ 下文件改动时，更新 tags
au BufWritePost /project/path/* call 
      \ AppendCtagsForC('/project/path/', expand('%'))

" echofunc气泡控制
let g:EchoFuncAutoStartBalloonDeclaration = 1

" cscope利用quickfix分窗口
" g：查找一个符号的全局定义（global definition）
" s：查找一个符号（symbol）的引用
" d：查找被这个函数调用（called）的函数
" c：查找调用（call）这个函数的函数
" t：查找这个文本（text）字符串的所有出现位置
" e：使用 egrep 搜索模式进行查找
" f：按照文件（file）名查找（和 Vim 的 gf、<C-W>f 命令相似）
" i：查找包含（include）这个文件的文件
" a：查找一个符号被赋值（assigned）的地方
set cscopequickfix=s-,c-,d-,i-,t-,e-,a-

" clangformat代码格式化
noremap <silent> <Tab>  :pyxf /usr/share/clang/clang-format-6.0/clang-format.py<CR>

" C/CPP语法高亮设置
" octol/vim-cpp-enhanced-highlight
if 1
  let g:cpp_class_scope_highlight = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_posix_standard = 1
  let g:cpp_concepts_highlight = 1
  let g:cpp_class_decl_highlight = 1
  let c_no_curly_error=1
else
  let g:cpp_experimental_simple_template_highlight = 1
  let g:cpp_experimental_template_highlight = 0
  let g:cpp_no_function_highlight = 0
endif

" ========== Python Language ==========
" python语法检查设置
" 支持 Python 3.6+ 语法加亮
" 虚拟环境支持 运行 Python 代码（<leader>r）
" 添加 / 删除断点（<leader>b）
" 改善了的 Python 缩进
" Python 的移动命令和操作符（]], 3[[, ]]M, vaC, viM, daC, ciM, …）
" 改善了的 Python 折叠
" 同时运行多个代码检查器（:PymodeLint）
" 自动修正 PEP 8 错误（:PymodeLintAuto）
" 自动在 Python 文档里搜索（K）
" 代码重构 智能感知的代码完成 跳转到定义（<C-c>g）
"
function! IsGitRepo()
  " This function requires GitPython
  if has('pythonx')
pythonx << EOF
try:
    import git
except ImportError:
    pass
import vim

def is_git_repo():
    try:
        _ = git.Repo('.', search_parent_directories=True).git_dir
        return 1
    except:
        return 0
EOF
    return pyxeval('is_git_repo()')
  else
    return 0
  endif
endfunction

function! SetPyLintMode(mode)
  let l:pm = a:mode
  if l:pm == 1
    " 是否启用python-mode的语法检查功能
    let g:pymode_lint = 0
    " 在禁用python-mode的情况下使用pylint
    let g:ale_linters = {
          \'python': ['pylint'],
          \}
  else
    let g:pymode_rope = IsGitRepo()           " 检查是否为Git库函数
    let g:pymode_rope_completion = 1          " 启用rope完成功能
    let g:pymode_rope_complete_on_dot = 0     " 禁用.自动完成指令使用YCM，使用<C-X><C-O>可使用rope原生
    let g:pymode_syntax_print_as_function = 1 " print作为保留字
    let g:pymode_syntax_string_format = 0     " 不对格式化字符串加亮
    let g:pymode_syntax_string_templates = 0  " 不对模板加亮
    let g:pymode_folding = 1                  " 代码自动折叠
    
    " python-mode代码检查器
    let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe']
    " 是否启用rope功能
    let g:pymode_rope = 0
  endif
endfunction
call SetPyLintMode(0)   " 0禁用 1启用

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""新文件标题
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.rb,*.java,*.py exec ":call SetTitle()"
""定义函数SetTitle，自动插入文件头
func SetTitle()
  "如果文件类型为.sh文件
  if &filetype == 'sh'
    call setline(1,"\#!/bin/bash")
    call append(line("."), "")
  elseif &filetype == 'python'
    call setline(1,"#!/usr/bin/env python")
    call append(line("."),"# coding=utf-8")
    call append(line(".")+1, "")
  elseif &filetype == 'ruby'
    call setline(1,"#!/usr/bin/env ruby")
    call append(line("."),"# encoding: utf-8")
    call append(line(".")+1, "")
" elseif &filetype == 'mkd'
" call setline(1,"<head><meta charset=\"UTF-8\"></head>")
  else
    call setline(1, "/*************************************************************************")
    call append(line("."), "	> File Name: ".expand("%"))
    call append(line(".")+1, "	> Author: RaphaelTFool")
    call append(line(".")+2, "	> Mail: 1207975808@qq.com")
    call append(line(".")+3, "	> Created Time: ".strftime("%c"))
    call append(line(".")+4, " ************************************************************************/")
    call append(line(".")+5, "")
  endif
  if expand("%:e") == 'cpp'
    call append(line(".")+6, "#include<iostream>")
    call append(line(".")+7, "using namespace std;")
    call append(line(".")+8, "")
  endif
  if &filetype == 'c'
    call append(line(".")+6, "#include<stdio.h>")
    call append(line(".")+7, "")
  endif
  if expand("%:e") == 'h'
    call append(line(".")+6, "#ifndef _".toupper(expand("%:r"))."_H")
    call append(line(".")+7, "#define _".toupper(expand("%:r"))."_H")
    call append(line(".")+8, "#endif")
  endif
  if &filetype == 'java'
    call append(line(".")+6,"public class ".expand("%:r"))
    call append(line(".")+7,"")
  endif
endfunc
"新建文件后，自动定位到文件末尾
autocmd BufNewFile * normal G
"当打开vim且没有文件时自动打开NERDTree
autocmd vimenter * if !argc() | NERDTree | endif
" 只剩 NERDTree时自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
endif

" 括号自动匹配配置
let g:AutoPairsShortcutToggle = '<Leader>p'

" 大文件阈值
let g:LargeFile = 100

" 最后一个窗口如果是quickfix，则自动关闭
aug QFClose
  au!
  au WinEnter *  if winnr('$') == 1 && &buftype == "quickfix"|q|endif
aug END
