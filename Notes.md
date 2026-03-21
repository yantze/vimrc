# Vim 速查手册

从 vimrc 提取的参考笔记，便于查阅而不干扰配置文件。

---

## 快捷键参考

### 标记与跳转

```
m0~9        标记文件位置
'0~9        跳转到标记位置
'+1~9       上次打开的文件
m+1~9       mark 1~9 文件的位置
```

### 暂时切换到终端

```
Ctrl+z      暂停 vim，回到 shell（jobs / fg 恢复）
:sh         vim 内启动新 shell
!bash       vim 内启动 bash console
:!命令       直接执行 shell 命令
```

### 光标跳转

```
0  ^  $              跳至行首 / 第一个非空字符 / 行尾
[ Ctrl+D             跳至当前变量的首次定义位置（从文件头）
[ Ctrl+I             跳至当前变量的首次出现位置（从文件头）
[ D                  列出当前变量的所有定义位置（从文件头）
[ I                  列出当前变量的所有出现位置（从文件头）
```

### 文本操作（动词 + 范围）

动词：`d`=删除，`c`=删除并进入插入，`y`=复制，`v`=选中

```
dw de d0 d^ d$  dd
cw ce c0 c^ c$  cc
yw ye y0 y^ y$  yy
vw ve v0 v^ v$
```

#### 分隔符内操作

```
di分隔符    删除分隔符之间内容（不含分隔符）
ci分隔符    删除并进入插入模式（不含分隔符）
yi分隔符    复制分隔符之间内容（不含分隔符）
vi分隔符    选中分隔符之间内容（不含分隔符）

da分隔符    删除（含分隔符）
ca分隔符    删除并进入插入模式（含分隔符）
ya分隔符    复制（含分隔符）
va分隔符    选中（含分隔符）
```

> 可在动词后加数字指定括号层次，如 `d2i(` 删除外围第二层括号内的内容

#### 到指定字符

```
dt字符  删除到该字符（不含）    df字符  删除到该字符（含）
ct字符  删除到该字符并插入      cf字符  删除到该字符并插入（含）
yt字符  复制到该字符（不含）    yf字符  复制到该字符（含）
vt字符  选中到该字符（不含）    vf字符  选中到该字符（含）
```

> `T`/`F` 是 `t`/`f` 的反方向操作

### 便捷操作

```
Ctrl+A              当前光标下数字自增 1（普通模式）
Ctrl+X              当前光标下数字自减 1（普通模式）
m字符 / '字符       标记位置 / 跳转到标记
q字符 xxx q / @字符 录制宏 / 执行宏
ga                  显示光标下字符的十进制/十六进制/八进制值
gCtrl+g             统计字数
Ctrl+x Ctrl+f       补全路径
```

### 窗口与 Diff

```
Ctrl+h/j/k/l        光标切换到相邻窗口（自定义映射）
:vert diffsplit file 垂直 diff 对比文件
dp                  diffput，将当前块推送到另一侧
```

---

## 技巧与命令参考

### 调试 Vim 启动

```bash
vim -V9/tmp/vim.log   # 详细日志写入文件
```

```vim
:messages             " 查看最近的错误/提示消息
:help g<              " 帮助 g< 命令
```

### 查看变量与设置

```vim
echo &statusline      " 查看某个选项的值
set statusline?       " 查看选项名和当前值
:let                  " 列出所有已定义变量
```

### 二进制文件编辑

```vim
vim -b file           " 以二进制模式打开
:%!xxd                " 切换为十六进制视图
:%!xxd -r             " 还原为普通格式
```

### 编码与特殊字符

```vim
" 去掉 BOM
set nobomb | set fileencoding=utf8 | w

" 去掉 ^M 符号
:%s/\r//g
:set notextmode
```

### Buffer 管理

