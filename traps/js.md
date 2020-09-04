# 在用js替换字符串内容时, replace函数只能替换匹配的第一个字符串

将匹配项改写成正则表达式:

```js
"foobar".replace("o", "O");
// "fOobar"

"foobar".replace(/o/g, "O"); // g表示global, 会匹配多项
// "fOObar"
```

# 实现返回顶部效果时, 自己写js又麻烦又容易错

js 原生窗口滚动:

```js
window.scrollTo({
top: 0,
behavior: "smooth"
});
```

# 使用箭头函数时得不到返回值

箭头函数只有在简写的时候可以省略返回值, 带了大括号就得显式的返回

```js
(a, b)=> a + b // ok

(a, b)=> { return a + b} // ok

(a, b)=> { a + b } // undefined
```

# 优雅地在浏览器中调试

```js
function potentiallyBuggyCode() {
    debugger;
    // do potentially buggy stuff to examine, step through, etc.
}
```

代码会在运行到`debugger`时自动暂停!!!

详见[MDN debugger](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Statements/debugger)

# js 类中函数 this 指向问题

```js
class Foo {
    bar() {
        console.log(this);
    }

    baz = () => {
        console.log(this);
    }
}

var foo = new Foo()

foo.bar()
foo.baz()

let foobar = foo.bar
let foobaz = foo.baz

foobar()
foobaz()
```

结果为

```js
Foo { baz: [Function: baz] }
Foo { baz: [Function: baz] }
undefined
Foo { baz: [Function: baz] }
```

实际上类里面的普通函数 this 使用的是`隐式绑定`(具体可参考我的[这篇文章](http://www.xiong35.cn/blog2.0/articles/blog/79)), 而使用箭头函数相当于做了这样一件事:

```js
class Foo {

    constructor () {
        this.baz = this.baz.bind(this)
    }

    baz () { // 注意这里不是箭头函数
        console.log(this);
    }
}
```

这样才能快乐的使用 this

# map parseInt

```js
[1,2,3].map(parseInt);
//-> [1, NaN, NaN]
```

`parseInt`接受两个参数, 第二个参数如果为 0, 就会默认parse十进制

而`map`函数传递两个参数: `val, ind`, 当 `ind`(即`parseInt`的第二个参数不为 0)时, 返回`NaN`

