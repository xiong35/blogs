
# win10上汇编语言的 hello world

> 原文链接：https://blog.csdn.net/yuzuruhanyu/article/details/80287419
> 原文有几个小 bug, 本篇文章参考并改进了原文

> 注: dos系统和汇编语言都是不区分大小写的, 不要纠结大小写的问题! 

## 配置环境

### 下载dosbox安装程序

链接：https://pan.baidu.com/s/1gXPKTT-xKb6BpjOJdhmudA 密码：khqs

一路next安装上就好了

### 下载masm文件

链接：https://pan.baidu.com/s/177arSA34plWqV-iyffWpEw 密码：3akd

里面只有4个exe文件, 一会要用到

### 配置工作区

- 找一个**路径里不包含中文**的文件夹(没有的话就在c盘根目录下建一个呗), 以 c:\User\xiong35\assembly 为例  
- 在此文件夹里面**创建 bin 和 src 文件夹**  
- 将几个 masm 文件放到 bin 文件夹下

### 配置 dosbox 的启动程序

**双击**(而不编辑) dosbox 安装目录下的形如 ```Dosbox 0.74 Options.bat``` 的文件, 在末尾添加这几句话:

```bash
# 挂载驱动器, 将dos的d盘挂到你的那个文件夹下
mount d C:\User\xiong35\assembly

# 添加路径
path=\bin

# 转到d盘
d:

# 进入src文件夹
cd \src
```

这样每次启动dos都会自动挂载并设置好环境, 接下来你在自己电脑上写的代码只用放到那个 \src 目录下就可以运行了

## 编写 hello world 程序

> 当然你可以直接用记事本编辑, 然后改后缀名为 .asm 就可以了, 但是 vscode 他不香吗?

在 VScode 里下载 masm-code 插件, 仅此一个就够了

新建文件 hello.asm, 编辑内容如下:

```asm
assume cs:hello, ds:data, ss:stack
 
data segment
    str db 'Hello World!', 10, 13, '$'
data ends

stack segment stack
    db 32 dup(?)
stack ends
 
hello segment
start:
    mov ax, data
    mov ds, ax
    lea dx, str
    mov ah, 9
    int 21h
 
    mov ah,4ch
    int 21h
hello ends
end start
```

保存退出

## 在 dos 上编译运行

将 hello.asm 放到你工作文件夹下的 src 文件夹下, 打开 dos  

输入```masm hello.asm;```, 编译出 hello.obj 文件  
输入```link hello.obj;```, 链接得到 hello.exe 文件

> 注意此时的exe不能在你的windows上运行, 因为他是16位的程序, 而你的windows是64位或32位的!

在dos里输入```hello.exe```, 即可看到你的 hello world 了!