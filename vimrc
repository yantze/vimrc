" author: yantze
" $VIMHOME/vimrc.bundles " the package location
let g:color_dark = 1
" let g:no_vimrc_bundles = 1

" General {

" Enviroment {

    " Basic
    let mapleader=","
    " 在之前用 <leader> 会使用默认的'\'
    map ; :

    " 共享系统粘贴板
    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else
            " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    " 统一变量
    let $VIMHOME = $HOME."/.vim"
    let $VIMRC = $MYVIMRC

    " Enable built-in matchit
    packadd! matchit

    " Package Manager
    " 安装插件 :PlugInstall
    if !exists("g:no_vimrc_bundles") && !empty(glob("$VIMHOME/vimrc.bundles"))
        source $VIMHOME/vimrc.bundles
    endif

    " the ^[ is an Esc char that comes before the 'a'
    " In most default configs, ^[a may be typed by pressing first <C-v>, then <M-a>
" }

" Functions {

    " there func is for internal function invoal
    " not relate the other plugin

    func! CopyToCloud()
        exec ":w !tee | xcopy"
        " https://github.com/yantze/dotfiles/blob/master/usrbin/xcopy
    endfunc

    func! CopySelectedToCloud()
        exec ":'<,'>:w !tee | xcopy"
    endfunc

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
            exec "%s/	/    /g"
        end
    endfunc

    func! RemoveQuotas()
        silent! exec "%s/[“”]/\"/g"
        silent! exec "%s/[‘’]/\'/g"
    endfunc

    func! Tab2()
        set tabstop=2
        set shiftwidth=2
        set softtabstop=2
    endfunc

    func! Tab4()
        " tab 键宽度为4空格
        set tabstop=4
        " 每一次缩进对应的空格数
        set shiftwidth=4
        " 按退格键可以一次删掉4个空格
        set softtabstop=4
    endfunc

    " Diff current unsaved file
    function! s:DiffWithSaved()
        let filetype=&ft
        diffthis
        vnew | r # | normal! 1Gdd
        diffthis
        exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
    endfunction


    " 编译并运行
    func! Compile_Run_Code()
        exec "w"
        if &filetype == "c"
            exec "!clang -Wall -std=c11 -o %:r %:t && ./%:r"
        elseif &filetype == "cpp"
            exec "!clang++ -Wall -std=c++14 `pkg-config --cflags` -o %:r %:t && ./%:r"
        elseif &filetype == "d"
            exec "!dmd -wi %:t && ./%:r"
        elseif &filetype == "go"
            exec "!go run %:t"
        elseif &filetype == "rust"
            exec "!rustc %:t && ./%:r"
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
            " exec "!tsc %:t && node %:r.js"
            exec "!npx ts-node %:r.ts"
        elseif &filetype == "javascript"
            " exec "!node --experimental-modules  %:t"
            exec "!node %:t"
        elseif &filetype == "sh"
            exec "!bash %:t"
        elseif &filetype == "applescript"
            exec "!osascript %:t"
        endif
    endfunc

    " Append modeline after last line in buffer.
    " Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
    " files.
    function! AppendModeline()
        let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
                    \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
        let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
        call append(line("$"), l:modeline)
    endfunction

    function! SetCurLineNum()
        let g:nal_cur_line_num = line("v")
    endfunction

    function! AddLineNum()
        let num1 = line("v")
        let num2 = num1 - g:nal_cur_line_num + 1
        let num2 = " " . num2
        "echo num2
        return num2
    endfunction

    function! SetColorColumn()
        let col_num = virtcol(".")
        let cc_list = split(&cc, ',')
        if count(cc_list, string(col_num)) <= 0
            " cc(colorcolumn)选项需要vim7.3以上版本才支持.
            execute "set cc+=".col_num
        else
            execute "set cc-=".col_num
        endif
    endfunction
" }

" }
" Setting {

