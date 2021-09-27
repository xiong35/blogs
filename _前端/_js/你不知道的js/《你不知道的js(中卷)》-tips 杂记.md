# 《你不知道的 js(中卷)》-tips 杂记

> 关键词: 读书笔记, JavaScript

## label

```js
foo: for (var i = 0; i < 4; i++) {
  for (var j = 0; j < 4; j++) {
    if (i * j >= 3) {
      console.log("stopping!", i, j);
      break foo; // 可以用标签语法直接跳出去!
    }
    console.log(i, j);
  }
}
```

> continue 同理

## 一个小坑

```js
[] + {}; // "[object Object]"
{
}
+[]; // 0
```

因为第二句中的`{}`被当成了一个代码块!

## switch

switch 中是用 === 进行比较的, 如果想强制转化, 可以用下面一种写法

```js
switch (a) {
  case 2:
    // 执行一些代码
    break;
  case 42:
    // 执行另外一些代码
    break;
  default:
  // 执行缺省代码
}

switch (true) {
  case a == 10: // if true === (a==10)
    console.log("10 or '10'");
    break;
  case a == 42:
    console.log("42 or '42'");
    break;
  default:
    a;
}
```

注意第二种方法必须是**严格的真值**才行

关于 default:

```js
var a = 10;
switch (a) {
  case 1:
  case 2:
  // 永远执行不到这里
  default:
    console.log("default"); //运行完后继续向下运行
  case 3:
    console.log("3");
    break; // 此处的break跳出去了!
  case 4:
    console.log("4");
}
// default
// 3
```

## html + id == 元素?

**在创建带有 id 属性的 DOM 元素时也会创建同名的全局变量**

`<div id="foo"></div>`

```js
if (typeof foo == "undefined") {
  foo = 42; // 永远也不会运行
}

console.log(foo); // HTML元素
```

## script

在**内联代码**(如果是引入的代码则没有这个问题)中不可以出现 `</script>` 字符串，一旦出现即被视为代码块结束

```html
<script>
    var code = "<script>alert( ‘Hello World’ )</script>";
</script>
```

上面这段代码会在字符串常量中的 "\</script\>" 处结束, 从而导致错误.
改为`"</sc" + "ript>";`

## 关于保留字

的一首...诗?

![保留字的诗](https://s1.ax1x.com/2020/06/24/NdQSXQ.png)

## 异步的 log

`console.*`的操作可能是异步的(因为 io 开销比较大)

调试时最好的选择是在 JavaScript 调试器中使用断点，而不要依赖控制台输出。次优的方案是把对象序列化到一个字符串中，以强制执行一次“快照”，比如通过 `JSON.stringify(..)`

## 生成器

```js
function* foo(x) {
  var y = x * (yield); //可以写成 x*(yield "foobar")
  return y;
}

var it = foo(6);

// 启动foo(..) , 但是到yield会停住
it.next();

var res = it.next(7);

res.value; // 42
```

首先，传入 6 作为参数 x。然后调用 `it.next()`，这会**启动** `*foo(..)`。 在 *foo(..) 内部，开始执行语句 `var y = x ..`，但随后就遇到了一个 yield 表达式。它就会在这一点上暂停 `*foo(..)`（在赋值语句中间！），并在本质上要求调用代码为 yield 表达式提供一个结果值。接下来，调用`it.next( 7 )`，这一句把值 7 传回作为被暂停的 yield 表达式的结果

`for .. of`

```js
var something = (function () {
  var nextVal;
  return {
    // for..of循环需要
    // this 指向 something
    // 因为他实现了next接口, 所以被看作一个迭代器
    [Symbol.iterator]: function () {
      return this;
    },
    // 标准迭代器接口方法
    next: function () {
      if (nextVal === undefined) {
        nextVal = 1;
      } else {
        nextVal = 3 * nextVal;
      }
      return { done: nextVal > 500, value: nextVal };
    },
  };
})();

for (var v of something) {
  console.log(v);
}
// 1 3 9 27 81 243
```

### 生成器委托

```js
function* foo() {
  console.log("*foo() starting");
  yield 3;
  yield 4;
  console.log("*foo() finished");
}

function* bar() {
  yield 1;
  yield 2;
  yield* foo(); // yield委托！
  yield 5;
}

var it = bar();
it.next().value; // 1
it.next().value; // 2
it.next().value; // *foo()启动
// 3
it.next().value; // 4
it.next().value; // *foo()完成
// 5
```

## web worker

#TODO

```html
<!DOCTYPE html>
<html>
  <body>
    <p>Count numbers: <output id="result"></output></p>
    <button onclick="startWorker()">Start Worker</button>
    <button onclick="stopWorker()">Stop Worker</button>
    <input type="text" value="" />
    <script>
      var w;
      function startWorker() {
        if (typeof Worker !== "undefined") {
          if (typeof w === "undefined") {
            w = new Worker("demo_workers.js");
          }
          w.onmessage = function (event) {
            document.getElementById("result").innerHTML = event.data;
          };
        } else {
          document.getElementById("result").innerHTML =
            "Sorry, your browser does not support Web Workers...";
        }
      }

      function stopWorker() {
        w.terminate();
      }
    </script>
  </body>
</html>
```

```js
// demo_workers
function timedCount() {
  for (var i = 0; i < 10000000000; i++) {
    if (i % 100000 === 0) {
      postMessage(i);
    }
  }
}
```

## 尾递归优化

一些浏览器自带尾递归优化!

```js
function factorial(n) {
  function fact(n, res) {
    if (n < 2) return res;
    return fact(n - 1, n * res);
  }
  return fact(n, 1);
}
factorial(99);
// 9.332621544394415e+155
```
