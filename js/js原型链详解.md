
# js原型链详解

## 什么是原型链

当你调用一个数组的`forEach`方法的时候, 你是否好奇他为什么有这个方法?

打开控制台, `var a = [1, 2, 3];`, 输入`a`, 点开这个变量查看他的方法, 发现其实他本身并没有多少属性, 也没有`forEach`方法, 而所有方法都在一个叫`__proto__`的属性里. 既然`a`没有这些方法, 那为什么可以用`a.forEach`来直接调用呢?

![a.__proto__](https://s3.ax1x.com/2020/11/20/DMgzqI.png)

事实上 js 中存在一种叫**原型链**的机制, 即通过**原型**来逐层向上查找父级对象的方法, 如果找到就直接获取, 找不到就会得到`undefined`. 举个栗子:

```js
// 首先定义一个小构造函数
function Foo() {
  this.bar = "bar";
  this.baz = function () {
    console.log("baz");
  };
}

var foo = new Foo();
foo.bar;    // -> "bar"
foo.baz();  // "baz"

// 然后让一个新的类继承自他
function Son() {
  this.qwq = "qwq";
}

Son.prototype = new Foo();          // 关键: 通过原型(prototype)实现继承
Son.prototype.constructor = Son;    // 细节: 把构造函数改回来

var son = new Son();
son.qwq;    // -> "qwq"
son.baz();  // "baz"
```

等等? 刚在发生了什么?

首先, 当用`new`调用`Foo`的时候会发生以下操作(这是`new`的特性)

1. 创建一个空的对象
2. 设置这个对象的`constructor`为`Foo`(其实是`Foo.prototype.constructor`)
3. 改变`Foo`函数里的`this`指向, 使之指向这个空对象
4. 执行`Foo`的函数体(比如这里的给`this`添加属性)
5. 返回这个对象(这里就是赋值给了`foo`)

好的, 至此我们有了一个变量`foo`, 他在`Foo`函数里被添加了`constructor`指向`Foo`, 还被添加了`bar`和`baz`属性.

不过还没完, 刚才在创建`Foo`这个函数时还发生了一件事, js 自动把`Foo.prototype`设置成了一个和`foo`用同样流程创建出来的对象, 即相当于执行了`Foo.prototype = new Foo();`这句话一样, 这个`prototype`属性就是整个原型链的关键! 他由构造函数保管, 代表的就是`Foo`的所有实例对象的**原型**, 当某个实例想找某个方法的时候就会来`prototype`上查找!(具体在后面详细讲)

下一步, 我们创建了另一个构造函数叫`Son`, 这个函数只给`this`添加了一个属性, 同时保存了一个`prototype`, 这个`prototype`是指向一个`Son`的实例的

再下一步就是关键了, 我们把`Son.prototype`改成了一个`Foo`的实例对象! 这样的话`Son`实例还是会去`Son.prototype`上查找方法, 但是此时的`prototype`已经有了不一样的方法! 他们都能被`son`这个实例对象访问到(通过查找原型链)  
同时我们还要把原型对象的`constructor`改回来, 以避免一些实例对象判定的 bug

现在的结构是这样的:

![foo_son_prototype](https://s3.ax1x.com/2020/11/20/DM2pZt.png)

当调用`son.baz()`的时候, 先查找`son`, 发现他没有这个方法, 接着就顺着原型链往上查, 根据`__proto__`找到上一级原型, 即是找`Son.prototype`, 即`new Foo()`的这个对象, 而这个对象里有`baz`方法, 于是调用此方法, 打印`"baz"`

## 为什么要用原型链

这是 js 的一个设计<del>缺陷</del>feature, 毕竟只用了10天写出来的语言, 俺也不太懂, 可能要是整的像 java 的继承那样会比较复杂? 这种继承方法虽然绕了一点, 但是实现起来好像也不复杂.

另外, ES6 新出了 class 语法, 看上去像是实现了常规的继承, 但是实际上只是对原型继承的语法糖, 本质上是没变的

## 区分 `__proto__`, `prototype`, `constructor`

1. 实例对象都有`constructor`属性, 指向其构造函数
2. 构造函数都有`prototype`属性, 指向其原型
3. 实例对象都有`__proto__`属性, 指向其**构造函数的`prototype`**

![zhihu prototype](https://pic1.zhimg.com/80/e83bca5f1d1e6bf359d1f75727968c11_1440w.jpg?source=1940ef5c)

## 再多说两句复杂情况

刚才我们只讨论了**获取**值, 那**赋值**的情况要怎么处理呢?

参见[《你不知道的js》对象详解-原型](http://www.xiong35.cn/blog2.0/articles/blog/81)

## 参考资料

- [知乎: js中__proto__和prototype的区别和关系？](https://www.zhihu.com/question/34183746/answer/58155878)
- [《你不知道的js》对象详解-原型](http://www.xiong35.cn/blog2.0/articles/blog/81)
