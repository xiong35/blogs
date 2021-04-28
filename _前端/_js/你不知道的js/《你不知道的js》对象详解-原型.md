
# 《你不知道的js》对象详解-原型

JavaScript中的对象有一个特殊的[[Prototype]]内置属性，其实就是对于其他对象的引用。几乎所有的对象在创建时[[Prototype]]属性都会被赋予一个非空的值

所有普通的[[Prototype]]链最终都会指向内置的`Object.prototype`

## 真正的 put

`myObject.foo = "bar";`

- 如果`myObject`对象中包含名为`foo`的普通数据访问属性，这条赋值语句只会修改已有的属性值
- 如果`foo`不是直接存在于`myObject`中，[[Prototype]]链就会被遍历，类似[[Get]]操作
  - 如果原型链上找不到`foo`，`foo`就会被直接添加到`myObject`上
  - 如果`foo`存在于原型链上层，赋值语句`myObject.foo = "bar"`的行为就会有些不同（而且可能很出人意料）:
    - 如果在[[Prototype]]链上层存在名为`foo`的普通数据访问属性并且没有被标记为只读，那就会直接**在myObject中添加**一个名为foo的新属性，它会**屏蔽上层属性**
    - 如果在[[Prototype]]链上层存在`foo`，但是它被标记为只读，那么无法修改已有属性或者在`myObject`上创建屏蔽属性。如果运行在严格模式下，代码会抛出一个错误。否则，这条赋值语句会被忽略。总之，**不会发生屏蔽**
    - 如果在[[Prototype]]链上层存在`foo`并且它是一个setter，那就一定会调用这个 setter。`foo`不会被添加到（或者说屏蔽于）`myObject`，也不会重新定义`foo`这个 setter

> 如果你希望在第二种和第三种情况下也屏蔽`foo`，那就不能使用=操作符来赋值，而是使用`Object.defineProperty(..)`来向`myObject`添加`foo`

- 如果属性名`foo`既出现在`myObject`中也出现在`myObject`的[[Prototype]]链上层, 就会发生**屏蔽**

看下面这段代码:

```js
var anotherObject = { a:2 };
var myObject = Object.create( anotherObject ); 

anotherObject.a; // 2 
myObject.a; // 2 

anotherObject.hasOwnProperty( "a" ); // true 
myObject.hasOwnProperty( "a" ); // false 

myObject.a++; // 隐式屏蔽！ 

anotherObject.a; // 2 
myObject.a; // 3 

myObject.hasOwnProperty( "a" ); // true
```

尽管`myObject.a++`看起来应该（通过委托）查找并增加`anotherObject.a`属性，但是别忘了++操作相当于`myObject.a = myObject.a + 1`。因此++操作首先会通过[[Prototype]]查找属性a并从`anotherObject.a`获取当前属性值2，然后给这个值加1，接着用[[Put]]将值3赋给`myObject`中新建的屏蔽属性a

## new

```js
function Foo() { 
  // ...
}

var a = new Foo(); 
Object.getPrototypeOf( a ) === Foo.prototype; // true
```

`Foo.prototype`是什么?

我们知道`new Foo()`会生成一个新对象（名字是a），这个新对象的内部链接[[Prototype]]关联的是`Foo.prototype`对象

回到上面的问题, `Foo.prototype`实际就是一个工具人, 他的作用就在于被new出来的对象关联!

再看这段代码:

```js
function Foo() { /* .. */ }
Foo.prototype = { /* .. */ }; // 创建一个新原型对象 

var a1 = new Foo();

a1.constructor === Foo; // false!
a1.constructor === Object; // true!
```

实际上, `a1`并没有`.constructor`属性，所以它会委托[[Prototype]]链上的`Foo.prototype`。但是这个对象也没有`.constructor`属性（不过默认的Foo.prototype对象有这个属性！），所以它会继续委托，这次会委托给委托链顶端的`Object.prototype`。这个对象有`.constructor`属性，指向内置的`Object(..)`函数

## 判断父子关系

- `a instanceof Foo`: 回答的问题是: 在a的整条[[Prototype]]链中是否有指向`Foo.prototype`的对象
- `Foo.prototype.isPrototypeOf( a )`: 同上, 但是不需要间接引用函数（Foo），它的`.prototype`属性会被**自动访问**。我们只需要两个对象就可以判断它们之间的关系, 如`b.isPrototypeOf( c );`
- `Object.getPrototypeOf( a ) === Foo.prototype;`: 同上, 可以直接获得一个对象的 prototype, 在多数浏览器上还可以简写为`a.__proto__`