" Info
" Author: yantze
" Last Modified:2014-10-14

" 下面的两行，配置基本保持不变,一般不需要修改,所以折叠,可以用za打开
" the two line fold is not often change,so fold it
" Environment {{{

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win16') || has('win32') || has('win64'))
        endfunction
    " }

    " Windows Compatible {
        if WINDOWS()
            let g:isWIN = 1
            " set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        else
            " 兼容windows的环境变量$VIM
            let $VIM = $HOME."/.vim"
            set shell=/bin/sh
            let g:isWIN = 0
        endif
    " }

    " Adapter {
        " Adapte with putty because of putty only support the 7 character
        if $TERM == 'screen'
            "from: http://vim.wikia.com/wiki/Get_Alt_key_to_work_in_terminal
            set <m-j>=j
            set <m-h>=h
            set <m-k>=k
            set <m-l>=l
            "from: https://groups.google.com/forum/#!topic/vim_use/uKOmY-mHo_k
            "below set <esc> wait the next key millionstime
            set timeout timeoutlen=3000 ttimeoutlen=100
        endif
        " the ^[ is an Esc char that comes before the 'a'
        " In most default configs, ^[a may be typed by pressing first <C-v>, then <M-a>

        " http://vim.1045645.n5.nabble.com/Mapping-meta-key-within-tmux-td5716437.html
        " Fix screen's key bindings.
        " if &term == "screen"
        "     " These work from my HP keyboard in PuTTY on Windows XP.
        "     map <Esc>[D   <S-Left>
        "     map <Esc>[C   <S-Right>
        "     map <Esc>[11~ <F1>
        "     map <Esc>[12~ <F2>
        "     map <Esc>[13~ <F3>
        "     map <Esc>[14~ <F4>
        "     map <Esc>[15~ <F5>
        "     map <Esc>[16~ <F6>
        "     map <Esc>[17~ <F7>
        "     map <Esc>[18~ <F8>
        "     map <Esc>[19~ <F9>
        "     map <Esc>[21~ <F10
        "     map <Esc>[23~ <F11>
        "     map <Esc>[24~ <F12>
        " endif
    " }

    " Package manager{
        " 添加vundle插件管理器
        set nocompatible               " 设置不与之前版本兼容 be iMproved
        filetype off                   " 检测文件类型 required!
        if filereadable(expand("$VIM/_vimrc.bundles"))
           set rtp+=$VIM/vimfiles/bundle/Vundle.vim  "添加vendle环境变量
           source $VIM/_vimrc.bundles
        endif
        " you can put it in tmpfs:/dev/shm/.dotfiles/vimrc/vimfiles/bundle/Vundle.vim
        " 安装新的插件 :PluginInstall
        " 在命令行运行 vim +PluginInstall +qall
        " 更新插件:PluginUpdate
        " 清除不再使用的插件:PluginClean,
        " 列出所有插件:PluginList
        " 查找插件:PluginSearch

    " }
    " Basic {
        "set powerline
        "set guifont=Powerline
        "set font=Source\ Code\ Pro\:h15
    " }

    " 判断是否处于GUI界面
    if has("gui_running")
        let g:isGUI = 1
    else
        let g:isGUI = 0
    endif

" }}}

" Functions {{{

" there func is for internal function invoal
" not relate the other plugin

func! RemoveTabs()
    if &shiftwidth == 2
        exec "%s/	/  /g"
    elseif &shiftwidth == 4
        exec "%s/	/    /g"
    elseif &shiftwidth == 6
        exec "%s/	/      /g"
    elseif &shiftwidth == 8
        exec "%s/	/        /g"
    else
        exec "%s/	/ /g"
    end
endfunc

