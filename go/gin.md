
# gin 框架初探

首先, 如果在新的目录里使用gin需要运行以下代码:

```
go mod init gin

go mod edit -require github.com/gin-gonic/gin@latest
```

## gin hello world

```go
package main

import (
	"github.com/gin-gonic/gin"
)

func main() {

	router := gin.Default()
	router.GET("/ping", func(c *gin.Context) {
		c.String(200, "pong")
	})
	router.Run(":8080")
}
```

## bind

自动为结构体绑定 query **或** body 里的数据

```go
type userInfo struct {
	Username string `form:"username" json:"username"`
	Password string `form:"password" json:"password"`
}

func main() {
	r := gin.Default()
	r.POST("/user", func(c *gin.Context) {
		var user userInfo
		err := c.ShouldBind(&user)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"error": err.Error(),
			})
		}
		fmt.Printf("%#v\n", user)
		c.JSON(http.StatusOK, gin.H{
			"message": "ok",
			"user":    user,
		})
	})
}
```

## log

```golang
func main() {
	// 禁用控制台颜色
	// gin.DisableConsoleColor()

	// 创建记录日志的文件
	f, _ := os.Create("gin.log")

	gin.DefaultWriter = io.MultiWriter(f, os.Stdout)

	router := gin.Default()
	router.GET("/ping", func(c *gin.Context) {
		c.String(200, "pong")
	})

	router.Run(":8080")
}
```

## redirect

```go
func main() {

	router := gin.Default()
	// 真-重定向
	router.GET("/ping", func(c *gin.Context) {
		c.Redirect(http.StatusMovedPermanently, "/pong")
	})
	router.GET("/pong", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"pong": "pong"})
	})
	// 不会修改浏览器里的url
	router.GET("/a", func(c *gin.Context) {
		c.Request.URL.Path = "/b"
		router.HandleContext(c)
	})
	router.GET("/b", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"c": "c"})
	})

	router.Run(":8080")
}
```

## any / 404 

Any 可以处理任何请求方法  
NoRoute 会接住任何没被处理的请求

```go
router.Any("/any", func(c *gin.Context) {
    c.String(http.StatusOK, "<h2> all </h2>")
})
router.NoRoute(func(c *gin.Context) {
    c.String(http.StatusOK, "<h2> not found </h2>")
})
```

## group

```go
func main() {

	router := gin.Default()

	articleGroup := router.Group("/article")

	articleGroup.GET("/tags", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"tags": "[1,2,3]"})
	})
	articleGroup.GET("/blog", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"blog": "some blog"})
	})
	articleGroup.GET("/trap", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"trap": "some trap"})
	})

	router.Run(":8080")
}
```

## middleware

```go
func handler(c *gin.Context) {
	fmt.Println("handle")
	c.Set("key", gin.H{
		"i":  "can",
		"be": "any type",
	})
}

func md1(c *gin.Context) {
    start := time.Now()
    
	c.Next() // c.Abort()
    
    cost := time.Since(start)

	c.JSON(http.StatusOK, gin.H{
		"time": cost,
		"val":  c.MustGet("key"), // c.Get() return a bonus bool
	})
}

func main() {

	router := gin.Default()

	router.GET("/md", md1, handler)

	router.Run(":8080")
}
```

或者```router.Use(md1, md2)```, ```someGroup.Use(md1, md2)```

## static

```go
func main() {
    router := gin.Default()

	router.Static("/assets", "./assets")
	router.StaticFS("/more_static", http.Dir("my_file_system"))
	router.StaticFile("/favicon.ico", "./resources/favicon.ico")

    router.Run(":8080")
}
```

## 可变参数

```go
r.GET("/user/:name", func(c *gin.Context) {
    user := c.Params.ByName("name")
    fmt.Println(user)
    c.JSON(http.StatusOK, gin.H{"user": user, "value": value})
}
```