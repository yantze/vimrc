# 项目安装指南

### Linux & Mac 安装
```
# vimrc
git clone https://github.com/yantze/vimrc ~/.vim

# install plugin to ~/.vim/plugged
vim +PlugInstall

# [optional] install tern - javascript jslint
cd ~/.vim/plugged/tern_for_vim/
npm install 
# .tern-config https://atom.io/packages/atom-ternjs

# [optional] install YouCompleteMe
cd ~/.vim/plugged/YouCompleteMe
./install.py --clang-completer --gocode-completer --tern-completer # 需要先装 clang ，gocode，tern

# [optional] install vimpager
# https://github.com/rkitover/vimpager
cd ~/.vim/plugged/vimpager
make install
# 添加 pager 环境变量
export PAGER=/usr/local/bin/vimpager
alias less=$PAGER
alias zless=$PAGER
```
### Windows 安装
先安装好 gvim 和 git
```
# 用**管理员模式**的批处理命令行进入到你的 vim 安装目录
cd "C:\Program Files\Vim\"
# 删除原 vimfiles，这里面都是空的, 删除 _vimrc，这里面都是示范文件
git clone https://github.com/yantze/vimrc vimfiles
# 设置软链到上级目录
mklink _vimrc vimfiles\vimrc
# 安装插件包到 vimfiles\plugged
gvim +PlugInstall
# 安装完成
```
<hr>

除非有什么问题，下面的配置可忽略。


### Airline 背景色问题
Mac 下的 terminal 中，airline 是黑色的看不清，在下面的文件，把第四行 `let s:termbg = 232` 改成 `235`
```
vimrc/vimfiles/bundle/vim-airline/autoload/airline/themes/serene.vim
```

### 安装 ctags
1. windows 从 https://github.com/yantze/vimrc/tree/master/misc
1. 获取 ctags.exe , misc/ctags58_src.zip 是程序的源代码和可执行文件打包。
1. 或者访问 http://ctags.sourceforge.net 下载最新的 ctags，将 ctags.exe 复制到 \Vim\vim74 目录

ctags config
```
ctags -R # 相对路径
ctags -R /server/ # 绝对路径，可以在任何目录下查看
# 在 ~/.vimrc 中添加
set tags+=/server/php-src/tags # 或在 vim command 中运行
# 完成后可以在源代码中跳转申明
```

### YCM
[warning]如果出现下面的错误或者如果你在vps上编译YCM,说明你的内存不够用
```
g++: internal compiler error: Killed (program cc1plus)
Please submit a full bug report,
```
使用交换分区来解决
```bash
sudo dd if=/dev/zero of=/swapfile bs=64M count=16
sudo mkswap /swapfile
sudo chmod 644 /swapfile
sudo swapon /swapfile
```
当完成编译后,可以选择取消交换分区
```bash
sudo swapoff /swapfile
sudo rm /swapfile
```

### vba文件安装方法(这个项目暂时不需要)
1. 如果有扩展名为vba的vim插件,需要用vimball方式安装
1. 用vim打开vba格式的文件，输入 `:so %`,
1. 即可安装，然后`:q`退出,
1. 删除插件也很方便，直接在vim里输入 `:RmVimball 插件名`
1. 比如我其中一个插件manviewpage.vba就是用这个方法(我已经默认安装)


### 提取php函数名
```bash
find ./php.5.3 -type f -name "*.h" -o -name "*.c" | xargs grep -E "PHP_FUNCTION|ZEND_FUNCTION" | sed -ie "s/.*_FUNCTION(//g;s/)//g" | sort | uniq > functions.txt
```