" Basic {

    syntax enable                " 打开语法高亮
    syntax on                    " 开启文件类型侦测
    filetype indent on           " 针对不同的文件类型采用不同的缩进格式
    filetype plugin on           " 针对不同的文件类型加载对应的插件
    filetype plugin indent on    " 启用自动补全
    set visualbell t_vb=         " 关闭visual bell/声音
    " set t_Co=256               " 设置文字可以显示多少种颜色, 历史原因可能是比 8-bit 色彩更少, 可能比 8-bit 终端更早
    au GuiEnter * set t_vb=      " 关闭beep/屏闪
    " set t_ti= t_te=            " 退出 vim 后,vim 的内容仍显示在屏幕上

    set backspace=2              " 设置退格键可用
    set ruler                    " 右下角显示光标位置的状态行
    set hidden                   " 允许在有未保存的修改时切换缓冲区
    set laststatus=2             " 开启状态栏信息
    set cmdheight=2              " 命令行的高度，默认为1，这里设为2
    " set bsdir=buffer           " 设定文件浏览器目录为当前目录
    " set autochdir " sometimes can not work
    autocmd BufEnter * silent! lcd %:p:h
    set wildmenu                 " 在命令行下显示匹配的字段到状态栏里面
    " set cursorcolumn           " 突出显示当前列
    set history=500              " keep 500 lines of command line history
    silent! set mouse=a          " 启用鼠标

    set cursorline               " 突出显示当前行
    " set tw=78                  "超过80个字符就折行(textwrap)
    " set viminfo='20,\"50       " read/write a .viminfo file, don't store more than 50 lines of registers
    set display=lastline         " 不要显示@@@@@
    " set conceallevel=2         " 隐藏想要隐藏的字符
    " set fillchars+=vert:\      " 设置 split bar 的内容字符
    " set foldcolumn=2           " 左侧窗边的宽度

    " 光标的上下方至少保留显示的行数
    set scrolloff=3

    set showmatch                " 显示括号配对情况

    " set lsp=0                  " 设置行间距

    " => Modify word boundary characters
    " insert schema, ctrl+w and other keys likes emacs
    set iskeyword+=- " remove - as a word boundary
    set iskeyword+=$

" }

" 文件配置 {
    if has("multi_byte")
        set fo+=mB " formatoptions 打开断行模块对亚洲语言支持
        " if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        "     set ambiwidth=double " 自动用宽字符显示(如果全角字符不能识别)
        " endif
    endif


    " 相对行号 {

    if v:version > 703
        set relativenumber number
        " 插入模式下用绝对行号,普通模式下用相对
        " augroup numbertoggle
        "     autocmd!
        "     autocmd BufEnter,FocusGained,InsertLeave * set relativenumber " nonumber
        "     autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber number
        " augroup END

        function! NumberToggle()
            if(&relativenumber == 1)
                set norelativenumber nonumber
            else
                set relativenumber number
            endif
        endfunc
        nnoremap <F2> :call NumberToggle()<cr>

        " no num and relative
        " nnoremap <leader><F3> :set relativenumber!<CR>:set nu!<CR>
        " imap <leader><F3>     :set relativenumber!<CR>:set nu!<CR>
    endif

    " }


    set list                     " 显示特殊字符，其中Tab使用高亮竖线代替，尾部空白使用高亮点号代替
    " set showbreak=↪\           " 显示换行后新行的首字符
    set listchars=tab:→\ ,extends:›,precedes:‹,nbsp:␣,trail:·
    " set listchars=tab:\|\ ,trail:. " 设置tab/尾部字符用什么填充

    " set fileformats=unix                           " 设定换行符
    set wrap
    set linebreak                                    " 自动断行, 用 breakat 控制
    set enc=utf-8                                    " 设置编码
    " set fenc=utf-8                                   " 设置文件编码
    set fencs=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936 " 设置文件编码检测类型及支持格式
    set shortmess+=filmnrxoOtT                       " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash  " Better Unix / Windows compatibility
    " set virtualedit=onemore                          " Allow for cursor beyond last character

    set autoread                 " 当文件在外部被修改时自动更新该文件
    set writebackup              " Make a backup before overwriting a file. The backup is removed after the file was successfully written, unless the 'backup' option is also on.
    set nobackup                 " 不生成备份文件
    set noswapfile               " 不生成交换文件

    " restore last postion in file to $VIMHOME/view
    " 打开自动定位到最后编辑的位置, 需要确认 .viminfo 当前用户可写
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


    if v:version > 703
        set undofile " 持续保留操作记录,默认filename.un~, valid feature for `vim --version` have +persistent_undo
        if empty(glob("$VIMHOME/_undodir"))
            call mkdir(expand("$VIMHOME/_undodir"))
        endif
        set undodir=$VIMHOME/_undodir
        set undolevels=1000  " maximum number of changes that can be undone"
    endif
