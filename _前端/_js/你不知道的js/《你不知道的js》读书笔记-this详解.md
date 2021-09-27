# 《你不知道的 js》读书笔记-this 详解

> 关键词: 读书笔记, JavaScript

`this`的绑定和函数**声明的位置**没有任何关系, 只取决于函数的**调用方式**  
当一个函数被调用时, 会创建一个活动记录 (有时候也称为执行上下文) . 这个记录会包含函数在 哪里被调用 (调用栈) 、函数的调用方法、传入的参数等信息. this 就是记录的其中一个属性, 会在 函数执行的过程中用到  
调用位置就是函数在代码中被调用的位置 (而不是声明的位置)

this 的指向遵循以下 4 条规则:

## 默认绑定

独立函数调用 中 this 指向**全局对象**

如果使用严格模式 (strict mode), 那么全局对象将无法使用默认绑定, 因此 this 会绑定 到 undefined

## 隐式绑定

考虑调用位置是否有上下文对象, 或者说是否被某个对象拥有或者包含

```js
function foo() {
  console.log(this.a);
}
var obj = { a: 2, foo: foo };

obj.foo(); // 2
```

无论是 直接在 obj 中定义还是先定义再添加为引用属性, 这个函数严格来说都不属于 obj 对象.  
然而, 调用位置会使用 obj 上下文来引用函数, 因此你可以说函数被调用时 obj 对象“拥有”或者“包 含”它

但是当`foo()`被调用时, 它的落脚点确实指向 obj 对象. 当函数引用有上下文对象时, 隐式绑定规则会把函数调用中的 this 绑定到这个上下文对象. 因为调用`foo()`时 this 被绑定到 obj, 因此`this.a`和`obj.a`是一样的

对象属性引用链中只有最后一层会影响调用位置:

```js
function foo() {
  console.log(this.a);
}

var obj2 = { a: 42, foo: foo };
var obj1 = { a: 2, obj2: obj2 };

obj1.obj2.foo(); // 42
```

### 隐式丢失

被隐式绑定的函数会丢失绑定对象, 也就是说它会应用默认绑定, 从而把 this 绑定到全局对象或者 undefined 上, 取决于是否是严格模式

```js
function foo() {
  console.log(this.a);
}

var obj = { a: 2, foo: foo };

var bar = obj.foo; // 函数别名！

var a = "oops, global"; // a是全局对象的属性

bar(); // "oops, global"
```

虽然`bar`是`obj.foo`的一个引用, 但是实际上, 它引用的是 foo 函数**本身**(就是说这个函数和原本的对象没有直接关系, 仅仅是**保存在原对象里**, 现在把他取出来了, 自然和原对象没有关系了), 因此此时的`bar()`其实是一个不带任何修饰的函数调用, 因此应用了默认绑定

> 回调函数等同理, 因为传参相当于就是赋值

此外, 在一些流行的 JavaScript 库中事件处理器常会把回调函数的 this 强制绑定到触发事件的 DOM 元素上. 总之如果不显式指定, this 的改变都是意想不到的

## 显示绑定

`fn.call(<你需要用到的 this>)`是一个不错的办法(apply 同理), 但是依然无法解决隐式丢失的问题

### 硬绑定

1. 直接强行绑定:

```js
function foo() {
  console.log(this.a);
}
var obj = { a: 2 };

var bar = function () {
  foo.call(obj);
};

bar(); // 2

setTimeout(bar, 100); // 2

// 硬绑定的bar不可能再修改它的this
bar.call(window); // 2
```

2. 创造一个工厂函数:

```js
function bind(fn, obj) {
  return function () {
    return fn.apply(obj, arguments);
  };
}
```

3. 利用内置的 bind 函数

`bind(..)`会返回一个硬编码的新函数, 它会把参数设置为 this 的上下文并调用原始函数

```js
function foo(something) {
  console.log(this.a, something);
  return this.a + something;
}
var obj = { a: 2 };

var bar = foo.bind(obj);

var b = bar(3); // 2 3
console.log(b); // 5
```

### api 调用的上下文

第三方库的许多函数, 以及 JavaScript 语言和宿主环境中许多新的内置函数, 都提供了一个可选的参数, 通常被称为“上下文”, 其作用和`bind(..)`一样, 确保你的回调函数使用指定的 this.

```js
function foo(el) {
  console.log(el, this.id);
}

var obj = { id: "awesome" };

// 调用foo(..)时把this绑定到obj
[1, 2, 3].forEach(foo, obj); // 1 awesome 2 awesome 3 awesome
```

![forEach api](https://s1.ax1x.com/2020/06/23/Nt4mZj.png)

## new 绑定

js 中实际上并不存在所谓的“构造函数”, 只有对于函数的“构造调用”, 让他**初始化**新创建的对象

使用 new 来调用函数, 或者说发生构造函数调用时, 会自动执行下面的操作:

1. 创建 (或者说构造) 一个全新的对象
2. 这个新对象会被执行[原型]连接.
3. **这个新对象会绑定到函数调用的 this**
4. 如果函数没有返回其他对象, 那么 new 表达式中的函数调用会自动返回这个新对象

```js
function foo(a) {
  this.a = a; // 这里的this就是指向了新建的对象
}

var bar = new foo(2);

console.log(bar.a); // 2
```

---

## 优先级比较

new > 显式 > 隐式 > 默认

## 绑定例外: 被忽略的 this

如果你把`null`或者`undefined`作为`this`的绑定对象传入 call、apply 或者 bind, 这些值在调用时会被忽略, 实际应用的是默认绑定规则

更安全的做法: 传入一个空对象而非 null

```js
function foo(a, b) {
  console.log("a:" + a + ", b:" + b);
}
// 我们的DMZ空对象
var ø = Object.create(null);

// 把数组展开成参数
foo.apply(ø, [2, 3]); // a:2, b:3

// 使用bind(..)进行柯里化
var bar = foo.bind(ø, 2);
bar(3); // a:2, b:3
```

使用变量名 ø 不仅让函数变得更加“安全”, 而且可以提高代码的可读性, 因为 ø 表示“我希望 this 是**空**”, 这比 null 的含义更清楚. 当然你可以用任何喜欢的名字来命名 DMZ (demilitarized zone, 非军事区) 对象

> `Object.create(null)`和{}很像, 但是并不会创建`Object.prototype`这个委托, 所以它 比{}“更空”

## 箭头函数

箭头函数不使用 this 的四种标准规则, 而是根据外层 (函数或者全局) 作用域来决定 this

```js
function foo() {
  // 返回一个箭头函数
  return (a) => {
    //this继承自foo()
    console.log(this.a);
  };
}

var obj1 = { a: 2 };
var obj2 = { a: 3 };

var bar = foo.call(obj1);
bar.call(obj2); // 2, 不是3！

var obj = { a: 999, foo: foo };
var fn = obj.foo();
fn(); // 999
```

`foo()`内部创建的箭头函数会捕获调用时`foo()`的 this. 由于`foo()`的`this`绑定到 obj1, bar (引用箭头函数) 的 this 也会绑定到 obj1, **箭头函数的绑定无法被修改**. (new 也不行！)

箭头函数可以像 bind(..)一样确保函数的 this 被绑定到指定对象  
箭头函数会**继承外层函数调用的 this 绑定**(无论 this 绑定到什么)

总结来说, 箭头函数**会且仅会**将 this 绑定到创建时距离自己最近的 this, 且今后**不随调用位置, bind 等而改变**
