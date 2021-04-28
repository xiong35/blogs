# 使用go引入外部包时, 直接引用报错: cannot find module providing package github.com/gin-gonic/gin: working directory is not part of a module

解决:

```bash
go mod init gin

go mod edit -require github.com/gin-gonic/gin@latest
```

会生成一个 go.mod 文件, 类似与 package.json, 解决依赖问题