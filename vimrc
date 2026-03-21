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
            exec "!fsharpc %:t && ./%:r.exe"
        elseif &filetype == "scheme" || &filetype == "racket"
            exec "!racket -fi %:t"
        elseif &filetype == "lisp"
            exec "!sbcl --load %:t"
        elseif &filetype == "ocaml"
            exec "!ocamlc -o %:r %:t && ./%:r"
        elseif &filetype == "haskell"
            exec "!ghc -o %:r %:t && ./%:r"
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
    filetype plugin indent on    " 文件类型检测 + 插件 + 缩进
    set visualbell t_vb=         " 关闭 visual bell/声音（terminal Vim）
    " set t_ti= t_te=            " 退出 vim 后,vim 的内容仍显示在屏幕上

    set hidden                   " 允许在有未保存的修改时切换缓冲区（仅 Vim 需要，Neovim 已默认）
    set laststatus=2             " 开启状态栏（仅 Vim 需要，Neovim 已默认）
    set cmdheight=2              " 命令行的高度
    augroup vimrc_autolcd
        autocmd!
        autocmd BufEnter * silent! lcd %:p:h
    augroup END
    set history=10000            " 历史记录条数（Vim 8+ 默认已是 10000）
    silent! set mouse=a          " 启用鼠标

    set cursorline               " 突出显示当前行
    " set conceallevel=2         " 隐藏想要隐藏的字符
    " set fillchars+=vert:\      " 设置 split bar 的内容字符
    " set foldcolumn=2           " 左侧窗边的宽度

    " 光标的上下方至少保留显示的行数
    set scrolloff=3

    set showmatch                " 显示括号配对情况

    " set lsp=0                  " 设置行间距


" }

" 文件配置 {
    if has("multi_byte")
        set fo+=mB " formatoptions 打开断行模块对亚洲语言支持
        " if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        "     set ambiwidth=double " 自动用宽字符显示(如果全角字符不能识别)
        " endif
    endif


    " 相对行号 {

    set relativenumber number

    function! NumberToggle()
        if(&relativenumber == 1)
            set norelativenumber nonumber
        else
            set relativenumber number
        endif
    endfunc
    nnoremap <F2> :call NumberToggle()<cr>

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
    augroup vimrc_lastpos
        autocmd!
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    augroup END


    set undofile " 持续保留操作记录
    if empty(glob("$VIMHOME/_undodir"))
        call mkdir(expand("$VIMHOME/_undodir"))
    endif
    set undodir=$VIMHOME/_undodir
    set undolevels=1000  " maximum number of changes that can be undone
" }

" GUI {

if exists('g:color_dark')
    set background=dark
else
    set background=light
endif
highlight LineNr ctermbg=none ctermfg=none " 设置行号背景为 none
if &background == 'light'
    hi CursorLine term=bold cterm=bold ctermbg=7 guibg=Grey90
    hi Folded term=bold,underline cterm=bold,underline ctermfg=11 ctermbg=7 guifg=DarkBlue guibg=LightGrey
endif

" solarized 关键参数：termtrans=1 使用终端原生背景色（避免与命令行背景色不一致）
let g:solarized_termcolors=256  " 使用终端 256 色，与终端配色一致
let g:solarized_termtrans=1    " 透明背景，复用终端背景色

" colortheme list: pt_black ir_black grb256 BusyBee solarized xoria256 wombat256 molokai
silent! colorscheme solarized

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

    " cindent 仅在 C/C++ 文件类型中启用（通过 ftplugin），避免干扰其他语言

" }

" Search {

    " incsearch / magic 在 Vim 8+/Neovim 已是默认值
    set hlsearch                 " 开启高亮显示结果（仅 Vim 需要，Neovim 已默认）
    set nowrapscan               " 搜索到文件两端时不重新搜索
    set ic                       " 忽略大小写查找
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
    set wildignore+=*.class " Java byte code
    set wildignore+=*.spl " compiled spelling word lists
    set wildignore+=*/tmp/*,.DS_Store  " MacOSX/Linux

" }

" }
" Scene Setting {

augroup vimrc_filetypes
    autocmd!

    " Python
    let python_highlight_all = 1
    autocmd BufRead *.wsgi setl filetype=python
    autocmd BufNewFile,BufRead *.py,*.pyw
        \ set tabstop=4 |
        \ set softtabstop=4 |
        \ set shiftwidth=4 |
        \ set textwidth=79 |
        \ set expandtab |
        \ set autoindent |
        \ set fileformat=unix
    autocmd BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix

    " JavaScript / TypeScript / HTML / CSS
    autocmd BufNewFile,BufRead *.ts,*.tsx,*.js,*.jsx,*.html,*.css,*.less
        \ set tabstop=2 |
        \ set softtabstop=2 |
        \ set shiftwidth=2
    autocmd FileType javascript set fdm=syntax

    " C/C++ - 生成 ctags: <leader>mt
    " cindent 仅对 C 系文件类型启用
    autocmd FileType c,cpp set cindent

    " Other languages - 缩进
    autocmd FileType json,scala,clojure,lua,dart,sh set shiftwidth=2 tabstop=2

    " iskeyword per filetype
    autocmd FileType css,scss,less,html set iskeyword+=-
    autocmd FileType javascript,typescript,javascriptreact,typescriptreact set iskeyword+=$
    autocmd FileType php set iskeyword+=$
    autocmd FileType clojure set iskeyword-=. iskeyword-=>

    " Filetype detection
    autocmd BufRead,BufNewFile *.applescript,*.scpt set filetype=applescript

    " XML formatting with xmllint
    autocmd FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null

    " JSON syntax folding
    autocmd FileType json set fdm=syntax

augroup END

" ignore Node and JS stuff
set wildignore+=*/node_modules/*,*.min.js

" C/C++ - ctags
nmap <silent><leader>mt :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q <cr><cr>:echo 'Generate Ctags Done'<cr>

" }
" Shortcut {
" 快捷键参考详见 ~/.vim/Notes.md

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
nmap <leader>ba :Tabularize /=\zs<CR>

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

map <c-tab> :tabn<CR>
imap <c-tab> <Esc>:tabn<CR>i

map <c-s-tab> :tabp<CR>
imap <c-s-tab> <Esc>:tabp<CR>i

" 关于缓冲区: bd 删除, ls! 列表, :b2 选择, :w | %bd | e# 只保留当前

" 下一个缓冲区
map <leader>n :bn<CR>
imap <leader>n <Esc>:bp<CR>i
map <c-F3> :bn<CR>
imap <c-F3> <Esc>:bp<CR>i

" 上一个缓冲区
map <leader>p :bp<CR>
imap <leader>p <Esc>:bp<CR>i
map <c-F2> :bp<CR>
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
" Locals {

    " For neovim python support
    let g:python3_host_prog = '/Users/yantze/.pyenv/shims/python3'

    if filereadable(expand("~/.vimrc_local"))
        source ~/.vimrc_local
    endif

    augroup vimrc_locals
        autocmd!
        " 下面格式的文件当作 zip 包打开
        autocmd BufReadCmd *.xmind,*.crx,*.apk,*.whl,*.egg call zip#Browse(expand("<amatch>"))
        " 保存时自动去除行尾空格（排除 diff 和 markdown，markdown 两个尾部空格表示换行）
        autocmd BufWritePre * if index(['diff', 'markdown'], &ft) < 0 | silent! %s/\s\+$//e | endif
    augroup END

    " 界面相关的快捷键以 ,w 开头
" }

" vim: set ts=4 sw=4 tw=0 et fdm=marker foldmarker={,} foldlevel=0 foldenable foldlevelstart=99 :
