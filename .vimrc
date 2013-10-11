"设置菜单语言
set langmenu=zh_cn
 
set t_Co=256
"colorscheme desert256
colorscheme myColor_dark1
" =========
" 功能函数
" =========
" 获取当前目录
func GetPWD()
    return substitute(getcwd(), "", "", "g")
endf
 
"colorscheme homebrew
" =========
" 环境配置
" =========
 
" 保留历史记录
set history=400
 
" 命令行于状态行
set ch=1
set stl=\ [File]\ %F%m%r%h%y[%{&fileformat},%{&fileencoding}]\ %w\ \ [PWD]\ %r%{GetPWD()}%h\ %=\ [Line]\ %l,%c\ %=\ %P 
set ls=2 " 始终显示状态行
 
" 制表符
set tabstop=4
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4
 
" 状态栏显示目前所执行的指令
set showcmd 
 
" 行控制
"set linebreak
"set nocompatible
"set textwidth=80
"set wrap
 
" 行号和标尺
set number
set ruler
set rulerformat=%15(%c%V\ %p%%%)
 
" 控制台响铃
:set noerrorbells
:set novisualbell
:set t_vb= "close visual bell
 
" 插入模式下使用 <BS>、<Del> <C-W> <C-U>
set backspace=indent,eol,start
 
" 标签页
set tabpagemax=20
set showtabline=2
 
" 缩进
set autoindent
set cindent
set smartindent
 
" 自动重新读入
set autoread
 
" 代码折叠
set foldmethod=manual
"set foldmethod=indent
 
" 自动切换到文件当前目录
set autochdir
 
"在查找时忽略大小写
set ignorecase
set incsearch
set hlsearch
 
"显示匹配的括号
set showmatch
 
"实现全能补全功能，需要打开文件类型检测
filetype plugin indent on
"打开vim的文件类型自动检测功能
filetype on
 
"在所有模式下都允许使用鼠标，还可以是n,v,i,c等
set mouse=a
 
" 恢复上次文件打开位置
set viminfo='10,\"100,:20,%,n~/.viminfo
 
" =====================
" 多语言环境
"    默认为 UTF-8 编码
" =====================
if has("multi_byte")
    set encoding=utf-8
    " English messages only
    "language messages zh_CN.utf-8
 
    if has('win32')
        language english
        let &termencoding=&encoding
    endif
 
    set fencs=ucs-bom,utf-8,gbk,cp936,latin1
    set formatoptions+=mM
    set nobomb " 不使用 Unicode 签名
 
    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif
else
    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif
 
" =========
" 图形界面
" =========
if has('gui_running')
    " 只显示菜单
    set guioptions=mcr
 
    " 高亮光标所在的行
    set cursorline
 
    " 编辑器配色
    "colorscheme homebrew
    "colorscheme dusk
 
    if has("win32")
        " Windows 兼容配置
        source $VIMRUNTIME/mswin.vim
 
        " f11 最大化
        nmap <f11> :call libcallnr('fullscreen.dll', 'ToggleFullScreen', 0)<cr>
        nmap <Leader>ff :call libcallnr('fullscreen.dll', 'ToggleFullScreen', 0)<cr>

        " 自动最大化窗口
        au GUIEnter * simalt ~x

        " 给 Win32 下的 gVim 窗口设置透明度
        au GUIEnter * call libcallnr("vimtweak.dll", "SetAlpha", 250)
 
        " 字体配置
        exec 'set guifont='.iconv('Courier_New', &enc, 'gbk').':h11:cANSI'
        exec 'set guifontwide='.iconv('微软雅黑', &enc, 'gbk').':h11'
    endif
 
    if has("unix") && !has('gui_macvim')
        set guifont=Courier\ 10\ Pitch\ 11
        set guifontwide=YaHei\ Consolas\ Hybrid\ 11
    endif
 
    if has("gui_macvim")
        " MacVim 下的字体配置
        set guifont=Menlo:h14
        set guifontwide=Hei:h14
        " 半透明和窗口大小
        set transparency=2
        set lines=40 columns=110
 
        " 使用MacVim原生的全屏幕功能
        let s:lines=&lines
        let s:columns=&columns
        
        func! FullScreenEnter()
            set lines=999 columns=999
            set fu
        endf
 
        func! FullScreenLeave()
            let &lines=s:lines
            let &columns=s:columns
            set nofu
        endf
 
        func! FullScreenToggle()
            if &fullscreen
                call FullScreenLeave()
            else
                call FullScreenEnter()
            endif
        endf

        " Mac 下，按 \\ 切换全屏
        nmap <Leader><Leader>  :call FullScreenToggle()<cr>

        " Set input method off
        set imdisable
 
        " Set QuickTemplatePath
        let guickTemplatePath = $HOME.'/.vim/templates/'
        
        " 如果为空文件，则自动设置当前目录为桌面
        lcd ~/Desktop/
 
        " 自动切换到文件当前目录
        set autochdir
 
        " Set QuickTemplatePath
        let guickTemplatePath = $HOME.'/.vim/templates/'

    endif
