##VIM使用说明
拿到副本后，执行 vimrc/script/link-rc.sh 安装

###常用命令-强大且要记住的功能(适用于本vim配置)

####Key
```
Ctrp+P          快速查找当前文件夹下所有子目录的文件
:ag             查找当前目录下的所有文件的关键字
,gd             使用YCM的快速查找头文件定义,类似vs中的F12
,ci             注释当前行/可选中
,cm             块注释/可选中
key<Tab>        UltiSnip And YCM 可以自动补全，UltiSnip对py，ycm对c好一些
                <c-j/k>上下选择下一个瞄准位
<c-n><c-j/k>    用<c-n>当前选中的行，用<c-j/k>来移动行的位置(vim-multipe-cursors)
<m-j/k>         用alt/command+j/k移动当前行的位置(功能同上)
<c-n>           不停的选中<c-n>,可以执行多光标编辑
                <c-p>回到前一个,<c-x>放弃当前这个光标到下一个
                其中i,a,I,A可以在insert模式，c,s可以在normal模式，c是清除当前选中的文字
                有个小bug,就是在多光标选中模式下，要先按i或者a这个键，再按I/A
,mt             生成每个语言的ctags文件，可以通过ctrl+]跳转和ctrl+t返回
+/-             +可以扩大选择区域/-相反
,bb /,bn<type char> 按等于号对其或者自定义符号对齐
```


####Tips
```
c/c++/objc/objc++   可以使用YCM
路径补全            可以使用YCM
光标定位            <c-o/i>上下选择前一次后一次光标位.
各个语言的补全      看~/.vim/snippets
ctags               可以自行在c/php等头文件建立ctags文件
                    c比如/usr/local/include, php比如pear的包管理中
```

####Snip
一旦你输入下面的字符，按Tab键自动补全
```
#!
class
html5
```

####PHP补全
可以使用Ctrl+x,Ctrl+o来补全内容



###vim学习
如果是初学者，要学会这几个技巧
vim有很多的‘模式’，在normal模式下
jkhl: 这四个键分别代表：下上左右
按字母i，进入insert插入模式，然后就可以输入文字
按ESC键，退出insert进入normal模式
退出要先按英文冒号:然后输入q

这些是基本的规则，如果要熟练的话，需要做一些高级的练习：

[简明Vim练级攻略](http://coolshell.cn/articles/5426.html)

[vim游戏](http://vim-adventures.com/)



###一些常用快捷键说明
```
/xxx                    查找xxx字符串
,ci                     注释选定行(自动识别文件类型后添加注释)
,n/,p                   切换buffer的标签(因为vim的一个窗口里面有多个buffer)
10G                     数字10和大写的G，跳到第十行

:s/^/#                  用"#"注释当前行 ,":s/<search>/<replace>"
:%s/x/b                 在所有行替换x为b,":%s/<search>/<replace>"
:2,50s/x/b              在2~50行替换x为b
:.,+3s/x/b              在前行和当前行后面的三行，替换x为b
:set notextmode         这个可以去掉^M这个符号
:set pastetoggle        可以解决在linux命令行复制内容的时候，
                        内容被识别为vim操作和乱序缩进,在我的配置中快捷键为F3

f<char>                 查找当前行的字符
gb                      go browser，光标下如果是url链接，自动用默认浏览器打开链接，
                        如果是选中的字符串，就用浏览器搜索
gf                      如果光标下是一个文件链接，则可以用vim自动打开这个文件
gd                      找到光标下的标签定义
Ctrl+Tab/Ctrl+Shift+Tab 切换vim标签
Ctrl+w,v/h              在gvim下创建多窗口
Ctrl+h/j/k/l            在gvim下切换多窗口
]p                      和p的功能差不多，但是它会自动调整被粘贴的文本的缩进去适应当前代码的位置
K                       在Man里面查找光标当前所在处的词
Ctrl+X,Ctrl+O           自动补全,ycm占用Ctrl+n/p
```


###一些不常用但是实用的设置
```
:set display=uhex       这个是用来查看^@这种不可显示的字符，自动转换这些字符为hex进制，也可以ga查看当前光标的进制
,16                     转换当前文件为16进制，,r16为恢复，只有十六进制部分修改才有用
```


初入门的你，以后肯定会遇到这两个东西 <leader>和<buffer>
<leader>默认是一个按钮，指的是反斜杠'\'，不过我在配置中设置成了',',减少小指的负担。
<buffer>其实就是你当前下面的buffer而已。

当你了解到了基本的使用方法后，你可以读看看我在.vimrc中的文档，里面有很多详细的技巧，熟悉后能和sublime和notepad++匹敌
当然_vimrc.bundles这个文件里面是需要加载的插件，里面有介绍每个插件是拿来干嘛的，也可以了解一下
我之前学习vim的时候，收集到的一些资料，这次重新复习了里面的内容，整理了一下发布了出来，就把它当成中级vim的入门手册吧，[下载地址](https://github.com/yantze/vimrc/blob/master/VIMdoc.md)。



###Thanks

这份vim配置的所以完成，会如此热爱vim，是看到了ruchee的vimrc的配置
其完善的配置让我感觉vim是如此的简单
[ruchee](https://github.com/ruchee/vimrc)


我也参考了很多的vim配置:
[vimfiles](https://github.com/coderhwz/vimfiles)
[dotfiles](https://github.com/luin/dotfiles)
[vimrc](https://github.com/rhyzx/vimrc)
[dotvim](https://github.com/lilydjwg/dotvim)

同时有一些技巧：
[Seven habits of effective text editing](http://www.moolenaar.net/habits.html) vim主要作者写的



###一些说明
```
如果有vba的vim插件,需要用vimball方式安装
用vim打开vba格式的文件，输入
:so %
即可安装，然后:q退出。
删除插件也很方便，直接在vim里输入
:RmVimball 插件名

比如我其中一个插件manviewpage.vba就是用这个方法

manviewpage有很多用法，用在php中是从php.net中查找相关的内容

在vim窗口下，:Man glob就可以查看关于glob的相关语法和示例

这个插件在linux或者mac cli下运行

因为需要安装text browser软件links或者elinks、links2也可以

默认关闭编译YCM，如果需要开启，确保安装了python-dev和gcc4.4.1+后，请自行取消script/link-rc.sh中的注释
```



###提取php函数名
```bash
find ./php.5.3 -type f -name "*.h" -o -name "*.c" | xargs grep -E "PHP_FUNCTION|ZEND_FUNCTION" | sed -ie "s/.*_FUNCTION(//g;s/)//g" | sort | uniq > functions.txt
```