```vim
:ls!                  " 显示缓冲区列表
:b2                   " 切换到缓冲区 2
:bdelete 3            " 从列表移除缓冲区 3
:bwipe                " 彻底清除缓冲区
:w | %bd | e#         " 关闭所有缓冲区，只保留当前
```

### Tab / Session 管理

```vim
:tabn / :tabp         " 切换 tab
:tabnew               " 新建 tab
:retab                " 对当前文档重新替换 tab 为空格

:mks ~/.vim/sessions/foo.vim    " 保存 session
:source ~/.vim/sessions/foo.vim " 恢复 session
```

### 实用命令

```vim
:r! {command}         " 将命令输出插入光标下方
:highlight            " 查看高亮代号
:e $MYVIMRC           " 快速打开 vimrc（:e $m<Tab> 可补全）
Ctrl+v Tab            " 插入真实的 Tab 字符
Ctrl+x Ctrl+]         " ctags 补全（插入模式）
```

### 正则统计

```vim
" 统计字符数
:%s/./&/gn

" 统计单词数
:%s/\i\+/&/gn
```

### VimScript 技巧

```vim
" 用两个 <CR> 隐藏命令执行后的提示信息
map F :call FormatCode() <CR><CR>

" map <silent> 也可以隐藏提示
map <silent> F :call FormatCode()<CR>

" nnoremap：n=normal 模式，noremap=不递归映射（避免一键多动）
" 命令别名示例
cnoreabbrev ag Ack
```

---

## 自定义快捷键速查（vimrc 定义）

| 快捷键 | 功能 |
|--------|------|
| `,` | Leader 键 |
| `;` | 等同于 `:`（命令模式） |
| `fd` | 退出插入模式（同 Esc） |
| `F2` | 切换相对/绝对行号 |
| `F3` | 切换粘贴模式 |
| `F4` | 切换自动换行 |
| `F5` | 切换显示特殊字符 |
| `<space>` | 切换当前折叠 |
| `<leader>zz` | 展开/折叠所有 |
| `<leader>R` | 保存并编译运行当前文件 |
| `<leader>n` / `<leader>p` | 下/上一个缓冲区 |
| `<leader><space>` | fzf 缓冲区列表 |
| `<leader>tn` | 新建 tab |
| `<leader>te` | 编辑 tab |
| `<leader>tm` | 移动 tab |
| `<leader>bb` | Tabularize 按 `=` 对齐 |
| `<leader>ba` | Tabularize 按 `=` 对齐（不含 `=`） |
| `<leader>bn` | Tabularize 自定义对齐 |
| `<leader>16` | 切换十六进制视图 |
| `<leader>r16` | 还原十六进制视图 |
| `<leader>rl` | 删除行尾空格 |
| `<leader>rt` | 替换 Tab 为空格 |
| `<leader>tt` | 设置 tab=2 |
| `<leader>t4` | 设置 tab=4 |
| `<leader>rso` | 重新加载 vimrc |
| `<leader>rsl` | 在 shell 中执行选中行 |
| `<leader>ml` | 追加 modeline |
| `<leader>anu` | 给选中行添加行号 |
| `<leader>tig` | 切换 IndentGuides |
| `<leader>tch` | 在当前列添加/移除颜色列标记 |
| `<leader>C` | 复制到云剪贴板（xcopy） |
| `<leader>c` | 复制选中到系统剪贴板 |
| `<leader>v` | 从系统剪贴板粘贴 |
| `<leader>a` | 复制全文到系统剪贴板 |
| `<leader>q` | 退出所有窗口 |
| `<leader>x` | 保存并退出当前文件 |
| `gb` | 智能打开浏览器（open-browser） |
| `Ctrl+h/j/k/l` | 切换窗口（普通模式） |
| `Ctrl+e` / `Ctrl+y` | 滚动 2 行 |
| `g;` / `g,` | 跳转到前/后一次编辑位置（居中） |
| `:Sw` | sudo 保存文件 |
| `:DiffSaved` | diff 当前缓冲区与磁盘文件 |