endif

 
" =========
" 插件
" =========
filetype plugin indent on
" =========
" AutoCmd
" =========
if has("autocmd")
    filetype plugin indent on
 
    " 括号自动补全
    func! AutoClose()
        :inoremap ( ()<ESC>i
        :inoremap " ""<ESC>i
       " :inoremap ' ''<ESC>i
        :inoremap { {}<ESC>i
        :inoremap [ []<ESC>i
        :inoremap } <c-r>=ClosePair('}')<CR>
        :inoremap ] <c-r>=ClosePair(']')<CR>
        :inoremap ) <c-r>=ClosePair(')')<CR>

    endf
 
    func! ClosePair(char)
        if getline('.')[col('.') - 1] == a:char
            return "\<Right>"
        else
            return a:char
        endif
    endf
 
 
    "auto close quotation marks for PHP, Javascript, etc, file
    au FileType php,c,python,javascript exe AutoClose()
 
    " Auto Check Syntax
    "au BufWritePost,FileWritePost *.js,*.php call CheckSyntax(1)
 
    " JavaScript 语法高亮
    au FileType html,javascript let g:javascript_enable_domhtmlcss = 1
 
    " 给 Javascript 文件添加 Dict
    if has('gui_macvim') || has('unix')
        au FileType javascript setlocal dict+=~/.vim/dict/javascript.dict
    else
        au FileType javascript setlocal dict+=$VIM/vimfiles/dict/javascript.dict
    endif
 
    " 格式化 JavaScript 文件
    "au FileType javascript map <f12> :call g:Jsbeautify()<cr>
    au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
 
    " 给 CSS 文件添加 Dict
    if has('gui_macvim') || has('unix')
        au FileType css setlocal dict+=~/.vim/dict/css.dict
    else
        au FileType css setlocal dict+=$VIM/vimfiles/dict/css.dict
    endif
 
    " 增加 ActionScript 语法支持
    au BufNewFile,BufRead *.as setf actionscript

    " CSS3 语法支持
    au BufRead,BufNewFile *.css set ft=css syntax=css3

    " 增加 Objective-C 语法支持
    au BufNewFile,BufRead,BufEnter,WinEnter,FileType *.m,*.h setf objc

    " 将指定文件的换行符转换成 UNIX 格式
    au FileType php,javascript,html,css,python,vim,vimwiki set ff=unix

    " 保存编辑状态
    au BufWinLeave * if expand('%') != '' && &buftype == '' | mkview | endif
    au BufRead     * if expand('%') != '' && &buftype == '' | silent loadview | syntax on | endif
 
    " 自动最大化窗口
    if has('gui_running')
        if has("win32")
            au GUIEnter * simalt ~x
        "elseif has("unix")
            "au GUIEnter * winpos 0 0
            "set lines=999 columns=999
        endif
    endif
endif
 
"acp 自动补全插件
let g:AutoComplPop_Behavior = { 
\ 'c': [ {'command' : "\<C-x>\<C-o>",
\ 'pattern' : ".",
\ 'repeat' : 0}
\ ] 
\}
 
 
" =========
" 快捷键
" =========
map cal :Calendar<cr>
let NERDTreeWinSize=22
map ntree :NERDTree <cr>
map nk :NERDTreeClose <cr>
map <leader>n :NERDTreeToggle<cr>
map cse :ColorSchemeExplorer
 
" 标签相关的快捷键 Ctrl
map tn :tabnext<cr>
map tp :tabprevious<cr>
map tc :tabclose<cr>
map <C-t> :tabnew<cr>
map <C-p> :tabprevious<cr>
map <C-n> :tabnext<cr>
map <C-k> :tabclose<cr>
map <C-Tab> :tabnext<cr>
 
" 新建 XHTML 、PHP、Javascript 文件的快捷键
nmap <C-c><C-h> :NewQuickTemplateTab xhtml<cr>
nmap <C-c><C-p> :NewQuickTemplateTab php<cr>
nmap <C-c><C-j> :NewQuickTemplateTab javascript<cr>
nmap <C-c><C-c> :NewQuickTemplateTab css<cr>
 
" 在文件名上按gf时，在新的tab中打开
map gf :tabnew <cfile><cr>
 
 
"jquery 配色
au BufRead,BufNewFile *.js set syntax=jquery
 
" jsLint for Vim
let g:jslint_highlight_color  = '#996600'
" 指定 jsLint 调用路径，通常不用更改
let g:jslint_command = $HOME . '\/.vim\/jsl\/jsl'
" 指定 jsLint 的启动参数，可以指定相应的配置文件
let g:jslint_command_options = '-nofilelisting -nocontext -nosummary -nologo -process'
 
 
" 返回当前时间
func! GetTimeInfo()
    "return strftime('%Y-%m-%d %A %H:%M:%S')
    return strftime('%Y-%m-%d %H:%M:%S')
endfunction
 
" 插入模式按 Ctrl + D(ate) 插入当前时间
imap <C-d> <C-r>=GetTimeInfo()<cr>
 
" ==================
" plugin list
" ==================
"Color Scheme Explorer
"jsbeauty \ff
"NERDTree
"Calendar
"conquer_term
"nerd_commenter
 
"setup for C and C++
filetype plugin on
set nocp
