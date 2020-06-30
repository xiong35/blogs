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