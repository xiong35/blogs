# 《你不知道的 js(中卷)》-异步

> 关键词: 读书笔记, JavaScript

## 代码块

由于 js 单线程的特点, 程序段中的**代码块具有原子性**

```js
var a = 20;

function foo() {
  a *= 2;
  console.log(a);
}
function bar() {
  a += 1;
  console.log(a);
}
// ajax(..)是某个库中提供的某个Ajax函数
ajax("http://some.url.1", foo);
ajax("http://some.url.2", bar);
```

由于 `foo()` 不会被 `bar()` 中断，`bar()` 也不会被 `foo()` 中断，所以这个程序只有两个可能的输出，取决于这两个函数哪个先运行

同一段代码有两个可能输出意味着还是存在不确定性！但是，这种不确定性是在**函数**（事件）顺序级别上，而不是多线程情况下的语句顺序级别（或者说，表达式运算顺序级别）。换句话说，这一确定性要高于多线程情况

## promise

### 如何保证 promise 会有结果

```js
// 用于超时一个Promise的工具
function timeoutPromise(delay) {
  return new Promise(function (resolve, reject) {
    setTimeout(function () {
      reject("Timeout!");
    }, delay);
  });
}
// 设置foo()超时
Promise.race([
  foo(), // 试着开始foo()
  timeoutPromise(3000), // 给它3秒钟
]).then(
  function () {
    // foo(..)及时完成！
  },
  function (err) {
    // 或者foo()被拒绝，或者只是没能按时完成
    // 查看err来了解是哪种情况
  }
);
```

### resolve 的参数问题

> 内部判断是否为 promise 的方法大致为: 是对象+有 then 函数

如果向 `Promise.resolve(..)` 传递一个非 Promise、非 thenable 的立即值，就会得到一个用这个值填充的 promise

而如果向 `Promise.resolve(..)` 传递一个真正的 Promise，就只会返回**同一个 promise**

如果向 `Promise.resolve(..)` 传递了一个非 Promise 的 thenable 值，前者就会试图展开这个值，而且展开过程会持续到提取出一个具体的非类 Promise 的最终值

```js
var p = {
  then: function (cb, errcb) {
    cb(42);
    errcb("evil laugh");
  },
};

p.then(
  function fulfilled(val) {
    console.log(val); // 42
  },
  function rejected(err) {
    // 啊，不应该运行！
    console.log(err); // 邪恶的笑
  }
);
```

但是`Promise.resolve(..)` 可以接受任何 thenable，将其解封为它的非 thenable 值。从 `Promise.resolve(..)` 得到的是一个真正的 Promise，是一个可以信任的值。如果你传入的已经是真正的 Promise，那么你得到的就是它本身，所以通过 `Promise.resolve(..)` **过滤**来获得可信任性完全没有坏处

```js
// 不要只是这么做：
foo(42).then(function (v) {
  console.log(v);
});

// 而要这么做：
Promise.resolve(foo(42)).then(function (v) {
  console.log(v);
});
```

## boss 战

以下代码的运行结果为?

```js
async function async1() {
  console.log("async1 start");
  await async2();
  console.log("async1 end");
}

async function async2() {
  console.log("async2");
}

console.log("script start");

setTimeout(function () {
  console.log("setTimeout");
}, 0);

async1();

new Promise(function (resolve) {
  console.log("promise1");
  resolve();
}).then(function () {
  console.log("promise2");
});

console.log("script end");
```

### 前置知识

#### 宏任务 / 微任务

- 宏任务
  - 整体代码
  - setTimeout, setInterval
- 微任务
  - Promise.then
  - process.nextTick

![event_loop](https://s1.ax1x.com/2020/06/26/NrpBY4.png)

#### async / await

带 async 标记的函数返回值:

- 如果为 Promise 对象: 直接返回
- 如果为立即值, 将他包装成 Promise 再返回
- 如果没有指定, 返回 `Promise.resolve(undefined)`

await 表达式等的是什么?

- Promise: 值为传递给这个 Promise 的 resolve 函数的参数
- 立即值: 将立即值包装为 Promise, 再立刻 resolve

await 会先执行其后面的表达式, 直到最后化简为一个 Promise, 然后将这个 Promise 的 then 操作加入微任务队列, 阻塞后面的操作. 等他被 resolve 了再继续运行后面的代码

### 题解

![js_problems_solution](https://s1.ax1x.com/2020/06/26/NrAS9U.png)

运行结果为:

![js_problems_result](https://s1.ax1x.com/2020/06/26/NrA8Et.png)
