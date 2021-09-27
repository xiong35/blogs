# vscode 上配置 C/C++环境(从入门到魔改)

> 关键词: C/C++, 指北

目录

- [入门配置](入门配置)
- [魔改配置](#魔改配置)
  - [将 exe 文件全都放到一个专门的文件夹下](#将exe文件全都放到一个专门的文件夹下)
  - [设置自动补全 include](#设置自动补全include啊什么的)
- [参考资料](#参考资料)

## 入门配置

参考[这篇文章](https://www.zhihu.com/question/30315894)就行了, 他讲的真的已经非常详细了

## 魔改配置

按基础配置配好之后已经可以快乐的打代码了  
但是!  
不够爽!  
来, 跟着我魔改他!

> 前提: 完成基础配置, 可以用 coderunner 运行代码了

### 将 exe 文件全都放到一个专门的文件夹下

现在的配置是将每个 exe 文件就放在源代码旁边, 一份文件变成两份, 看的难受! 改!

> 注: 此步骤需要安装 coderunner 插件, 可按 ctrl+shift+x, 搜索名字, 点安装就好了  
> 注: 此步骤还需要打开 vscode 工作区/文件夹. 右击包含你写代码的文件夹(即他的父亲文件夹), 选择用 vscode 打开就可以了(不一定非要是打开你代码的**父亲**文件夹, 还可以打开他的**爷爷**文件夹, **太爷爷**文件夹...).

---

- 如果你是按照上面的教程配好的环境, 直接打开`settings.json`
- 如果直接找找不到`settings.json`, 按`ctrl+shift+p`, 输入 settings, 点 open settings (json), 如下图

![settings](https://s1.ax1x.com/2020/05/14/YDR5b4.png)

1. 将 settings 里的`code-runner.executorMap`一项改成(如果没有这一项就直接添加)如下:

```json
"code-runner.executorMap": {
    "c": "cd $dirWithoutTrailingSlash && gcc $fileName -o \"$workspaceRoot\\out\\$fileNameWithoutExt.exe\" -Wall -g -O2 -static-libgcc -std=c11 -fexec-charset=GBK && \"$workspaceRoot\\out\\$fileNameWithoutExt.exe\"",
    "cpp": "cd $dirWithoutTrailingSlash && g++ $fileName -o \"$workspaceRoot\\out\\$fileNameWithoutExt.exe\" -Wall -g -O2 -static-libgcc -std=c++17 -fexec-charset=GBK && \"$workspaceRoot\\out\\$fileNameWithoutExt.exe\""
},
```

2. 在你工作文件夹下(就是右击打开的那个文件夹)新建 out 文件夹

运行代码! 不出意外的话程序正常运行, 而且 out 文件夹里多了一个同名的 exe 文件!  
<small>出意外的话...<del>你自己想办法去</del>底部有我的联系方式, 可以联系我</small>

3. **如果你按那篇引用的教程配置好了 debug, 进一步, 还可以把 debug 时产生的 exe 文件也放到 out 里**

修改 launch.json 中的`program`参数如下:

```json
"program": "${workspaceFolder}/out/${fileBasenameNoExtension}.exe", // 将要进行调试的程序的路径
```

修改 tasks.json 里的`args`参数如下

```json
"args": [
    "${file}",
    "-o",
    "${workspaceFolder}/out/${fileBasenameNoExtension}.exe", // 主要修改了这一行
    "-g",
    "-static-libgcc",
    "-fexec-charset=GBK"
],
```

4. 完事了! 现在所有的 exe 都被放在单独的文件里了!

### 设置自动补全 include 啊什么的

> 这一步的操作适用于你用 vscode 编写的**任何文件**

简介: snippet 在这里的意思是代码段, 按如下步骤配置好后, 只需要简单的唤醒键就可以召唤出大段代码, 再也不用写无数次 `int main(void)` 了!

1. 按`ctrl+shift+p`, 输入 snippet, 点击 configure user snippets, 如图

![open snippet1](https://s1.ax1x.com/2020/05/14/YDRhKU.png)

2. 选择 new global snippet file, 如下图

![open snippet2](https://s1.ax1x.com/2020/05/14/YDR4rF.png)

3. 里面的注释随便看看就好了, 现在删掉里面的全部内容, 添加以下代码:

```json
{
  "basic c/cpp": {
    "scope": "c, cpp",
    "prefix": "#inc, #include",
    "body": [
      "#include <stdio.h>",
      "#include <stdlib.h>",
      "",
      "int main(void)",
      "{",
      "    ",
      "    return 0;",
      "}"
    ],
    "description": "basic c/c++ snippet"
  }
}
```

prefix 可以指定用什么前缀唤醒这段代码, 这里我指定了两个前缀

现在你可以新建一个 .c 文件, 输入 `#inc`, 他就会弹出来一个自动补全的提示框, 按 tab 键就可以选中了!

此外, 如果你想更装, 还可以在 body 里加入下面这段:

```json

            "/**",
            "* Author:",
            "*     Xiong35",
            "* Release Time:",
            "*     $CURRENT_YEAR/$CURRENT_MONTH/$CURRENT_DATE $CURRENT_HOUR:$CURRENT_MINUTE",
            "* Description:",
            "*     This is a program to $1",
            "* Github:",
            "*     https://github.com/xiong35",
            "*/",
```

dollar 符号开头的那些都是代表 vscode snippet 里的变量, 更多用法可参考[官方文档](https://code.visualstudio.com/docs/editor/userdefinedsnippets)

### 参考资料

- coderunnner 插件的介绍(里面有所有支持变量的含义)
- [知乎上的教程](https://www.zhihu.com/question/30315894)
- [vscode 配置文件里的变量总览](https://code.visualstudio.com/docs/editor/variables-reference)
- [vscode snippet 里的变量总览](https://code.visualstudio.com/docs/editor/userdefinedsnippets)
