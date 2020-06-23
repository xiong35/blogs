
# 《你不知道的js》小 tips 记录

## with 语法

```js
var obj = { a: 1, b: 2, c: 3 };
// 单调乏味的重复"obj" 
obj.a = 2; 
obj.b = 3; 
obj.c = 4; 

// 简单的快捷方式 
with (obj) { 
    a = 3;
    b = 4;
    c = 5;
}

// 只能对已有属性进行赋值, 若未找到, 就会在全局找
```

## 立即执行函数 & 绝对安全的 undefined

```js
undefined = true; // 给其他代码挖了一个大坑！绝对不要这样做！
(function IIFE( undefined ) { 
    var a; 
    if (a === undefined) { 
        console.log( "Undefined is safe here!" ); 
    } 
})();       // 这里没传参, 形参 undefined 真的成为了 undefined!
```

## 有关 let

1. 较好的做法是在使用 let 时显式指出块级作用域:

```js
if (foo) {
    {   // <-这个块就是显式指定的
        let bar = "bar"
        console.log(bar)
    }`
}
```

2. let 声明的变量不会进行**提升**

3. 显式指定块级作用域可以强制销毁不必要的数据:

```js
function process(data) { // 在这里做点有趣的事情 };
var someReallyBigData = { .. };
process( someReallyBigData );

var btn = document.getElementById( "my_button" );
btn.addEventListener( "click", function click(evt) {
    console.log("button clicked");
}
```

虽然 bigData 已经被用完了, 但是 click 函数形成了一个全局的闭包, js 引擎有可能没有销毁这个数据  
改用限制作用域的方法可以强制销毁:

```js
function process(data) { // 在这里做点有趣的事情 };

{
    let someReallyBigData = { .. };
    process( someReallyBigData );
}

var btn = document.getElementById( "my_button" );
btn.addEventListener( "click", function click(evt) {
    console.log("button clicked");
}
```
4. let, 闭包与 for 循环

这段代码不会正常的打印, 而是会以每秒一次的频率输出五次6

```js
for (var i=1; i<=5; i++) {
    setTimeout( function timer() {
        console.log( i );
    }, i*1000 );
}
```

以下代码却都可以正常工作, 最后一种展现了 let 的神奇之处, 它可以在循环过程中不止被声明一次, 每次迭代都会声明. 随后的每个迭代都会使 用上一个迭代结束时的值来初始化这个变量(这意味着你也可以在循环中修改 i 的值来达到不同的效果)

```js
for (var i=1; i<=5; i++) {
    (function() {
        var j = i;
        setTimeout( function timer() {
            console.log( j );
        }, j*1000 );
    })();
}

for (var i=1; i<=5; i++) {
    (function(j) {
        setTimeout( function timer() {
            console.log( j );
        }, j*1000 );
    })( i );
}

for (var i=1; i<=5; i++) {
    let j = i;
    setTimeout( function timer() {
        console.log( j );
    }, j*1000 );
}

for (let i=1; i<=5; i++) {
    setTimeout( function timer() {
        console.log( i );
    }, i*1000 );
}
```

5. ES5 里的 let 可以被转化成这样(因为 catch 语句会创建一个块级作用域):

```js
{ 
    try {
        throw undefined; 
    } catch (a) {
         a = 2;
         console.log( a );
    } 
}

console.log( a );  // undefined
```

## this is "this"!

详见这篇文章: [《你不知道的js》读书笔记-this详解](http://www.xiong35.cn/blog2.0/articles/blog/79)


## 对象详解

详见:

- [《你不知道的js》-对象详解-属性与值](http://www.xiong35.cn/blog2.0/articles/blog/80)
- [《你不知道的js》对象详解-原型](http://www.xiong35.cn/blog2.0/articles/blog/81)