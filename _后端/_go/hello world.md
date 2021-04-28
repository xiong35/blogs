
# golang 的 hello world

> 亲测1.14.4版本可用

## 下载

在 https://golang.org/dl/ 下载对应的安装包, 然后按他说的安装上

## 配置变量

添加安装目录到环境变量

在 home 目录下会有一个 go 文件夹, 在里面按以下方式创建文件夹

```
go
|
+-- bin
|
+-- pkg
|
+-- src
    |
    +-- github.com
    |
    +-- golang.org
```

切换到 github.com 文件夹, 执行```git clone https://github.com/golang/tools.git tools```, 会将相关配置下载到 tools 文件夹

将 tools 文件夹复制到 golang.org 文件夹里

命令行里输入以下指令:

```
go env -w GOPROXY=https://goproxy.cn,direct
go env -w GOPRIVATE=*.gitlab.com,*.gitee.com
go env -w GOSUMDB=off
```

用 vscode 打开 src 目录, 下载 go 插件, 在 src 下新建 main.go 文件, 输入以下代码:

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello world")
}
```

这时候 vscode 会提示你下载相应包, 点击全部下载, 过一会就会把十来个包下载好, 这样你就有了 lint, 代码提示, 自动导包等一系列功能了, 而且是全局的, 也就是说不用再在 src 目录下写代码了, 在哪都能写了

最后, 在你的 golang 工作文件夹里新建 .vscode 文件夹, 里面新建 launch.json 和 settings.json, 写入以下内容:

```json
// launch
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch",
            "type": "go",
            "request": "launch",
            "mode": "debug",
            "remotePath": "",
            "port": 2345,
            "host": "127.0.0.1",
            "program": "${workspaceFolder}/src/${fileBasenameNoExtension}.go",
            "env": {
                "GOPATH": "C:/Users/xiong35/go"
            },
            "args": [],
            "showLog": true,
            "trace": "log"
        }
    ]
}
```

```json
// settings
{
    "go.autocompleteUnimportedPackages": true,
    "go.gocodePackageLookupMode": "go",
    "go.gotoSymbol.includeImports": true,
    "go.useCodeSnippetsOnFunctionSuggest": true,
    "go.inferGopath": true,
    "go.gopath": "C:/Users/Administrator/go",
    "go.useCodeSnippetsOnFunctionSuggestWithoutType": true,
}
```

其中 gopath 换成自己刚才那个 home 目录下的 go 文件夹的目录就行了, 这样就有了智能代码提示和 debug 功能!