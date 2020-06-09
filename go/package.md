
# go 自定义 package 的用法

## mod

首先执行```go mod init test```, 创建一个 mod 文件

## 目录结构

```
|   go.mod
|   main.go
|
\---a
    |   a.go
    |
    \---bb
            bb.go
```

## 各文件代码

```go
// main
package main

import (
    "test/a"
    "test/a/bb"
)

func main() {
    a.Add(1, 2)
    bb.Say()
}
```

```go
// a
package a

import "test/a/bb"

func Add(a int, b int) int {
    bb.Say()
    return a + b
}
```

```go
// bb
package bb

import "fmt"

func Say() {
    fmt.Printf("hello")
}
```