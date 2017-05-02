# VIMRC

### 不需要插件常用命令
可运行无插件模式，速度非常快，`alias v='vim --cmd "let g:no_plugin=1"'`

| Action                  | Description                                                                     |
| ---                     | ---                                                                             |
| /xxx                    | 查找xxx字符串                                                                   |
| 10G                     | 数字10和大写的G，跳到第十行                                                     |
| zz                      | 把当前行移到屏幕中间                                                            |
| f<char>                 | 查找当前行的字符                                                                |
| gb                      | go browser，光标下如果是url链接，自动用默认浏览器打开链接，                     |
|                         | 如果是选中的字符串，就用浏览器搜索, ,gb是另外一个插件提供的同样功能             |
| gf                      | 如果光标下是一个文件路径，则可以用vim自动打开这个文件                           |
| gd                      | 找到光标下的标签定义                                                            |
| ]p                      | 和p的功能差不多，但是它会自动调整被粘贴的文本的缩进去适应当前代码的位置         |
| <c-x><c-o>               | 自动补全，ycm占用Ctrl+n/p, 支持 PHP                                             |
| 光标定位                | <c-o/i>上下选择前一次后一次光标位.                                              |
|                         |                                                                                 |
| :s/^/#                  | 用"#"注释当前行 ,":s/<search>/<replace>"                                        |
| :%s/x/b                 | 在所有行替换x为b,":%s/<search>/<replace>"                                       |
| :2,50s/x/b              | 在2~50行替换x为b                                                                |
| :.,+3s/x/b              | 在前行和当前行后面的三行，替换x为b                                              |
|                         |                                                                                 |
| ,n/,p                   | 切换buffer的标签(因为vim的一个窗口里面有多个buffer)                             |
| Ctrl+Tab/Ctrl+Shift+Tab | 切换vim标签                                                                     |
| Ctrl+w,v/h              | 创建多窗口                                                                      |
| Ctrl+h/j/k/l            | 切换多窗口                                                                      |
| Ctrl+x,Ctrl+n/p         | 文件或者关键字补全，日常情况这个就够用了                                        |
|                         |                                                                                 |
| ,rb                     | 一键去除所有尾部空白 trailing                                                   |
| ,rt                     | 一键替换全部Tab为空格                                                           |
| ,r<enter>               | 一键替换所有尾部 ^M, `:set notextmode` 也可以实现                               |
| :Sw                     | 当需要root权限保存时，不用重新打开                                              |
| F3                      | 粘贴内容缩进错误，切换为 nopaste 模式 `:set pastetoggle`                        |
| :set fenc=utf8          | 设置文件编码                                                                    |
| :set display=uhex       | 查看^@这种不可显示的字符，自动转换这些字符为hex进制。也可以ga查看当前光标的进制 |
| ,16                     | 转换当前文件为16进制,`,r16`为恢复，只有十六进制部分修改才有用                   |
| :vert command           | 垂直打开command中的命令,示例 :vert h manpageview                                |

编辑模式下

| Action | Description        |
| ---    | ---                |
| Ctrl+w | 删除光标前一个单词 |

### 加载插件常用命令
| Action              | Description                                                                                                                                                                                                                  |
| ---                 | ---                                                                                                                                                                                                                          |
| <c-p>               | 快速查找当前文件夹下所有子目录的文件,ctrl+j/k上下选择文件                                                                                                                                                                    |
| :ag                 | 查找当前目录下的所有文件的关键字                                                                                                                                                                                             |
| ,gd                 | 使用YCM的快速查找头文件定义,类似vs中的F12                                                                                                                                                                                    |
| ,ci                 | 注释当前行或选定行(自动识别文件类型后添加注释)                                                                                                                                                                               |
| ,cm                 | 块注释(可选中)                                                                                                                                                                                                               |
| key<Tab>            | UltiSnip And YCM 可以自动补全，UltiSnip对py，ycm对c好一些, <c-j/k>上下选择下一个瞄准位                                                                                                                                       |
| <c-n><c-j/k>        | 用<c-n>当前选中的行，用<c-j/k>来移动行的位置(vim-multipe-cursors)                                                                                                                                                            |
| <m-j/k>             | 用alt/command+j/k移动当前行的位置(功能同上)                                                                                                                                                                                  |
| <c-n>               | 不停的选中<c-n>,可以执行多光标编辑 , <c-p>回到前一个,<c-x>放弃当前这个光标到下一个 , 其中i,a,I,A可以在insert模式，c,s可以在normal模式，c是清除当前选中的文字 , 有个小bug,就是在多光标选中模式下，要先按i或者a这个键，再按I/A |
| ,mt                 | 生成每个语言的ctags文件，可以通过ctrl+]跳转和ctrl+t返回                                                                                                                                                                      |
| +/-                 | +可以扩大选择区域/-相反                                                                                                                                                                                                      |
| ,bb /,bn<type char> | 按等于号对其或者自定义符号对齐                                                                                                                                                                                               |
| :DiffSaved          | 比较在保存文件之后修改了什么那些内容                                                                                                                                                                                         |
| :Man glob           | 查看linux关于glob的man文档(only linux/mac)                                                                                                                                                                                   |
| :Man glob.php       | 查看从php.net中访问glob的相关语法和示例(only linux/mac)                                                                                                                                                                      |
| K                   | 判断文件类型，自动调用:Man function/command name，在Man中查光标所在处的词                                                                                                                                                    |


### 关于自动补全
本配置自动补全三个部分:
- YouCompleteMe , 综合自动补全， <tab>选定，c-j/k 上下选择
- UltraSnip , 类自动补全，可以让多处同名的动更新，对 python 支持较好,快捷键与 YCM 已经合并，不需要修改
- vim-snippets , 常见snippets 都有，根据文件类型和语法补全，同时可以在 `~/.vim/snippets` 中自行添加

### Vim学习
- [简明Vim练级攻略](http://coolshell.cn/articles/5426.html)
- [vim游戏](http://vim-adventures.com/)
- [VIMdoc.md](https://github.com/yantze/vimrc/blob/master/VIMdoc.md) 整理的一份基础和扩展文件，如果上面的功能没有找到，我一般会在这里找，比如`标记`

### 一些说明

Mac 下的 terminal 中，airline 是黑色的看不清，在下面的文件，把第四行 `let s:termbg = 232` 改成 `235`
```
vimrc/vimfiles/bundle/vim-airline/autoload/airline/themes/serene.vim
```

### Thanks

- 这份vim配置的所以完成，会如此热爱vim，是看到了[ruchee](https://github.com/ruchee/vimrc) 的配置，其完善的配置让我感觉 vim 生命的质量

- 一些曾经学习的配置和资料:
    - [vimfiles](https://github.com/coderhwz/vimfiles)
    - [dotfiles](https://github.com/luin/dotfiles)
    - [vimrc](https://github.com/rhyzx/vimrc)
    - [dotvim](https://github.com/lilydjwg/dotvim)
    - [Seven habits of effective text editing](http://www.moolenaar.net/habits.html) vim 主要作者写的