" 这个函数是我用来整理loveacc博客的资料
func! RemoveSong()
    :%s/　//g
    :%s/\[.*//g
    :%s/...EP//g
    :%s/...Single//g
    :%s/\s–\s/\r/g
endfunc

" Diff current unsaved file
function! s:DiffWithSaved()
    let filetype=&ft
    diffthis
    vnew | r # | normal! 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction

" Clean close
function! CleanClose(tosave,bang)
    if a:bang == 1
        let bng = "!"
    else
        let bng = ""
    endif
    if (a:tosave == 1)
        w!
    endif
    let todelbufNr = bufnr("%")
    let newbufNr = bufnr("#")
    if ((newbufNr != -1) && (newbufNr != todelbufNr) && buflisted(newbufNr))
        exe "b".newbufNr
    else
        exe "bnext".bng
    endif

    if (bufnr("%") == todelbufNr)
        new
    endif
    exe "bd".bng.todelbufNr
endfunction

" 编译并运行
func! Compile_Run_Code()
    exec "w"
    if &filetype == "c"
        if g:isWIN
            exec "!gcc -Wall -std=c11 -o %:r %:t && %:r.exe"
        else
            exec "!clang -Wall -std=c11 -o %:r %:t && ./%:r"
        endif
    elseif &filetype == "cpp"
        if g:isWIN
            exec "!g++ -Wall -std=c++11 -o %:r %:t && %:r.exe"
        else
            exec "!clang++ -Wall -std=c++11 -o %:r %:t && ./%:r"
        endif
    elseif &filetype == "d"
        if g:isWIN
            exec "!dmd -wi %:t && %:r.exe"
        else
            exec "!dmd -wi %:t && ./%:r"
        endif
    elseif &filetype == "go"
        exec "!go run %:t"
    elseif &filetype == "rust"
        if g:isWIN
            exec "!rustc %:t && %:r.exe"
        else
            exec "!rustc %:t && ./%:r"
        endif
    elseif &filetype == "java"
        exec "!javac %:t && java %:r"
    elseif &filetype == "groovy"
        exec "!groovy %:t"
    elseif &filetype == "scala"
        exec "!scala %:t"
    elseif &filetype == "clojure"
        exec "!clojure -i %:t"
    elseif &filetype == "cs"
        if g:isWIN
            exec "!csc %:t && %:r.exe"
        else
            exec "!mono-csc %:t && ./%:r.exe"
        endif
    elseif &filetype == "fsharp"
        if g:isWIN
            exec "!fsc %:t && %:r.exe"
        else
            exec "!fsharpc %:t && ./%:r.exe"
        endif
    elseif &filetype == "scheme" || &filetype == "racket"
        exec "!racket -fi %:t"
    elseif &filetype == "lisp"
        exec "!sbcl --load %:t"
    elseif &filetype == "ocaml"
        if g:isWIN
            exec "!ocamlc -o %:r.exe %:t && %:r.exe"
        else
            exec "!ocamlc -o %:r %:t && ./%:r"
        endif
    elseif &filetype == "haskell"
        if g:isWIN
            exec "!ghc -o %:r %:t && %:r.exe"
        else
            exec "!ghc -o %:r %:t && ./%:r"
        endif
    elseif &filetype == "lua"
        exec "!lua %:t"
    elseif &filetype == "perl"
        exec "!perl %:t"
    elseif &filetype == "php"
        exec "!php %:t"
    elseif &filetype == "python"
        exec "!python %:t"
    elseif &filetype == "ruby"
        exec "!ruby %:t"
    elseif &filetype == "elixir"
        exec "!elixir %:t"
    elseif &filetype == "julia"
        exec "!julia %:t"
    elseif &filetype == "dart"
        exec "!dart %:t"
    elseif &filetype == "haxe"
        exec "!haxe -main %:r --interp"
    elseif &filetype == "r"
        exec "!Rscript %:t"
    elseif &filetype == "coffee"
        exec "!coffee -c %:t && node %:r.js"
    elseif &filetype == "ls"
        exec "!lsc -c %:t && node %:r.js"
    elseif &filetype == "typescript"
        exec "!tsc %:t && node %:r.js"
    elseif &filetype == "javascript"
        exec "!node %:t"
    elseif &filetype == "sh"
        exec "!bash %:t"
    endif
endfunc
" }}}

" the package location:
" $VIM/_vimrc.bundles

syntax enable                " 打开语法高亮
syntax on                    " 开启文件类型侦测
filetype indent on           " 针对不同的文件类型采用不同的缩进格式
filetype plugin on           " 针对不同的文件类型加载对应的插件
filetype plugin indent on    " 启用自动补全
set ic                       "忽略大小写查找
set visualbell t_vb=         "关闭visual bell/声音
au GuiEnter * set t_vb=      "关闭beep/屏闪

" 文件配置
" 设定换行符
" set fileformats=unix
" 设定文件浏览器目录为当前目录
set bsdir=buffer
" 设置编码
set enc=utf-8
" 设置文件编码
set fenc=utf-8
" 设置文件编码检测类型及支持格式
set fencs=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936




" 设置着色模式和字体
" 使用GUI界面时的设置
if g:isWIN
    if g:isGUI
        "启动gvim时窗口的大小
        "set lines=42 columns=170
        " 启动时自动最大化窗口
        au GUIEnter * simalt ~x

        "winpos 20 20             " 指定窗口出现的位置，坐标原点在屏幕左上角
        "set lines=20 columns=90  " 指定窗口大小，lines为高度，columns为宽度
        set guioptions+=c        " 使用字符提示框
        set guioptions-=m        " 隐藏菜单栏
        set guioptions-=T        " 隐藏工具栏
        "set guioptions-=L        " 隐藏左侧滚动条
        "set guioptions-=r        " 隐藏右侧滚动条
        "set guioptions-=b        " 隐藏底部滚动条
        "set showtabline=1        " 隐藏Tab栏

        "set colortheme molokai autumn blackboard asu1dark busybee tomorrow
        colorscheme solarized

        "set font
        "set guifont=Consolas:h12
        "set guifont=Monaco:h15
        "set guifont=Source\ Code\ Pro\ Regular:h15
        set guifont=Source\ Code\ Pro\:h13
    else
        colorscheme ir_black
        " 兼容windows下cmd的gb2312
        set enc=cp936

    endif
else
    if g:isGUI
        "set guifont=Monaco\ 11
        set guifont=YaHei\ Consolas\ Hybrid:h13
        set background=dark
        colorscheme solarized
        set lines=38 columns=140
        let g:solarized_termtrans =0
        let g:solarized_termcolors=256

    else
        " colorscheme ir_black
        " colorscheme grb256
        colorscheme vt_tmux
        "
        " set background=dark
        " let g:solarized_termtrans =0
        " let g:solarized_termcolors=256
        " colorscheme solarized
        " colorscheme BusyBee
        " set guifont=Monaco\ 11
    endif
endif

if v:version > 703
    " 开启相对行号
    set relativenumber

    " 替换原来的查找，可以同时显示多个查找关键字(Easymotion)
    map  / <Plug>(easymotion-sn)
    omap / <Plug>(easymotion-tn)

endif

" 基本设置
"set my leader
let mapleader=","
"set : to ;
map ; :

set backspace=2              " 设置退格键可用
set autoindent               " 自动对齐
set smartindent              " 智能自动缩进
set nu!                      " 显示行号
" set mouse=a                  " 启用鼠标
set ruler                    " 右下角显示光标位置的状态行
set incsearch                " 开启实时搜索功能,查询时非常方便，如要查找book单词，当输入到/b时，会自动找到第一个b开头的单词，当输入到/bo时，会自动找到第一个bo开头的单词
set hlsearch                 " 开启高亮显示结果
set nowrapscan               " 搜索到文件两端时不重新搜索
" set nocompatible             " 关闭兼容模式
set hidden                   " 允许在有未保存的修改时切换缓冲区
set autochdir                " 设定文件浏览器目录为当前目录
set foldmethod=marker         " 选择代码折叠类型
set foldlevel=100            " 禁止自动折叠 also same: set [no]foldenable
set laststatus=2             " 开启状态栏信息
set cmdheight=2              " 命令行的高度，默认为1，这里设为2
set writebackup              " 设置无备份文件
set autoread                 " 当文件在外部被修改时自动更新该文件
set nobackup                 " 不生成备份文件
set noswapfile               " 不生成交换文件
set wildmenu                 " 在命令行下显示匹配的字段到状态栏里面
set list                     " 显示特殊字符，其中Tab使用高亮竖线代替，尾部空白使用高亮点号代替
set listchars=tab:\|\ ,trail:. "设置tab/尾部字符用什么填充
set t_Co=256                 " 设置文字可以显示多少种颜色
set cursorline               " 突出显示当前行


" Tab
set tabstop=4
set cindent shiftwidth=4
"set autoindent shiftwidth=4
"set ts=4 sw=4 et  "ts=tabstop=4 sw=shiftwidth=4 et=expandtab
set smarttab                 "在行首按TAB将加入sw个空格，否则加入ts个空格;按Backspace可以删除4个空格
" set ambiwidth=double  "如果全角字符不能识别一般用这个
set ai!                      " 设置自动缩进
set expandtab                " 将Tab自动转化成空格 [需要输入真正的Tab键时，使用 Ctrl+V + Tab]
" 详细的tab设置：http://blog.chinaunix.net/uid-24774106-id-3396220.html
" set showmatch               " 显示括号配对情况
" set nowrap                  " 设置不自动换行
" set tw=78     "超过80个字符就折行
set lbr       "不在单词中间断行
set fo+=mB    "打开断行模块对亚洲语言支持
" set lsp=0     "设置行间距






" =======
" 自定义快捷键
" =======


" Win paste
" imap <C-V> <C-r>+

" 把 CTRL-S 映射为 保存
" imap <C-S> <C-C>:w<CR>


" 用两个<CR>可以隐藏执行命令后出现的提示信息"
" map F :call FormatCode() <CR><CR>
" map <silent>F 也可以隐藏

" 去掉我从从lovecc歌曲清单里面的冗余信息
map <leader>rs <ESC>:call RemoveSong()<CR>

" Ctrl + H            光标移当前行行首
imap <c-h> <ESC>I

" Ctrl + J            光标移下一行行首
imap <c-j> <ESC><Down>I

" Ctrl + K            光标移上一行行尾
imap <c-k> <ESC><Up>A

" Ctrl + L            光标移当前行行尾
imap <c-l> <ESC>A

" Alt  + H            光标左移一格
imap <m-h> <Left>

" Alt  + J            光标下移一格
imap <m-j> <Down>

" Alt  + K            光标上移一格
imap <m-k> <Up>

" Alt  + L            光标右移一格
imap <m-l> <Right>

" \c                  复制至公共剪贴板
vmap <leader>c "+y

" \a                  复制所有至公共剪贴板
nmap <leader>a <ESC>ggVG"+y<ESC>

" \v                  从公共剪贴板粘贴
imap <leader>v <ESC>"+p
nmap <leader>v "+p
vmap <leader>v "+p

" \bb                 按=号对齐代码 [Tabular插件]
nmap <leader>bb :Tab /=<CR>

" \bn                 自定义对齐    [Tabular插件]
nmap <leader>bn :Tab /

" \tl                 打开Taglist/TxtBrowser窗口，在右侧栏显示
nmap <leader>tl :Tlist<CR><c-l>

" \ff                 打开文件搜索窗口，在状态栏显示 [ctrlp.vim插件]
nmap <leader>ff :CtrlP<CR>

" \16                 十六进制格式查看
nmap <leader>16 <ESC>:%!xxd<ESC>

" \r16                返回普通格式
nmap <leader>r16 <ESC>:%!xxd -r<ESC>

" \rb                 一键去除所有尾部空白
" imap <leader>rb <ESC>:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
nmap <leader>rb <ESC>:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
vmap <leader>rb <ESC>:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" \rt                 一键替换全部Tab为空格
" imap <leader>rt <ESC>:call RemoveTabs()<CR>
nmap <leader>rt :call RemoveTabs()<CR>
vmap <leader>rt <ESC>:call RemoveTabs()<CR>

" \rl
nmap <leader>rl :so ~/.vimrc<CR>

" \r<cr>                 一键替换全部Tab为空格
" imap <leader>rcr <ESC>:%s/\r//g<CR>
nmap <leader>r<cr> :%s/\r//g<CR>
vmap <leader>r<cr> <ESC>:%s/\r//g<CR>

" \th                 一键生成与当前编辑文件同名的HTML文件 [不输出行号]
" imap <leader>th <ESC>:set nonumber<CR>:set norelativenumber<CR><ESC>:TOhtml<CR><ESC>:w %:r.html<CR><ESC>:q<CR>:set number<CR>:set relativenumber<CR>
nmap <leader>th <ESC>:set nonumber<CR>:set norelativenumber<CR><ESC>:TOhtml<CR><ESC>:w %:r.html<CR><ESC>:q<CR>:set number<CR>:set relativenumber<CR>
vmap <leader>th <ESC>:set nonumber<CR>:set norelativenumber<CR><ESC>:TOhtml<CR><ESC>:w %:r.html<CR><ESC>:q<CR>:set number<CR>:set relativenumber<CR>

" F                   格式化输出
map F :%s/{/{\r/g <CR> :%s/}/}\r/g <CR>  :%s/;/;\r/g <CR> gg=G

" move lines up or down (command - D)
nmap <m-j> mz:m+<cr>`z
nmap <m-k> mz:m-2<cr>`z
vmap <m-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <m-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Tab move lines left or right (c-Ctrl,s-Shift)
"nmap    <c-tab>     v>
"nmap    <s-tab>     v<
"vmap    <c-tab>     >gv
"vmap    <s-tab>     <gv

:nmap <c-tab> :tabn<CR>
:map <c-tab> :tabn<CR>
imap <c-tab> <Esc>:tabn<CR>i

:nmap <c-s-tab> :tabp<CR>
:map <c-s-tab> :tabp<CR>
imap <c-s-tab> <Esc>:tabp<CR>i

:nmap <leader>n :bn<CR>
:map <leader>n :bn<CR>
imap <leader>n <Esc>:bp<CR>i

:nmap <leader>p :bp<CR>
:map <leader>p :bp<CR>
imap <leader>p <Esc>:bp<CR>i

" \R         一键保存、编译、运行
imap <leader>R <ESC>:call Compile_Run_Code()<CR>
nmap <leader>R :call Compile_Run_Code()<CR>
vmap <leader>R <ESC>:call Compile_Run_Code()<CR>


" tabs
map <leader>tn :tabnew<cr>
map <leader>te :tabedit
" map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Line(s) move up/down
nnoremap <silent> <C-k>  :m-2<CR>==
nnoremap <silent> <C-j>  :m+<CR>==
xnoremap <silent> <C-k>  :m'<-2<CR>gv=gv
xnoremap <silent> <C-j>  :m'>+<CR>gv=gv

" =======
" Plugins
" =======

" NERDTree
let NERDTreeQuitOnOpen = 1
let NERDChristmasTree=1
let g:NERDTreeWinSize = 18
" autocmd VimEnter * NERDTree " auto start nerdtree
" autocmd vimenter * if !argc() | NERDTree | endif " if not file start too
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif " when no file colse nerdtree
let NERDTreeIgnore = ['\.pyc$','\.sock$'] "不显示的文件
map <leader>fl :NERDTreeToggle<CR>


" tComment - inherit the NERD_commenter shortkey
map <leader>ci <Plug>TComment-<Leader>__
map <leader>cm <Plug>TComment-<Leader>_b
" NERD_commenter      注释处理插件
" let loaded_nerd_tree = 1
" let NERDSpaceDelims = 1                        " 自动添加前置空格


" RUBY
" auto completed
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1
autocmd FileType ruby compiler ruby


" vim-markdown
" 设置md文件是否用自己的方式折叠
let g:vim_markdown_folding_disabled = 1




"set zen coding
 let g:user_zen_settings = {
  \  'php' : {
  \    'extends' : 'html',
  \    'filters' : 'c',
  \  },
  \  'xml' : {
  \    'extends' : 'html',
  \  },
  \  'haml' : {
  \    'extends' : 'html',
  \  },
  \  'erb' : {
  \    'extends' : 'html',
  \  },
  \}


"scss,sass
au BufRead,BufNewFile *.scss set filetype=scss
au BufRead,BufNewFile *.sass set filetype=scss

"coffee script
au BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable
au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
hi link coffeeSpaceError NONE
hi link coffeeSemicolonError NONE
hi link coffeeReservedError NONE
map <leader>cf :CoffeeCompile watch vert<cr>

"let skim use slim syntax
au BufRead,BufNewFile *.skim set filetype=slim

"auto completed
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0


" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete


let g:Powerline_cache_enabled = 1

"minitest
set completefunc=syntaxcomplete#Complete

"process past
set pastetoggle=<F3>
nnoremap <F3> :set invpaste paste?<CR>
imap <F3> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F3>

" RSpec.vim mappings
" map <Leader>t :call RunCurrentSpecFile()<CR>
" map <Leader>s :call RunNearestSpec()<CR>
" map <Leader>l :call RunLastSpec()<CR>
" map <Leader>a :call RunAllSpecs()<CR>

" 切换窗口光标
" switch window
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
"nnoremap <leader>w <C-W>w

" Goyo:the only writer
function! s:goyo_before()
  silent !tmux set status off
  set noshowmode
  set noshowcmd
endfunction
function! s:goyo_after()
  silent !tmux set status on
  set showmode
  set showcmd
endfunction
let g:goyo_callbacks = [function('s:goyo_before'), function('s:goyo_after')]
nmap <Leader><Space> :Goyo<CR>



" Airline:status bar
" 打开airline的扩展tab buffer exploer功能
let g:airline#extensions#tabline#enabled = 1
" determine whether bufferline will overwrite customization variables
let g:airline#extensions#bufferline#overwrite_variables = 1
" AirLine彩色状态栏
let g:airline_theme = 'badwolf'                " 设置主题
" configure the title text for quickfix buffers
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'

" Open URI under cursor or search.--go brower
nmap gb <Plug>(openbrowser-smart-search)
" Open URI selected word or search.
vmap gb <Plug>(openbrowser-smart-search)
" Open URI you also can use <leader>gb because of "textbrowser.vim"

" 配置高亮括号 kien/rainbow_parentheses.vim
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
"自定义关联文件类型
au BufNewFile,BufRead *.less set filetype=css
au BufNewFile,BufRead *.phtml set filetype=php

":Tlist              调用TagList
let Tlist_Show_One_File        = 1             " 只显示当前文件的tags
let Tlist_Exit_OnlyWindow      = 1             " 如果Taglist窗口是最后一个窗口则退出Vim
let Tlist_Use_Right_Window     = 1             " 在右侧窗口中显示
let Tlist_File_Fold_Auto_Close = 1             " 自动折叠

" Indent_guides       显示对齐线
let g:indent_guides_enable_on_vim_startup = 1  " 默认关闭
let g:indent_guides_guide_size            = 1  " 指定对齐线的尺寸



" <leader>a 排列归类
" <leader>ci 注释+// 可toggle
" <leader>cm 注释+/**/
"bn/bp 切换buffer
"tabn/tabp 切换tab
"tn 创建新窗口
"gb 打开或者搜索光标下的内容 这个好像有时候会失效
" <leader>g/f 搜索和查找
":retab 对当前文档重新替换tab为空格
"用Ctrl+v Tab也可以产生原生的Tab
"f  查找当前行的字符
"Ctrl+p 打开文件列表Ctrl+jk来选择文件
" <leader>be打开当前所有buffer的列表<leader>bs,<leader>bv
" <leader>Space 打开Goyo编写环境
" gf 如果是路径可以打开这个文件
" gd 找到定义
" :e $m<tab> 自动扩展到:e $MYVIMRC 然后打开_vimrc
" <c-y>,  扩展htmlcss的文件
" :Sw 给sudo权限保存
" :DiffSaved 比较当前修改了什么
"
"少用
"zz 把当前行移到屏幕中间
"ga 转换光标下的内容为多进制
":e $MYVIMRC 快速打开配置文件,$MYGVIMRC
" :set notextmode  去掉^M这个符号
" :set paste  这个可以解决在linux下面有些字母会被执行
" :set nopaster
" :set pastetoggle
" 如果碰到输入不了*号键，可以先按Ctrl+v，再输入想要输入的特殊符号
" gCtrl+g 统计字数
" Ctrl+x, Ctrl+f 补全当前要输入的路径
"
"
" manpageview phpfunctionname
" 可以使用快捷键K查询
"
"
" =========
" PHP
" =========
"只有在是PHP文件时，才启用PHP补全
" function AddPHPFuncList()
"     set dictionary+= "$HOME/.vim/vimfiles/resource/func.php.dict"
"     set complete-=k complete+=k
" endfunction
" autocmd FileType php call AddPHPFuncList()
" 除了使用Tab这个补全的方式，还可以使用Ctrl+x，Ctrl+o来补全上面文件的内置函数

" function! RunPhpcs()
    " let l:filename=@%
    " let l:phpcs_output=system('phpcs --report=csv --standard=YMC '.l:filename)
    " let l:phpcs_list=split(l:phpcs_output, "\n")
    " unlet l:phpcs_list[0]
    " cexpr l:phpcs_list
    " cwindow
    " endfunction

    " set errorformat+=\"%f\"\\,%l\\,%c\\,%t%*[a-zA-Z]\\,\"%m\"
" command! Phpcs execute RunPhpcs()
" php debug
let g:vdebug_keymap = {
\    "run"               : "<F5>",
\    "set_breakpoint"    : "<F9>",
\    "run_to_cursor"     : "<F1>",
\    "get_context"       : "<F2>",
\    "detach"            : "<F7>",
\    "step_over"         : "<F10>",
\    "step_into"         : "<F11>",
\    "step_out"          : '<leader><F11>',
\    "close"             : '<leader><F5>',
\    "eval_under_cursor" : "<Leader>ec",
\    "eval_visual"       : "<Leader>ev",
\}
let g:vdebug_options = {
\    "port"               : 9000,
\    "server"             : 'localhost',
\    "timeout"            : 20,
\    "on_close"           : 'detach',
\    "break_on_open"      : 0,
\    "path_maps"          : {},
\    "debug_window_level" : 0,
\    "debug_file_level"   : 0,
\    "debug_file"         : "",
\    "watch_window_style" : 'expanded',
\    "marker_default"     : '⬦',
\    "marker_closed_tree" : '▸',
\    "marker_open_tree"   : '▾'
\}

" ==============
" Syntastic: php
" ==============
"
" ===php===
" 要让vim支持php/js的错误查询，先安装syntastic插件
" 然后用php对应的版本pear install PHP_CodeSniffer-2.0.0a2
" shell测试：phpcs index.php
"在打开文件的时候检查
"phpcs，tab 4个空格，编码参考使用CodeIgniter风格
" let g:syntastic_phpcs_conf = "--tab-width=3 --standard=Zend"
" let g:syntastic_phpcs_conf = "--tab-width=4 --standard=CodeIgniter"
" 也可以在cli中执行下面的命令
" phpcs --config-set default_standard Zend
" 如果怕被phpcs提示的错误吓倒，可以把Zend改成none,这样就只会提示一些常见的错误
"
let g:phpqa_messdetector_ruleset = ''
let g:phpqa_messdetector_cmd = '/usr/bin/phpmd'
let g:phpqa_messdetector_autorun = 0

"
" ===js===
" 需要用nodejs下的包安装工具npm安装npm install -g jshint
" shell测试：jshint -version
"

" ==============
" web : html css
" ==============
" 只能在特定的文件里面才载入，默认是全局
let g:user_emmet_install_global = 0
autocmd FileType html,css,phtml,tpl EmmetInstall

" 这个主要用来对txt文档也可以用taglist列表
au BufEnter *.txt,*.log,*.ini setlocal ft=txt


autocmd BufReadPre * if getfsize(expand("%")) > 10000000 | syntax off | endif

autocmd BufRead,BufNewFile *.js set filetype=javascript syntax=jquery


"vim 插件调试
"检测插件加载时间
"vim filename --startuptime 'time.txt'
"下面代码可以检测加载插件总用时
"awk '{print $2}' time.txt | sed '/[0-9].*:/d' | awk '{sum+=$1} END {print sum}'
"检测vim在干什么 vim filename -V > savefilename
"
"

" c/c++环境开发IDE
" c开发介绍：http://blog.csdn.net/bokee/article/details/6633193
" Ctags
"inoremap  <c-]> <c-x><c-]> "ctags 补全快捷键
" 用ctrl+]和Ctrl+t跳转定义和返回
nmap <silent><leader>mt :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q <cr><cr>:echo 'Generate Ctags Done'<cr>
" nmap <leader>mt <ESC>:!ctags -R --languages=
" set tags+=~/gitdb/rails/tags
" 生成cscope
" nmap <leader>gc :!cscope -Rbq -f cscope/cs.out <CR><CR>:echo 'generate cscope done'<cr>
" cscope的使用
" <leader>f
" s: Find this C symbol
" g: Find this definition
" d: Find functions called by this function
" c: Find functions calling this function
" t: Find this text string
" e: Find this egrep pattern
" f: Find this file
" i: Find files #including this file
" 使用taglist <leader>tl
" 在. -> :: 等地方可以自动补全

"
"
"

" tips
" 从vim暂时的切换到Console
" 暂停vim方式:Ctrl+z, jobs, fg
" 使用vim的sh命令启动新console :sh
" 使用!bash启动一个console
" 直接执行!命令

" For Mac
"
" noremap <silent> <M-up> <C-W>+
" noremap <silent> <M-down> <C-W>-
"
" fix some unexpectly bugs
"

" deploy python
" source $VIM/rc/py

" if g:isWIN
"     let g:hexoProjectPath="D:\\Work\\GitHub\\hexo"
" else
"     let g:hexoProjectPath="~/hexo/"
" endif
" fun! OpenHexoProjPath()
"     execute "cd " . g:hexoProjectPath
" endfun
" function! OpenHexoPost(...)
"     call OpenHexoProjPath()
"
"     let filename = "source/_posts/" . a:1 . ".md"
"     execute "e " . filename
" endfunction
" function! NewHexoPost(...)
"     call OpenHexoProjPath()
"
"     let filename = a:1
"     execute "!hexo new " . filename
"
"     call OpenHexoPost(a:1)
" endfunction
" command -nargs=+ HexoOpen :call OpenHexoPost("<args>")
" command -nargs=+ HexoNew :call NewHexoPost("<args>")
" :HexoNew artical-name
" :HexoOpen artical-name

" map <leader>ag :Ag
" cnoreabbrev ag Ag
" cabbrev ag Ag
" there use special tech
cabbrev ag <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Ag' : 'ag')<CR>

" Syntastic
let g:syntastic_check_on_open        = 0
let g:syntastic_enable_signs         = 1
let g:syntastic_error_symbol         = '!!'
let g:syntastic_style_error_symbol   = '!¡'
let g:syntastic_warning_symbol       = '??'
let g:syntastic_style_warning_symbol = '?¿'

let c_no_curly_error = 1

let g:syntastic_c_checker          = "clang"
let g:syntastic_c_compiler_options = "-std=c11"

let g:syntastic_cpp_checker          = "clang++"
let g:syntastic_cpp_compiler_options = "-std=c++11"

let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'passive_filetypes': ['elixir', 'javascript'] }