" }

" GUI {

" Solarized 主题
let g:solarized_termcolors=16 " 16 | 256
let g:solarized_termtrans=1 " 0 | 1
let g:solarized_contrast="normal" " 'normal' | 'high' or 'low'
let g:solarized_visibility="normal" " 'normal' | 'high' or 'low'
let g:solarized_bold = 1 " 1 | 0
" highlight LineNr ctermbg=none ctermfg=grey " 设置行号背景为 none
" g:solarized_degrade = 0 | 1
" g:solarized_underline = 1 | 0
" g:solarized_italic = 1 | 0
" g:solarized_contrast = “normal”| “high” or “low”

if exists("g:color_dark")
    set background=dark
else
    set background=light
endif
highlight LineNr ctermbg=none ctermfg=none " 设置行号背景为 none
if &background == 'light'
    hi CursorLine term=bold cterm=bold ctermbg=7 guibg=Grey90
    hi Folded term=bold,underline cterm=bold,underline ctermfg=11 ctermbg=7 guifg=DarkBlue guibg=LightGrey
endif
" 设置着色模式和字体
" colortheme list: pt_black ir_black grb256 BusyBee pt_black solarized xoria256
silent! colorscheme solarized

" pure vim {
    " if get(g:, 'colors_name', 'default') == 'default'
    "     if &background == 'light'
    "         hi CursorLine term=bold cterm=bold ctermbg=7 guibg=Grey90
    "         hi Folded term=bold,underline cterm=bold,underline ctermfg=11 ctermbg=7 guifg=DarkBlue guibg=LightGrey
    "     endif
    " endif
" }

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

    set smartindent      " 自动缩进
    set autoindent       " 自动对齐

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
    set smarttab

" }

" 粘贴模式 {

    " 在插入模式下按 <F3> 进入粘贴模式,这时候粘贴复制过来的代码不会触发自动缩进
    set pastetoggle=<F3>
    " 离开插入模式时,关闭粘贴模式
    autocmd InsertLeave * set nopaste

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

" Statusline {
" 当没有 airline 插件的时候使用这里的自定义
if !&statusline

    " https://shapeshed.com/vim-statuslines/
    " http://vim.wikia.com/wiki/Writing_a_valid_statusline
    " http://learnvimscriptthehardway.stevelosh.com/chapters/17.html
    function! GitBranch()
      return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
    endfunction
    function! StatuslineGit()
      let l:branchname = GitBranch()
      return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
    endfunction
    set statusline=
    set statusline+=%#PmenuSel#                 " change background color
    " set statusline+=[%n]                        " buffer num
    " set statusline+=%{StatuslineGit()}
    set statusline+=%#LineNr#                   " change background color
    set statusline+=\ %f                        " file name
    " set statusline+=\ %.20F                     " file path, length limit 20%
    set statusline+=%m\                         " check modify status
    set statusline+=%=                          " align right
    set statusline+=%#CursorColumn#
    set statusline+=\ %y
    set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
    set statusline+=\[%{&fileformat}\]          " fileformat
    set statusline+=\ %l/%L:%c
    set statusline+=\ %p%%
    set statusline+=\                           " space at end

