" author: yantze
" $VIM/vimrc.bundles " the package location

" Section folded because of not often change, unfold with key za / space
" General {

" Enviroment {
" Base {
        let mapleader=","
        " 如果在这之前用<leader>，那么<leader>代表的是之前的leader"
        map ; :

        " restore last postion in file to vimfiles/view
        " 打开自动定位到最后编辑的位置, 需要确认 .viminfo 当前用户可写
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

        " 判断是否处于GUI界面
        if has("gui_running")
            let g:isGUI = 1
        else
            let g:isGUI = 0
        endif
    " }

    " Identify platform {
        silent function! OSX()
            return system('uname')=~'Darwin'
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
            " set runtimepath=$HOME.'\.vim',$VIM.'\vimfiles',$VIMRUNTIME
            if has("statusline")
                set statusline  =%<%f\ %h%m%r%=%{(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\")}
                set statusline +=%{\"[\".&ff.\"]\"} "file format
                set statusline +=%k
                set statusline +=\ %h%m%r%=%-14.(%l,%c%V%)\ %P
            endif
        else
            " 兼容windows的环境变量$VIM
            let $VIM = $HOME."/.vim"
            set shell=/bin/sh
            " adapt gvim $VIMRC
            let $VIMRC=$MYVIMRC
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
            " 导致 ESC 延迟反应
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

        " if &term=="xterm"
        "     set t_Co=8
        "     set t_Sb=[4%dm
        "     set t_Sf=[3%dm
        " endif
        "
        " 共享系统粘贴板
        if has('clipboard')
            if has('unnamedplus')  " When possible use + register for copy-paste
                set clipboard=unnamed,unnamedplus
            else
                " On mac and Windows, use * register for copy-paste
                " windows/mac 粘贴板一起用，不方便
                set clipboard=unnamed
            endif
        endif



    " }

    " Package manager{
        " 添加vundle插件管理器
        set nocompatible               " 设置不与之前版本兼容 be iMproved
        filetype off                   " 检测文件类型 required!
        " set no_plugin=1 to do not add-on plugin
        " let g:no_plugin=1
        if !exists("g:no_plugin")
            if filereadable(expand("$VIM/bundle/Vundle.vim/README.md"))
                set rtp+=$VIM/bundle/Vundle.vim  "添加vendle环境变量
                source $VIM/vimrc.bundles
            endif
        endif
        " you can put it in tmpfs:/dev/shm/.dotfiles/vimrc/vimfiles/bundle/Vundle.vim
        " 安装新的插件 :PluginInstall
        " 在命令行运行 vim +PluginInstall +qall
        " 更新插件:PluginUpdate
        " 清除不再使用的插件:PluginClean,
        " 列出所有插件:PluginList
        " 查找插件:PluginSearch
    " }

" }

" Functions {

" there func is for internal function invoal
" not relate the other plugin

func! RemoveTabs()
    if &shiftwidth == 2
        exec "%s/    /  /g"
    elseif &shiftwidth == 4
        exec "%s/    /    /g"
    elseif &shiftwidth == 6
        exec "%s/    /      /g"
    elseif &shiftwidth == 8
        exec "%s/    /        /g"
    else
        exec "%s/    / /g"
    end
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

" Mydict, use *dict* in vim {
function! Mydict()
    let expl=system('dict ' . expand("<cword>"))
    windo if expand("%")=="dict.tmp" | q! | endif
    " botright vertical 33split dict.tmp
    botright 12split dict.tmp
    " botright cwindow
    setlocal buftype=nofile bufhidden=hide noswapfile
    set report=2 " ignore the following 'one line' substitution
    set nonu
    1s/^/\=expl/
    1
    set report=0 " recovery the 'report' setting
endfunction
" Mydict }

" 编译并运行
func! Compile_Run_Code()
    exec "w"
    if &filetype == "c"
        if WINDOWS()
            exec !gcc -Wall -std=c11 -o %:r %:t && %:r.exe"
        else
            exec "!clang -Wall -std=c11 -o %:r %:t && ./%:r"
            " exec "!gcc -Wall -o %:r %:t && ./%:r"
        endif
    elseif &filetype == "cpp"
        if WINDOWS()
            exec "!g++ -Wall -std=c++11 -o %:r %:t && %:r.exe"
        else
            " exec "!g++ -Wall -std=c++11 -o %:r %:t && ./%:r"
            exec "!clang++ -Wall -std=c++11 `pkg-config --cflags --libs opencv`  -o %:r %:t && ./%:r"
            " -ggdb " add gdb support
        endif
    elseif &filetype == "d"
        if WINDOWS()
            exec "!dmd -wi %:t && %:r.exe"
        else
            exec "!dmd -wi %:t && ./%:r"
        endif
    elseif &filetype == "go"
        exec "!go run %:t"
    elseif &filetype == "rust"
        if WINDOWS()
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
            exec "!mcs %:t && mono %:r.exe"
    elseif &filetype == "fsharp"
        if WINDOWS()
            exec "!fsc %:t && %:r.exe"
        else
            exec "!fsharpc %:t && ./%:r.exe"
        endif
    elseif &filetype == "scheme" || &filetype == "racket"
        exec "!racket -fi %:t"
    elseif &filetype == "lisp"
        exec "!sbcl --load %:t"
    elseif &filetype == "ocaml"
        if WINDOWS()
            exec "!ocamlc -o %:r.exe %:t && %:r.exe"
        else
            exec "!ocamlc -o %:r %:t && ./%:r"
        endif
    elseif &filetype == "haskell"
        if WINDOWS()
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
        exec "!python3 %:t"
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
    elseif &filetype == "applescript"
        exec "!osascript %:t"
    endif
endfunc

" 生成cscope和tags文件
function! Do_CsTag()
    let dir = getcwd()
    if filereadable("tags")
        if WINDOWS()
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    if filereadable("cscope.files")
        if WINDOWS()
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if WINDOWS()
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif
    if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if WINDOWS()
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
    let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
                \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(line("$"), l:modeline)
endfunction

function! RemoveOldViewFiles()
    exe 'find '.$VIM.'/view/* -mtime +90 -exec rm {} \;'
endfunction

function! MakeSession()
    if !has('gui_running')
        hi clear
    endif
    if bufname('')  == ''
        exe 'bdelete '.bufnr('')
    endif
    let l:count = 0
    let l:i = 0
    while l:i <= bufnr('$')
        if buflisted(count)
            let l:count += 1
        endif
        let l:i+=1
    endwhile
    if l:count >= 4
        mksession! ~/.last_session.vim
    endif
endfunction

function! LoadSession()
    "if exists('g:SessionLoaded')
    "return
    "endif
    if expand('%') == '' && filereadable($HOME.'/.last_session.vim') && !&diff
        silent so ~/.last_session.vim
    endif

    let l:buftotal = bufnr('$')
    let l:i = 0
    let l:crtpath = getcwd()
    while l:i <= l:buftotal
        " 列表中还未载入的buffer，如果不在当前工作目录，会被删除
        if !bufloaded(l:i) && buflisted(l:i) && expand('%:p') !~ l:crtpath
            exe 'bdelete '.l:i
            echo expand('%:p') .' !~ '. l:crtpath
        endif
        let l:i += 1
    endwhile
endfunction

" }

" Setting {

" GUI & WIN {
" 设置着色模式和字体
if WINDOWS()
    " 使用GUI界面时的设置
    if g:isGUI
        " 启动gvim时窗口的大小
        " set lines=42 columns=170
        " 启动时自动最大化窗口
        " au GUIEnter * simalt ~x

        " winpos 20 20             " 指定窗口出现的位置，坐标原点在屏幕左上角
        " set lines=20 columns=90  " 指定窗口大小，lines为高度，columns为宽度
        set guioptions+=c        " 使用字符提示框
        set guioptions-=m        " 隐藏菜单栏
        set guioptions-=T        " 隐藏工具栏
        set guioptions-=L        " 隐藏左侧滚动条
        set guioptions-=r        " 隐藏右侧滚动条
        " set guioptions-=b        " 隐藏底部滚动条
        " set showtabline=1        " 隐藏Tab栏
        set guioptions+=aA       " get some autoselect interaction with the system clipboard

        " colortheme list: molokai autumn blackboard asu1dark busybee tomorrow
        " colorscheme solarized  " deep blue
        " colorscheme morning    " white

        " let g:zenburn_transparent = 1 " black
        let g:zenburn_high_Contrast = 1
        colorscheme zenburn      " grey, my fav
        " colorscheme desertEx

        " set font
        set guifont=Consolas:h12
        " set guifont=Monaco:h11
        " set guifont=Source\ Code\ Pro\ Regular:h15
        " set guifont=YaHei\ Consolas\ Hybrid:h13
        " set guifont=Source\ Code\ Pro:h13

    else
        colorscheme CodeFactoryv3
        " colorscheme ir_black
        " 兼容windows下cmd的gb2312
        " set enc=cp936
        " help encoding-table
        set termencoding=cp936
        " In order to reload a file with proper encoding you can do:
        " :e! ++enc=<the_encoding>.
        " dos里面<backspace>和<c-h>完全链接了，要取消<c-h>的映射
        iunmap <c-h>

    endif
else
    if g:isGUI
        if has("gui_gtk2")
            " set guifont=DejaVu\ Sans\ Mono\ 14
        elseif has("gui_macvim")
            " set guifont=DejaVu_Sans_Mono:h14
            set guifont=Monaco:h12
            set guifontwide=HiraginoSansGB-W3:h12
        end

        " set guifont=Monaco\ 13
        " set guifontwide=HiraginoSansGB-W3:h15
        " set guifont=YaHei\ Consolas\ Hybrid:h13
        set background=light
        colorscheme solarized
        set lines=38 columns=140

        " 在 macvim 中，不支持
        " set nu!
    else
        " set background=light
        " g:solarized_termcolors= 16 | 256
        " g:solarized_termtrans = 0 | 1
        " g:solarized_degrade = 0 | 1
        " g:solarized_bold = 1 | 0
        " g:solarized_underline = 1 | 0
        " g:solarized_italic = 1 | 0
        " g:solarized_contrast = “normal”| “high” or “low”
        " g:solarized_visibility= “normal”| “high” or “low”

        " colortheme list: ir_black grb256 BusyBee pt_black solarized xoria256
        colorscheme pt_black
    endif
endif

" }

" 代码折叠 {
set foldenable
" 折叠方法
" manual    手工折叠
" indent    使用缩进表示折叠
" expr      使用表达式定义折叠
" syntax    使用语法定义折叠
" diff      对没有更改的文本进行折叠
" marker    使用标记进行折叠, 默认标记是 {{{ 和 }}}, 可以自定义为 `set foldmarker={,}`
set foldmethod=indent
set foldlevel=99
" 代码折叠自定义快捷键 <leader>zz
nnoremap <space> za             " 用空格来切换折叠状态
let g:FoldMethod = 0
map <leader>zz :call ToggleFold()<cr>
fun! ToggleFold()
    if g:FoldMethod == 0
        exe "normal! zM"
        let g:FoldMethod = 1
    else
        exe "normal! zR"
        let g:FoldMethod = 0
    endif
endfun
" }

" 缩进配置 {
    set smartindent
    " 自动缩进
    set autoindent

    " tab 键宽度为4空格
    set tabstop=4
    " 每一次缩进对应的空格数
    set shiftwidth=4
    " 按退格键可以一次删掉4个空格
    set softtabstop=4
    set smarttab
    " 将 tab 自动转化成空格 (需要输入真正的Tab键时，使用 Ctrl+V + Tab)
    set expandtab
    " 缩进时,取整
    set shiftround

    set cindent
    " 详细的tab设置：http://blog.chinaunix.net/uid-24774106-id-3396220.html
    set smarttab                 "在行首按TAB将加入sw个空格，否则加入ts个空格;按Backspace可以删除4个空格



" }

" 相对行号 {
if v:version > 703
    set relativenumber number
    autocmd FocusLost * :set norelativenumber number
    autocmd FocusGained * :set relativenumber
    " 插入模式下用绝对行号,普通模式下用相对
    autocmd InsertEnter * :set norelativenumber number
    autocmd InsertLeave * :set relativenumber
    function! NumberToggle()
      if(&relativenumber == 1)
        set norelativenumber nonumber
      else
        set relativenumber number
      endif
    endfunc
    nnoremap <leader><F2> :call NumberToggle()<cr>

    " no num and relative
    " nnoremap <leader><F3> :set relativenumber!<CR>:set nu!<CR>
    " imap <leader><F3>     :set relativenumber!<CR>:set nu!<CR>
endif

" }

" 粘贴模式 {
" 在插入模式下按 <F3> 进入粘贴模式,这时候粘贴复制过来的代码不会触发自动缩进
set pastetoggle=<F3>
" 离开插入模式时,关闭粘贴模式
autocmd InsertLeave * set nopaste
" 在插入模式使用粘贴会自动开启粘贴模式,不需要手动设置
function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

nnoremap <F3> :set invpaste paste?<CR>
imap <F3> <C-O>:set invpaste paste?<CR>

" }"

" Search {
set incsearch                " 开启实时搜索功能,查询时非常方便，如要查找book单词，当输入到/b时，会自动找到第一个b开头的单词，当输入到/bo时，会自动找到第一个bo开头的单词
set hlsearch                 " 开启高亮显示结果
set nowrapscan               " 搜索到文件两端时不重新搜索
set ic                       " 忽略大小写查找
" 搜索正则匹配规则改变 见帮助 :h magic
set magic
" 搜索模式为默认更先进的正则规则
" nnoremap / /\v
" vnoremap / /\v
" }

syntax enable                " 打开语法高亮
syntax on                    " 开启文件类型侦测
filetype indent on           " 针对不同的文件类型采用不同的缩进格式
filetype plugin on           " 针对不同的文件类型加载对应的插件
filetype plugin indent on    " 启用自动补全
set visualbell t_vb=         " 关闭visual bell/声音
au GuiEnter * set t_vb=      " 关闭beep/屏闪

" 文件配置
" set fileformats=unix                             " 设定换行符

if has("multi_byte")
    set formatoptions+=mM
    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif
endif

set enc=utf-8                                    " 设置编码
set fenc=utf-8                                   " 设置文件编码
set fencs=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936 " 设置文件编码检测类型及支持格式
set shortmess+=filmnrxoOtT                       " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash  " Better Unix / Windows compatibility
" set virtualedit=onemore                          " Allow for cursor beyond last character
" set bsdir=buffer                               " 设定文件浏览器目录为当前目录,default value
" set autochdir

set bsdir=buffer                                 " 设定文件浏览器目录为当前目录
" 把这个快捷键放在这里主要是因为dos的vim对这个不支持，其它的系统支持
imap <c-h> <ESC>I


set backspace=2              " 设置退格键可用
set autoindent               " 自动对齐
set smartindent              " 智能自动缩进
set ruler                    " 右下角显示光标位置的状态行
set hidden                   " 允许在有未保存的修改时切换缓冲区
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
" set cursorcolumn             " 突出显示当前列
set history=500              " keep 500 lines of command line history
set mouse=a                  " 启用鼠标
set wrap linebreak nolist    " wrap，only wrap at a character in the breakat option (by default, this includes " ^I!@*-+;:,./?" , linebreak 不在单词中间断行

" set tw=78                    "超过80个字符就折行(textwrap)
" set viminfo='20,\"50         " read/write a .viminfo file, don't store more than 50 lines of registers
set display=lastline         " 不要显示@@@@@


" set ambiwidth=double         "如果全角字符不能识别一般用这个(自动用宽字符显示)
set fo+=mB                   "打开断行模块对亚洲语言支持
set showmatch                " 显示括号配对情况
" set lsp=0                    "设置行间距


if v:version > 703
    set undofile                 " 重新打开文件可恢复上次关闭的撤销记录,默认filename.un~, only use for `vim --version` have +persistent_undo feature
    set undodir=$VIM/\_undodir
    set undolevels=1000 "maximum number of changes that can be undone"
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Wild settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Disable image files
set wildignore+=*.psd,*.png,*.jpg,*.gif,*.jpeg

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*,*.un~

" WP Language files
set wildignore+=*.pot,*.po,*.mo

" Fonts and such
set wildignore+=*.eot,*.eol,*.ttf,*.otf,*.afm,*.ffil,*.fon,*.pfm,*.pfb,*.woff,*.svg,*.std,*.pro,*.xsf

set wildignore+=*.aux,*.out,*.toc " LaTeX intermediate files
set wildignore+=*.luac " Lua byte code
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.pyc " Python byte code
set wildignore+=*.spl " compiled spelling word lists
set wildignore+=*.sw? " Vim swap files
" \ig                        --显示/关闭对齐线
" 0 or ^ or $                --跳至 行首 or 第一个非空字符 or 行尾
"

"
" [ Ctrl+D                   --跳至当前光标所在变量的首次定义位置 [从文件头部开始]
" [ Ctrl+I                   --跳至当前光标所在变量的首次出现位置 [从文件头部开始]
" [ D                        --列出当前光标所在变量的所有定义位置 [从文件头部开始]
" [ I                        --列出当前光标所在变量的所有出现位置 [从文件头部开始]
"
" ---------- 文本操作 ----------
"
" dw de d0 d^ d$ dd          --删除
" cw ce c0 c^ c$ cc          --删除并进入插入模式
" yw ye y0 y^ y$ yy          --复制
" vw ve v0 v^ v$ vv          --选中
"
" di分隔符                   --删除指定分隔符之间的内容 [不包括分隔符]
" ci分隔符                   --删除指定分隔符之间的内容并进入插入模式 [不包括分隔符]
" yi分隔符                   --复制指定分隔符之间的内容 [不包括分隔符]
" vi分隔符                   --选中指定分隔符之间的内容 [不包括分隔符]
"
" da分隔符                   --删除指定分隔符之间的内容 [包括分隔符]
" ca分隔符                   --删除指定分隔符之间的内容并进入插入模式 [包括分隔符]
" ya分隔符                   --复制指定分隔符之间的内容 [包括分隔符]
" va分隔符                   --选中指定分隔符之间的内容 [包括分隔符]
"
" Xi和Xa都可以在X后面加入一个数字，以指代所处理的括号层次
" 如 d2i( 执行的是删除当前光标外围第二层括号内的所有内容
"
" dt字符                     --删除本行内容，直到遇到第一个指定字符 [不包括该字符]
" ct字符                     --删除本行内容，直到遇到第一个指定字符并进入插入模式 [不包括该字符]
" yt字符                     --复制本行内容，直到遇到第一个指定字符 [不包括该字符]
" vt字符                     --选中本行内容，直到遇到第一个指定字符 [不包括该字符]
"
" df字符                     --删除本行内容，直到遇到第一个指定字符 [包括该字符]
" cf字符                     --删除本行内容，直到遇到第一个指定字符并进入插入模式 [包括该字符]
" yf字符                     --复制本行内容，直到遇到第一个指定字符 [包括该字符]
" vf字符                     --选中本行内容，直到遇到第一个指定字符 [包括该字符]
"
" XT 和 XF 是 Xt/Xf 的反方向操作
"
" ---------- 便捷操作 ----------
"
" Ctrl + A                   --将当前光标所在数字自增1        [仅普通模式可用]
" Ctrl + X                   --将当前光标所在数字自减1        [仅普通模式可用]
" m字符       and '字符      --标记位置 and 跳转到标记位置
" q字符 xxx q and @字符      --录制宏   and 执行宏

" 对部分语言设置单独的缩进
au FileType scala,clojure,lua,dart,sh set shiftwidth=2
au FileType scala,clojure,lua,dart,sh set tabstop=2
" 针对部分语言取消指定字符的单词属性
au FileType clojure  set iskeyword-=.
au FileType clojure  set iskeyword-=>
au FileType perl,php set iskeyword-=$

" 去掉BOM
" set nobomb; set fileencoding=utf8; w

" Emmet.vim
" div>p#foo$*3>a
" https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL

"{

if !exists("g:no_plugin")
    autocmd BufWinLeave *.* if expand('%') != '' && &buftype == '' | mkview | endif
    autocmd BufRead     *.* if expand('%') != '' && &buftype == '' | silent loadview | endif
    " autocmd BufWinEnter *.* silent loadview  " 恢复状态
    " autocmd BufWinLeave *.* mkview! " 保存文件的折叠状态
    " *.* is better for me than using just *, as when I load Vim it defaults to [No File]
    " au BufWinLeave ?* silent mkview 1 " 星号前面的问号是忽略未命名文件
    " 状态保存在 ~/.vim/view 文件夹,如果保存了之后,修改了 filetype 的 syntax 属性,需要删除 view 才能更新
endif
" nnoremap 里第一个 n 代表 normal mode，后面的 noremap 代表不要重复映射，这是避免一个按键同时映射多个动作用的




"
"
"marker 使用
" m 0~9 标记文件
" ' 0~9 随时打开文件

" tips: 从vim暂时的切换到Console
" 暂停vim方式:Ctrl+z, jobs, fg
" 使用vim的sh命令启动新console :sh
" 使用!bash启动一个console
" 直接执行:!命令

    "auto completed
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0

    " }

    " ==创建 Tags===
    "
    map <F12> :call Do_CsTag()<CR>
    nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
    nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
    nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
    nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
    nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
    nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
    nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>

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


    " ==类型检测和设置==
    "
    " au BufReadPre *.txt,*.log,*.ini setlocal ft=txt

    au BufReadPre * if getfsize(expand("%")) > 10000000 | syntax off | endif

    au BufRead,BufNewFile *.applescript set filetype=applescript
    au BufRead,BufNewFile *.scpt set filetype=applescript

    " ==全局设置==
    "
    autocmd BufEnter * lcd %:p:h  " 每打开一个文件进入当前文件目录
    " au BufWritePre /tmp/* setl undofile " 无效果

    " => Modify word boundary characters
    " insert schema, ctrl+w and other keys likes emacs
    " remove - as a word boundary (i.e. making a keyword character)
    set iskeyword+=-
    " remove $ as a word boundary (i.e. making a keyword character)
    set iskeyword+=$


" }

" }

" Shorcut {

" =======
" 自定义快捷键
" =======

" tabn/tabp 切换tab
" tabnew 创建新窗口
" :retab 对当前文档重新替换tab为空格
" 用Ctrl+v Tab可以产生原生的Tab
" <leader>Space 打开Goyo编写环境
" :e $m<tab> 自动扩展到:e $MYVIMRC 然后打开vimrc
"
" 少用
" ga 转换光标下的内容为多进制
" :set notextmode  去掉^M这个符号
" :set paste  这个可以解决在linux下面有些字母会被执行 nopaste pastetoggle
" 碰到不能输入*号键，先按Ctrl+v，再输入想要输入的特殊符号
" gCtrl+g 统计字数
" Ctrl+x, Ctrl+f 补全当前要输入的路径
"
"







" Ctrl + h/j/k/l 移动光标到上下左右位置
" Ctrl + H/J/K/L 移动窗口到上下左右位置
" '+1~9 上次打开的文件
" m+1~9 mark 1~9文件的位置
" :vert diffsplit main.c
" dp : diffput,把增加的部分放到另外一边
"
" mapping search with Ack
"nnoremap <leader>f :Ack<space>


" Win paste
" imap <C-V> <C-r>+

" 把 CTRL-S 映射为 保存
" imap <C-S> <C-C>:w<CR>


" 用两个<CR>可以隐藏执行命令后出现的提示信息"
" map F :call FormatCode() <CR><CR>
" map <silent>F 也可以隐藏
" F                   格式化输出(已抛弃,js-beautify better)
" map F :%s/{/{\r/g <CR> :%s/}/}\r/g <CR>  :%s/;/;\r/g <CR> gg=G


" Ctrl + H            光标移当前行行首/已经搬到兼容区
" imap <c-h> <ESC>I

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

" \rb                 一键去除所有尾部空白 trailing
" imap <leader>rb <ESC>:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
nmap <leader>rb <ESC>:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
vmap <leader>rb <ESC>:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" \rt                 一键替换全部Tab为空格
" imap <leader>rt <ESC>:call RemoveTabs()<CR>
nmap <leader>rt :call RemoveTabs()<CR>
vmap <leader>rt <ESC>:call RemoveTabs()<CR>

" \rl
nmap <leader>rl :so ~/.vimrc<CR>

" \r<cr>              一键替换特殊字符 ^M
" 相同功能 :set notextmode
" imap <leader>rcr <ESC>:%s/\r//g<CR>
nmap <leader>r<cr> :%s/\r//g<CR>
vmap <leader>r<cr> <ESC>:%s/\r//g<CR>

" \th                 一键生成与当前编辑文件同名的HTML文件 [不输出行号]
" imap <leader>th <ESC>:set nonumber<CR>:set norelativenumber<CR><ESC>:TOhtml<CR><ESC>:w %:r.html<CR><ESC>:q<CR>:set number<CR>:set relativenumber<CR>
nmap <leader>th <ESC>:set nonumber<CR>:set norelativenumber<CR><ESC>:TOhtml<CR><ESC>:w %:r.html<CR><ESC>:q<CR>:set number<CR>:set relativenumber<CR>
vmap <leader>th <ESC>:set nonumber<CR>:set norelativenumber<CR><ESC>:TOhtml<CR><ESC>:w %:r.html<CR><ESC>:q<CR>:set number<CR>:set relativenumber<CR>

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

" 下一个缓冲区
:nmap <leader>n :bn<CR>
:map <leader>n :bn<CR>
imap <leader>n <Esc>:bp<CR>i
:nmap <c-F3> :bn<CR>
:map <c-F3> :bn<CR>
imap <c-F3> <Esc>:bp<CR>i


" 上一个缓冲区
:nmap <leader>p :bp<CR>
:map <leader>p :bp<CR>
imap <leader>p <Esc>:bp<CR>i
:nmap <c-F2> :bp<CR>
:map <c-F2> :bp<CR>
imap <c-F2> <Esc>:bp<CR>i

" \R         一键保存、编译、运行
imap <leader>R <ESC>:call Compile_Run_Code()<CR>
nmap <leader>R :call Compile_Run_Code()<CR>
vmap <leader>R <ESC>:call Compile_Run_Code()<CR>

" \rsl       执行选中行命令
" run the select line in bash
vmap <leader>rsl <esc>:'<,'>:w !sh <CR>
" run the select line output result
vmap <leader>rso <esc>:'<,'>!sh <CR>
" FYI: omitting :w will replace the selection with the command's output.

" \ml        add modeline, display like this: " vim: set ts=4 sw=4 tw=78 et :
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

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

nnoremap <leader><F4> :set undofile!<CR>
imap <leader><F4>     :set undofile!<CR>

" 切换窗口光标
" switch window
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
"nnoremap <leader>w <C-W>w

nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" map j to gj and k to gk, so line navigation ignores line wrap
nnoremap j gj
nnoremap k gk
vmap j gj
vmap k gk

" }

" Scene {

" ManPage {
    " manpageview phpfunctionname.php
    " 可以使用快捷键K查询
    " 说明，比如你在centos里面装了man-pages，当你用K查询的时候，自动会弹出man 你光标下面的词
    " manpageview 替代了插件pydoc.vim
    " 查找当前的单词意思,quick close: ZZ/:q
    nmap <silent><leader>K :call Mydict()<CR>
    "
" }

" Instant Preview Markdown {
    let g:instant_markdown_autostart = 0
    map <leader>rp :InstantMarkdownPreview<CR>
" }

" Python {
    " Base Setting {
        " python highlight
        let python_highlight_all = 1
        let b:python_version_2 = 1
        let g:python_version_2 = 1

        au BufRead *.wsgi setl filetype=python

        au BufNewFile,BufRead *.py,*.pyw
            \ set tabstop=4 |
            \ set softtabstop=4 |
            \ set shiftwidth=4 |
            \ set textwidth=79 |
            \ set expandtab |
            \ set autoindent |
            \ set fileformat=unix |

        " Use UNIX (\n) line endings.
        au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix

        " Display tabs at the beginning of a line in Python mode as bad.
        " au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
        " Make trailing whitespace be flagged as bad.
        " au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/


        " 支持Virtualenv虚拟环境

        " 上面“转到定义”功能的一个问题，就是默认情况下Vim不知道virtualenv虚拟环境的情况，所以你必须在配置文件中添加下面的代码，使得Vim和YouCompleteMe能够发现你的虚拟环境：

        " python with virtualenv support
        " py << EOF
        " import os
        " import sys
        " if 'VIRTUAL_ENV' in os.environ:
        "   project_base_dir = os.environ['VIRTUAL_ENV']
        "   activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
        "   execfile(activate_this, dict(__file__=activate_this))
        " EOF
        " 这段代码会判断你目前是否在虚拟环境中编辑，然后切换到相应的虚拟环境，并设置好你的系统路径，确保YouCompleteMe能够找到相应的site packages文件夹。
        " 上面的代码似乎已经被下面的插件智能解 决
        " https://github.com/jmcantrell/vim-virtualenv
        " 如果有一天一直使用 python  可以考虑把 python 放在单独的一个文件配置中, 参考这篇文章
        " https://segmentfault.com/a/1190000003962806
    " }
" }

" PHP {
    " Base Setting {
        let g:phpcomplete_relax_static_constraint = 1
        let g:phpcomplete_complete_for_unknown_classes = 1
        let g:phpcomplete_search_tags_for_variables = 1
        let g:phpcomplete_mappings = {
          \ 'jump_to_def': ',g',
          \ }

        "只有在是PHP文件时，才启用PHP补全
        function! AddPHPFuncList()
            set dictionary+=$HOME/.vim/vimfiles/resource/php-offical.dict
            set complete-=k complete+=k
        endfunction

        " Map <leader>el to error_log value
        " takes the whatever is under the cursor and wraps it in error_log( and
        " print_r( with parameter true and a label
        au FileType php nnoremap <leader>el ^vg_daerror_log( '<esc>pa=' . print_r( <esc>pa, true ) );<cr><esc>

        au FileType php call AddPHPFuncList()
        au FileType php setlocal omnifunc=syntaxcomplete#Complete
        au BufNewFile,BufRead *.phtml set filetype=php

        " set tags+= ~/.vim/vimfiles/resource/tags-php

        " autocmd FileType php setlocal omnifunc=phpcomplete#CompleteTags
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
        \    "marker_default"     : '*',
        \    "marker_closed_tree" : '+',
        \    "marker_open_tree"   : '-'
        \}

        " 要让vim支持php/js的错误查询，先安装syntastic插件
        " 然后用php对应的版本pear install PHP_CodeSniffer-2.0.0a2
        " shell测试：phpcs index.php
        " phpcs，tab 4个空格，编码参考使用CodeIgniter风格
        " let g:syntastic_phpcs_conf = "--tab-width=3 --standard=Zend"
        " let g:syntastic_phpcs_conf = "--tab-width=4 --standard=CodeIgniter"
        " 也可以在cli中执行下面的命令
        " phpcs --config-set default_standard Zend
        " 如果怕被phpcs提示的错误吓倒，可以把Zend改成none,这样就只会提示一些常见的错误
        "
        let g:phpqa_messdetector_ruleset = ''
        let g:phpqa_messdetector_cmd = '/usr/bin/phpmd'
        " 在打开文件的时候检查
        let g:phpqa_messdetector_autorun = 0
    " }
" }

" RUBY {
    " 针对部分语言取消指定字符的单词属性
    au FileType ruby     set iskeyword+=!
    au FileType ruby     set iskeyword+=?

    " 对部分语言设置单独的缩进
    au FileType ruby,eruby set shiftwidth=2
    au FileType ruby,eruby set tabstop=2

    " auto completed
    let g:rubycomplete_buffer_loading = 1
    let g:rubycomplete_classes_in_global = 1
    let g:rubycomplete_rails = 1
    autocmd FileType ruby compiler ruby
" }

" Node {

    " shortcut
    " F         格式化当前页面 js,html,css. 可选中局部格式化

    " au FileType javascript,coffee,slim,jade set shiftwidth=2
    " au FileType javascript,offee,slim,jade set tabstop=2

    " au BufRead,BufNewFile *.scss set filetype=scss
    " au BufRead,BufNewFile *.sass set filetype=scss
    " au BufRead,BufNewFile *.js set filetype=javascript syntax=jquery
    " au BufRead,BufNewFile *.less set filetype=css
    " au BufRead,BufNewFile *.coffee setl foldmethod=indent nofoldenable
    " au BufRead,BufNewFile *.coffee setl shiftwidth=2 expandtab

    au BufNewFile,BufRead *.js,*.html,*.css
        \ set tabstop=4 |
        \ set softtabstop=4 |
        \ set shiftwidth=4

    " ignore Node and JS stuff
    set wildignore+=*/node_modules/*,*.min.js

    hi link coffeeSpaceError NONE
    hi link coffeeSemicolonError NONE
    hi link coffeeReservedError NONE
    map <leader>cf :CoffeeCompile watch vert<cr>

" }


" }

" Locals {

if filereadable(expand("~/.local/.vimrc_local"))
    source ~/.local/.vimrc_local
endif

if $MYENV == 'tmux_light'
    set background=light
    colorscheme solarized
elseif $MYENV == 'term_light'
    colorscheme pt_light
else
    " set background=dark
    " colorscheme pt_black
endif

" Session files Vim关闭时保存会话状态
" set sessionoptions+=unix
" set sessionoptions-=blank
"set sessionoptions-=options
" autocmd VimEnter * call LoadSession()
" autocmd VimLeave * call MakeSession()

" 自动补全配置
" 让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
set completeopt=longest,menu

" 回车即选中当前项
inoremap <expr> <CR>       pumvisible() ? "\<c-y>" : "\<cr>"



" F4 换行开关
nnoremap <F4> :set wrap! wrap?<CR>

" F5 显示可打印字符开关
nnoremap <F5> :set list! list?<CR>

    " 退出 vim 后,vim 的内容仍显示在屏幕上
    set t_ti= t_te=

    " 光标的上下方至少保留显示的行数
    set scrolloff=10

    " 滚动屏幕为2行
    nnoremap <C-e> 2<C-e>
    nnoremap <C-y> 2<C-y>

    " 退出所有窗口
    nnoremap <leader>q :qa<CR>

    " 保存并退出当前编辑文件
    nnoremap <leader>x :x<CR>




" }

" vim: set ts=4 sw=4 tw=0 et fdm=marker foldmarker={,} foldlevel=0 foldenable foldlevelstart=99 :
