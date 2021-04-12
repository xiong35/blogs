
# ES6 Proxy

Proxy 即为"代理", 代理对象能对某个对象的**键**的读写做出拦截, 在拦截器中可以编写需要的逻辑

## 最基本的示例

```js
var a = {b: 42, c: "foo"};
var A = new Proxy(a, {});

A.b // => 42

A.b = "6 * 7";

A.b // => "6 * 7"
a.b // => "6 * 7"
```

`new Proxy()`的第一个参数是要使用 Proxy 包装的目标对象（可以是任何类型的对象，包括原生数组，函数，甚至另一个代理）

解释: `A`即为`a`的代理对象, `A`本身没有`b`这个键, 但是对`A.b`做出读写会被**代理**到`a`身上, 
从而获取和改变被代理者的数据

## 增加拦截器

`new Proxy()`的第二个参数实际是配置的代理规则, 是一个通常以函数作为属性的对象, 
各属性中的函数分别定义了在执行各种操作时代理 p 的行为。

```js
var a = {b: 42, c: "foo"};
var A = new Proxy(a, {
  get: (target, key) => {   // 接受的前2个参数分别是: 被代理的原始对象, 这次要获取的key
    console.log("get " + key);
    return target[key];
  },
  set: (target, key, value) => {    // 接受的前3个参数分别是: 被代理的原始对象, 这次要设置的key, 这次药设置的value
    console.log("set " + key + " to " + value);
    target[key] = value;
    return true;    // 表明此次操作是否成功(后面会讲到他的意义)
  }
});

A.b 
// get b
// => 42
A.b = "baz"
// set b to baz
// "baz"
```

包括上述`get`和`set`在内, 一共可以配置13种拦截器([ref](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Proxy))

若某个拦截器未被定义, 则会进行**无操作转发**(见*最基本的示例*)

和`defineProperty`最大的不同在于, Proxy对于原本对象上不存在的键也可以进行各种拦截

```js
// 接上
A.foo
// get foo
// => undefined
A.foo = "bar"
// set foo to bar
// => "bar"
a.foo // => "bar"
```

## Reflect

先看这么一个需求

```js
var raw = {
  get a() {
    return this.b
  },
}
```
对此对象进行代理

```js
var p = new Proxy(raw, {
  get(target, key) {
    if (key === "b") return "foo"
    return target[key]
  }
})

p.a // => undefined <- 此处是通过target[key], 即raw.a, 调用了get方法, 获得this.b, (此时 this 就是 raw), 得到的undefined
p.b // => "foo"     <- 此处是p中的拦截器拦截到 `key==="b"`, 从而返回了"foo"
```

我现在就想用`p.a`获得到`"foo"`, 即, 让`raw`对象调用`this`的时候让通过`this`访问到的属性也被代理一下, 目前的方案是做不到的

尝试:

```js
var p = new Proxy(raw, {
  get(target, key) {
    if (key === "b") return "foo"
    return p[key]
  }
})
```

然而这样会导致无限递归, `p[key]`会触发拦截, 拦截又会调用`p[key]`, 不妥

解决方案: [`Reflect`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Reflect)

```js
var p = new Proxy(raw, {
  get(target, key) {
    if (key === "b") return "foo"
    return Reflect.get(target, key, p)
  }
})

p.a // => "foo"
p.b // => "foo"
```

bingo!  
事实上, `Reflect` 的一个目的就是为了解决复杂的代理问题, 一个最佳实践就是, `Proxy`和`Reflect`搭配使用

细心的你可能会发现, `Reflect.get(target, key, p)`使这个代理配置和 `p` 耦合度太高, 通用性不强  
实际上, `get`和`set`拦截器还接受一个对象, 叫做`receiver`


```js
var config = {
  get(target, key, receiver) {
    console.log(receiver)
    return p[key]
  }
}

var p1 = new Proxy({}, config)
var p2 = new Proxy({}, config)

p1.a // p1
p2.a // p2
```

所以完整版的拦截器应该是这样的:

```js
var p = new Proxy(raw, {
  get(target, key, receiver) {
    // do something
    return Reflect.get(target, key, receiver)
  },
  set(target, key, value, receiver) {
    // do something
    return Reflect.set(target, key, value, receiver)
  }
})
```

对于 Proxy 的拦截，还是老老实实的把 receiver 传递给 Reflect 比较好。

## 填坑: set 的返回值有什么用

```js
'use strict'
var p = new Proxy({}, {
  set(target, key, value, receiver) {
    // 没有 return!
    // return Reflect.set(target, key, value, receiver)
  }
})

p.a = 42 // TypeError!
```

为啥要返回值?  
返回值代表本次set操作成功与否, 如果有一连串相关联的 set, 返回 *falsy* 会抛出异常  
什么叫相关联的 set?

```js
var raw = ["foo"]
var p = new Proxy(raw, {
  set(target, key, value, receiver) {
    Reflect.set(target, key, value, receiver)
    return false
    // return Reflect.set(target, key, value, receiver)
  }
})

p.push("bar") // TypeError!
```

因为push操作相当于设置 `p[1] = "bar" && p.length += 1`, 即进行了两个相关的操作

## 用法示例

### 观察者模式

```js
let raw = {
  a: 2
}

const handler = {
  set(target, key, value, receiver) {
    const result = Reflect.set(target, key, value, receiver);
    //执行观察者队列
    observableArray.forEach(item => item());
    return result;
  }
}

//初始化观察者队列
const observableArray = new Set();

const rawProxy = new Proxy(obj, handler);

//将监听函数加入队列
observableArray.add(() => {
  console.log(raw);
});

rawProxy.baz = "2"; // { a: 2, baz: "2" }
```

### 多继承

```js
const artist = {
  design() {
    console.log('designing');
  }
};

const programmer = {
  sleep() {
    console.log('sleeping');
  }
};

const handler = {
  get(target, name, receiver) {
    if (Reflect.has(target, name)) {
      return Reflect.get(target, name, receiver);
    }
    else {
      for (let parent of target[Symbol.for('PrototypeSymbol')]) {
        if (Reflect.has(parent, name)) {
          return Reflect.get(parent, name, receiver);
        }
      }
    }
  }
};

const man = new Proxy({
  name: 'tz'
}, handler);

man[Symbol.for('PrototypeSymbol')] = [artist, programmer];
man.sleep();    // sleeping
man.design();   // designing
```

可能性是无限的...

btw, vue3 的响应性就是用 Proxy 实现的 ;P