endif
" }

" => Wild Ignore {

    " 忽略这些扩展文件

    " Disable output and VCS files
    set wildignore+=*.rbc,*.rbo,*.gem,.git,.svn

    " Disable image files
    set wildignore+=*.psd,*.png,*.jpg,*.gif,*.jpeg

    " Disable archive files
    set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

    " Ignore bundler and sass cache
    set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

    " Disable temp and backup files
    set wildignore+=*.sw?,*~,._*,*.un~

    " WP Language files
    set wildignore+=*.pot,*.po,*.mo

    " Fonts and such
    set wildignore+=*.eot,*.eol,*.ttf,*.otf,*.afm,*.ffil,*.fon,*.pfm,*.pfb,*.woff,*.svg,*.std,*.pro,*.xsf

    set wildignore+=*.aux,*.out,*.toc " LaTeX intermediate files
    set wildignore+=*.so,*.out,*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
    set wildignore+=*.luac " Lua byte code
    set wildignore+=*.pyc " Python byte code
    set wildignore+=*.class" Python byte code
    set wildignore+=*.spl " compiled spelling word lists
    set wildignore+=*/tmp/*,.DS_Store  " MacOSX/Linux

" }

" }
" Scene Setting {

" Python {
    " python highlight
    let python_highlight_all = 1

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

" JavaScript & Node {

    " F         格式化当前页面 js,html,css. 可选中局部格式化

    " au FileType javascript,coffee,slim,jade set shiftwidth=2
    " au FileType javascript,offee,slim,jade set tabstop=2

    " au BufRead,BufNewFile *.scss set filetype=scss
    " au BufRead,BufNewFile *.sass set filetype=scss
    " au BufRead,BufNewFile *.js set filetype=javascript syntax=jquery
    " au BufRead,BufNewFile *.less set filetype=css
    " au BufRead,BufNewFile *.coffee setl foldmethod=indent nofoldenable
    " au BufRead,BufNewFile *.coffee setl shiftwidth=2 expandtab

    au BufNewFile,BufRead *.ts,*.tsx,*.js,*.jsx,*.html,*.css,*.less
        \ set tabstop=2 |
        \ set softtabstop=2 |
        \ set shiftwidth=2

    au FileType javascript set fdm=syntax

    " ignore Node and JS stuff
    set wildignore+=*/node_modules/*,*.min.js

" }

" C/C++ {

    " c/c++环境开发IDE
    " c开发介绍：http://blog.csdn.net/bokee/article/details/6633193
    " Ctags
    " inoremap  <c-]> <c-x><c-]> "ctags 补全快捷键
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

" }

" Other {
    " 对部分语言设置单独的缩进
    au FileType json,scala,clojure,lua,dart,sh set shiftwidth=2
    au FileType json,scala,clojure,lua,dart,sh set tabstop=2
    " 针对部分语言取消指定字符的单词属性
    au FileType clojure  set iskeyword-=.
    au FileType clojure  set iskeyword-=>
    au FileType perl,php set iskeyword-=$

    au BufRead,BufNewFile *.applescript set filetype=applescript
    au BufRead,BufNewFile *.scpt set filetype=applescript

    " au BufReadPre *.txt,*.log,*.ini setlocal ft=txt

    " gg=G format for xml
    au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null

    " json
    au FileType json set fdm=syntax
" }

" }
" Shortcut {
" ,fl 可以查单词

" marker 使用
" m 0~9 标记文件
" ' 0~9 随时打开文件

" tips: 从vim暂时的切换到Console
" 暂停vim方式:Ctrl+z, jobs, fg
" 使用vim的sh命令启动新console :sh
" 使用!bash启动一个console
" 直接执行:!命令


" ,ig                        --显示/关闭对齐线
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



" Ctrl + h/j/k/l 移动光标到上下左右位置
" Ctrl + H/J/K/L 移动窗口到上下左右位置
" '+1~9 上次打开的文件
" m+1~9 mark 1~9文件的位置
" :vert diffsplit main.c
" dp : diffput,把增加的部分放到另外一边


" -------- 自定义快捷键 --------

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
nmap <leader>bb :Tabularize /=<CR>

" \ba                 不要把 = 放入排列
nmap <leader>bb :Tabularize /=\zs<CR>

" \bn                 自定义对齐    [Tabular插件]
nmap <leader>bn :Tabularize /

" \16                 十六进制格式查看
nmap <leader>16 <ESC>:%!xxd<ESC>

" \r16                返回普通格式
nmap <leader>r16 <ESC>:%!xxd -r<ESC>

" \r<cr>
" cntrl : Removing control symbols
" ^print : Removing non-printable characters (note that in versions prior to ~8.1.1 this removes non-ASCII characters also):
" :%!tr -cd '[:print:]\n'
nmap <leader>r<cr> :%s/[[:cntrl:]]\\|[^[:print:]]//g<CR>

" \rl                 一键去除所有尾部空白 trailing remove
nmap <leader>rl <ESC>:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" \rt                 一键替换全部Tab为空格
" imap <leader>rt <ESC>:call RemoveTabs()<CR>
nmap <leader>rt :call RemoveTabs()<CR>
vmap <leader>rt <ESC>:call RemoveTabs()<CR>

" \rso
nmap <leader>rso :so ~/.vim/vimrc<CR>

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

" 关于缓冲区，可以用 bd 删除当前缓冲区
" ls! 显示当前缓冲区列表，然后 :b2 选择缓冲区
" 关闭所有缓冲，只保留当前 :w | %bd | e#

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

" 用 fzf 插件， <leader><space> 默认选中的就是上次打开的 buffer
nnoremap <Leader><space> :Buffers<CR>

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

nnoremap <leader><F4> :set undofile!<CR>
imap <leader><F4>     :set undofile!<CR>

" 切换窗口光标
" switch window
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
"nnoremap <leader>w <C-W>w

" map j to gj and k to gk, so line navigation ignores line wrap
nnoremap j gj
nnoremap k gk
vmap j gj
vmap k gk

" F4 换行开关
nnoremap <F4> :set wrap! wrap?<CR>

" F5 显示可打印字符开关
nnoremap <F5> :set list! list?<CR>

" 滚动屏幕为2行
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" 退出所有窗口
nnoremap <leader>q :qa<CR>

" 保存并退出当前编辑文件
nnoremap <leader>x :x<CR>

" set tab 2
nnoremap <leader>tt :call Tab2()<CR>
" set tab 4
nnoremap <leader>t4 :call Tab4()<CR>

" 使用 xcopy 拷贝数据到自己的云粘贴板
nnoremap <leader>C :call CopyToCloud()<CR>
vmap <leader>C :call CopySelectedToCloud() <CR>
" ==创建 Tags===
"
nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>

" ## Command

" Save a file that requires sudoing even
command! Sw w !sudo tee % > /dev/null
" Show difference between modified buffer and original file
command! DiffSaved call s:DiffWithSaved()

" 给选中行添加行号
map <silent> <leader>anu :%s/^/\=line(".")." "/g<cr>
vmap <silent> <leader>anu o<esc>:call SetCurLineNum()<cr>gv:s/^/\=AddLineNum()." "/<cr>

" 跳转到前一次和后一次编辑的地方
nnoremap g; g;zz
nnoremap g, g,zz

" 使用 fd 作为 Esc 退出快捷键
imap fd <Esc>


" }
" Notes {

    " Check runtime message
    " vim -V9myVim.log
    " last error message
    " :messages
    " help g<

    " 变量
    " 查看设置的值
    " echo &statusline
    " 查看设置的键与值
    " set statusline?

    " 显示当前定义的变量直接输入:
    " :let

    " :exe "normal! " . (winwidth(0)-3) . "aa\<Esc>2a\<C-V>u3042")
    "
    " repeat 字符串
    " exec 'map <F2> :silent! let g:g="'.repeat('foobar ',200).'"<cr>'

" it can be changed on the fly with:
" :let g:vim_markdown_folding_level = 1
" :edit

" 编辑二进制文件
" vim -b file     %!xxd 切换为十六进制

" 把當前文件復制一份, 其後綴名為A.txt
"map <silent> <leader>no :A.txt<esc>

" 用Ctrl+v Tab可以产生原生的Tab
" :e $m<tab> 自动扩展到:e $MYVIMRC 然后打开vimrc
"
" 少用
" ga 转换光标下的内容为多进制
" 碰到不能输入*号键，先按Ctrl+v，再输入想要输入的特殊符号
" gCtrl+g 统计字数
" Ctrl+x, Ctrl+f 补全当前要输入的路径

" tabn/tabp 切换tab
" tabnew 创建新窗口
" :retab 对当前文档重新替换tab为空格
" :set notextmode  去掉^M这个符号
" :set paste  这个可以解决在linux下面有些字母会被执行 nopaste pastetoggle

" 去掉BOM
" set nobomb; set fileencoding=utf8; w

" vim sessions
" :mks ~/.vim/sessions/foo.vim
" :source ~/.vim/session/foo.vim



" :r! {command}   insert the standard output of {command} below the cursor
" ga              show ascii value of character under cursor in decimal, hex, and octal
" :bdelete 3      把一个缓冲区从列表中去除
" :bwipe          把一个缓冲区从列表中彻底去除
" :highlight      查看高亮代号



" ==== Regex ====
" 字符数
" :%s/./&/gn<cr>
" 单词数
" :%s/\i\+/&/gn<cr>

" :%s/\r//g<CR>  " 一键替换特殊字符 ^M
" 相同功能 :set notextmode



" === 函数学习 ===
" 更多可以看前面 function 片段
" function CloseBuffer()
"   exe 'normal! :w | %bd | e#'
" endfunction
" nmap <Tab> :call CloseBuffer()<CR>
" nnoremap 里第一个 n 代表 normal mode，后面的 noremap 代表不要重复映射，这是避免一个按键同时映射多个动作用的
"
" 用两个<CR>可以隐藏执行命令后出现的提示信息"
" map F :call FormatCode() <CR><CR>
" map <silent>F 也可以隐藏
" map F :%s/{/{\r/g <CR> :%s/}/}\r/g <CR>  :%s/;/;\r/g <CR> gg=G
" 命令别名
" cnoreabbrev ag Ack


" }
" Locals {

    let g:snips_author = 'yantze'
    let g:snips_email  = 'ivastiny@gmail.com'
    let g:snips_info   = 'https://vastiny.com'

    " For neovim python support
    let g:python3_host_prog = '/Users/yantze/.pyenv/shims/python3'

    if filereadable(expand("~/.vimrc_local"))
        source ~/.vimrc_local
    endif

    " 下面格式的文件当作 zip 包打开
    autocmd BufReadCmd *.xmind,*.crx,*.apk,*.whl,*.egg  call zip#Browse(expand("<amatch>"))

    " 在 Windows 里面改变编码
    " autocmd CmdwinEnter    * fenc=cp936

    " 界面相关的快捷键以 ,w 开头
" }

" Modern Defaults & Auto-commands {
    " 保存时自动去除行尾空格 (Neovim 现代方式)
    autocmd BufWritePre * if &ft != 'diff' | silent! %s/\s\+$//e | endif

    " 设置现代配色
    if has('nvim')
        silent! colorscheme catppuccin-mocha
    else
        silent! colorscheme solarized
    endif
" }

" vim: set ts=4 sw=4 tw=0 et fdm=marker foldmarker={,} foldlevel=0 foldenable foldlevelstart=99 :