" You Complete Me
"competeble with UltraSnips
let g:ycm_key_list_select_completion   = []
let g:ycm_key_list_previous_completion = []
let g:ycm_global_ycm_extra_conf        = $VIM . '/rc/ycm_extra_conf.py'
" 下里的filetype主要是和上面的syntastic对应，用于使用clang编译的情况
let g:ycm_extra_conf_vim_data          = ['&filetype', 'g:syntastic_c_compiler_options', 'g:syntastic_cpp_compiler_options']
let g:ycm_filetype_blacklist = {
    \ 'notes' : 1,
    \ 'markdown' : 1,
    \ 'text' : 1,
    \ 'gitcommit': 1,
    \ 'mail': 1,
\}
let g:ycm_error_symbol   = '>>'
let g:ycm_warning_symbol = '>*'
let g:ycm_collect_identifiers_from_tags_files = 1
" offer like ctags: declara, define and multi, only support c/cpp
" nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
" nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>



" CtrlP
" nnoremap <Leader>t :CtrlP getcwd()<CR>
" nnoremap <Leader>f :CtrlPClearAllCaches<CR>
" nnoremap <Leader>b :CtrlPBuffer<CR>
" nnoremap <Leader>j :CtrlP ~/<CR>
" nnoremap <Leader>p :CtrlP<CR>

" command! -nargs=* -complete=function Call exec 'call '.<f-args>
" command! Q q
" command! -bang Q q<bang>
" command! Qall qall
" command! -bang Qall qall<bang>
" command! W w
" command! -nargs=1 -complete=file E e <args>
" command! -bang -nargs=1 -complete=file E e<bang> <args>
" command! -nargs=1 -complete=tag Tag tag <args>
"
" Save a file that requires sudoing even when
" you opened it as a normal user.
command! Sw w !sudo tee % > /dev/null
" Show difference between modified buffer and original file
command! DiffSaved call s:DiffWithSaved()

command! Bw call CleanClose(1,0)
command! Bq call CleanClose(0,0)
command! -bang Bw call CleanClose(1,1)
command! -bang Bq call CleanClose(0,1)


au BufRead *vimrc setl foldmethod=marker foldlevel=0
" set foldenable
" set foldlevelstart=99
