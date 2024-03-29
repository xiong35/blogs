# 新手向入坑 cs 指北--gcc 编译

> 关键词: 指北

> 看这篇文章前, 请先确保你已经有一定的编程经验了, 至少得把我[上一篇文章](http://www.xiong35.cn/blog2.0/articles/blog/28)里讲到的 3 个推荐教程看了一个半个的吧

## 认识命令行

你可能会说, 为啥我写了这么久 c 语言都还在和黑框框打交道? c 语言就这? 就这?

这个黑框框可不是什么辣鸡玩意, 他叫<big>**命令行**</big>.

来, 快捷键 win+R(win 就是键盘上画了一个 windows 标志的按键), 弹出了一个叫"运行"的窗口对不对? 输入 `cmd`, 点确定! 是不是弹出来了黑框框? 这个框框就是 cmd(command, 命令行).

他有啥用呢? 在这里是可以用另一种方式操控电脑的!  
你看电影里那些黑客不就是在这种黑框框里飞快打代码的吗.  
怎么操作呢? 先试试输入`clac` , 按回车, 是不是打开了 calculator? 再试试`mspaint`, 有没有打开画图工具?  
你平时使用的应用都是**有界面的**, 双击快捷方式打开. 但是**有很多应用都是不需要界面**, 只需要文字的, 这种应用就可以直接用命令行执行. 你试试输入`netstat -n`, 可以看到你现在的网络连接状态, 这种**应用程序**和你的 qq, lol, hello_world.exe 什么的本质上没有区别, 都是**可执行程序**罢了.  
之所以不设计图形界面, 只是因为没必要罢了. 设计图形界面的应用动不动就几十 M, 几个 G, 但是命令行的应用都很迷你, 就是几 Kb, 几 M 的级别. 你现在嫌他小, 只是因为你的电脑大. 想想看你闹钟里, 你空调, 你路由器里执行的那些程序呢? 他们没有显卡, 没有硬盘, 在那上面只能执行这种小程序啊!

## 使用命令行!

好, 按你说的, 命令行确实有用, 那我要怎么用呢?

我们先来看看怎么用命令行编译 c 语言程序怎么样!

### 下载编译器

用命令行编译 c, 首先需要编译器的命令行程序, 他叫"ming64", 是一个 windows 系统上的命令行编译器. 遗憾的是 windows 并不自带这个编译器, 我们可以在[这里](https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/installer/mingw-w64-install.exe)下载

安装的时候, 全都选择默认选项, 但是**一定要记得记住你的安装目录**(就是你把他安装到哪个文件夹了)

### 设置环境变量

安装好以后还不能直接使用, 而是要**设置环境变量**  
环境变量是个啥呢?  
你输一个命令, 你说电脑去哪里找这个命令呢? 他不可能把整个 c 盘翻个遍吧! 你得告诉他去哪里可以找到这个命令, 而你告诉他的这个路径就是环境变量

我们先得自己知道这些命令在哪  
打开你刚刚安装 ming64 的路径, 里面应该有这些文件夹:

![ming64 folder](https://s1.ax1x.com/2020/05/20/YortyQ.png)

打开 bin 文件夹(binary, 存放二进制文件, 也就是可执行文件), 里面是不是有很多 exe 文件? 这些就是你会用到的命令, 现在我们知道了他们在哪了, 怎么让你的电脑也知道呢?

如下图, 复制 bin 文件夹的路径[**要进入 bin 文件夹哦**, 不是 ming64 文件夹的路径哦](双击框起来的那个条条, 复制整个路径. 你的路径肯定和图上的不一样, 没关系的)

![ming64 bin](https://s1.ax1x.com/2020/05/20/Yo6Pds.png)

按以下步骤设置环境变量(详如下图)

1. 右击**此电脑**, 点击**属性**
2. 点击**高级系统设置**
3. 点击**环境变量**
4. 点击**PATH**(注意是上面的 path, 不是系统变量里的哦)
5. 点击**新建**
6. 在这个文本框里粘贴你刚刚复制的 bin 文件夹的路径
7. 一路点保存

![path](https://s1.ax1x.com/2020/05/20/YocsE9.png)

好了! 接下来就是见证奇迹的时刻!

快捷键 win+R, 输入 cmd 指令, 进入命令行, 输入`gcc`!
是不是没啥反应, 好像还报错了? 欸, 没事, 这才对. 这说明安装好了, 只是打开的方式不对... 不信你输一个`gcccccc`试试? 他直接告诉你这个命令不存在了!

行吧, 那这个 gcc 到底怎么用呢???

按照以下步骤操作(详如下图)

1. 输入`cd Desktop`指令(因为你打开 cmd 的时候默认路径不在桌面上, 而是你的用户文件夹里, 这个也就是"C:\User\xiong35", 你需要 cd(change directory, 更换目录)到桌面上操作)
2. 在桌面上新建 txt 文件(不是 word 文件哦, 就是记事本那种文件), 编辑他的内容为一串 c 语言代码并保存, **把后缀名改成.c**
3. 输入`gcc <这里是你的文件名>`命令
4. 可以看到过一小会桌面出现了叫 a.exe 的文件! 双击执行它确实没问题!
5. 在 cmd 里直接输入 a.exe, 也可以执行!! 看, 我没说错吧, 大家都是可执行文件, 直接执行就完事了!

![gcc](https://s1.ax1x.com/2020/05/20/Yo2ySx.png)

为什么这里可以直接输 a.exe 呢? 不是说电脑不知道去哪里找命令吗? 对, 但是他除了在你告诉他的位置找之外, 还会默认的在当前文件夹里找, in this case, 就是桌面了!

a.exe 看的是不是不爽? 你凭什么就叫 a 啊? 谁允许你自己起名字了?  
来, 输入`gcc test.c -o hahahahaha.exe`试试!

---

这篇就到这儿了, [下一篇](http://xiong35.cn/blog2.0/articles/blog/30)会讲 c 语言进阶之路哦!
