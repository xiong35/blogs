
# 《你不知道的js-对象详解-属性与值

## typeof null => Object ?

不同的对象在底层都表示为二进制，在JavaScript中二进制前三位都为0的话会被 判断为object类型，null的二进制表示是全0，自然前三位也是0，所以执行typeof时会返 回“object”

## 字面量与装箱

```js
var strPrimitive = "I am a string";
typeof strPrimitive; // "string"
strPrimitive instanceof String; // false

var strObject = new String( "I am a string" );
typeof strObject; // "object"
strObject instanceof String; // true
```

然而调用方法时引擎会自动将字面量装箱

> null 和 undefined 没有对应的构造形式，它们只有文字形式。相反，Date只有构造，没有文字形式  
> 对于Object, Array, Function和RegExp（正则表达式）来说，无论使用文字形式还是构造形式，它们都是对象，不是字面量

## 对象属性的键访问

在对象中，属性名永远都是字符串。如果你使用string（字面量）以外的其他值作为属性名，那它首先会被转换为一个字符串。即使是数字也不例外，虽然在数组下标中使用的的确是数字，但是在对象属性名中数字会被转换成字符串，所以当心不要搞混对象和数组中数字的用法

```js
var myObject = { };

myObject[true] = "foo";
myObject[3] = "bar";
myObject[myObject] = "baz";

myObject["true"]; // "foo"
myObject["3"]; // "bar"
myObject["[object Object]"]; // "baz"
myObject[{ foo:"bar" }]; // "baz"
```

## 可计算属性名(es6)

```js
var prefix = "foo";

var myObject = {
    [prefix + "bar"]: "hello",
    [prefix + "baz"]: "world"
};

myObject["foobar"]; // hello 
myObject["foobaz"]; // world
```

## 方法?

每次访问对象的属性(包括所谓"方法")就是**属性访问**。如果属性访问返回的是一个函数，那它也并不是一个“方法”。属性访问返回的函数和其他函数没有任何区别（除了可能发生的隐式绑定this）

即使你在对象的文字形式中声明一个函数表达式，这个函数也不会“属于”这个对象——它们只是对于相同函数对象的多个引用

## 拷贝?

深拷贝的方法: `var newObj = JSON.parse( JSON.stringify( someObj ) );`

但是如果出现**循环引用**, 深拷贝就会出问题

浅拷贝: `var newObj = Object.assign( {}, myObject );`

`Object.assign(..)`方法的第一个参数是目标对象，之后还可以跟一个或多个源对象。它会遍历一个或多个源对象的所有**可枚举**的**自有键**并把它们复制（使用=操作符赋值）到目标对象，最后返回目标对象

> 由于`Object.assign(..)`就是使用=操作符来赋值，所以源对象属性的一些特性（比如writable）不会被复制到目标对象

## 属性描述符

```js
var myObject = { a:2 };

Object.getOwnPropertyDescriptor( myObject, "a" );
// { 
//      value: 2, 
//      writable: true,
//      enumerable: true,
//      configurable: true
// }
```

在创建普通属性时属性描述符会使用默认值，我们也可以使用`Object.defineProperty(..)`来添加一个新属性或者修改一个已有属性（如果它是configurable）并对特性进行设置:

```js
var myObject = {};

Object.defineProperty( myObject, "a", {
    value: 2,
    writable: true,
    configurable: true,
    enumerable: true 
});
myObject.a; // 2
```

- `writable`: 是否可修改
  - 若改为 false, 赋值将**静默失败**(严格模式则是报错)
- `configurable`: 是否可配置描述符
  - 修改后若使用`defineProperty`将报错(无论是否严格). 这意味着这个操作是单向的! 
  - 此外, 设为 false 后这个属性也不能删除了(普通模式静默失败, 严格模式报错)
  - 例外是, 即使不可配置, 也可以将 writable 由 true 改为 false(单向操作!)
- `enumerable`: 是否可枚举
  - 仅影响`for .. in`之类的这种操作, 直接访问还是没有问题的

## 创建一个真·常量

1. 禁止扩展:

```js
var myObject = { a:2 };
Object.preventExtensions( myObject );

myObject.b = 3;
myObject.b; // undefined
```

2. `Object.seal(<target>)`: 密封, 实际上会在一个现有对象上调用`Object.preventExtensions(..)`并把所有现有属性标记为`configurable:false`
3. `Object.freeze(<target>)`: 冻结, 实际上会在一个现有对象上调用`Object.seal(..)`并把所有“数据访问”属性标记为`writable:false`

> 然而不管怎么封印, 这个对象引用的其他对象是不受影响的, 除非你遍历所有属性进行深度冻结

## 对属性的访问 / 修改

### get

当属性成为**右值**时, 对象默认的内置[[Get]]操作首先在对象中查找是否有名称相同的属性，如果找到就会返回这个属性的值。然而，如果没有找到名称相同的属性，按照[[Get]]算法的定义会执行另外一种非常重要的行为 (其实就是遍历可能存在的[[Prototype]]链，也就是原型链) 。如果无论如何都没有找到名称相同的属性，那[[Get]]操作会返回 undefined

### put

当对象属性成为**左值**时, 除法 put. [[Put]]被触发时，实际的行为取决于许多因素，包括对象中是否已经存在这个属性（这是最重要的 因素）。 如果已经存在这个属性，[[Put]]算法大致会检查下面这些内容:

1. 属性是否是访问描述符（参见3.3.9节）？如果是并且存在setter就调用setter。 
2. 属性的数据描述符中writable是否是false？如果是，在非严格模式下静默失败，在严格模式下 抛出TypeError异常。
3. 如果都不是，将该值设置为属性的值。 

如果对象中不存在这个属性，[[Put]]操作会更加复杂。我们会在讨论[[Prototype]]时详细进行介绍

### getter / setter

当你给一个属性定义 getter, setter 或者两者都有时，这个属性会被定义为“访问描述符”（和“属性描述符”相对）。对于访问描述符来说，JavaScript会**忽略**它们的 value 和 writable 特性，取而代之的是关心 set 和 get（还有configurable和enumerable）特性

以以下代码为例:

```js
var myObject = { 
    //给a定义一个getter 
    get a() { return 2; }
};

Object.defineProperty( 
    myObject, // 目标对象 
    "b", // 属性名 
    {   // 描述符 
        // 给b设置一个getter 
        get: function(){ return this.a * 2 }, 
        // 让b不会出现在对象的属性列表中 
        enumerable: false 
    }
);

myObject.a; // 2 
myObject.b; // 4
```

不管是对象文字语法中的`get a() { .. }`，还是`defineProperty(..)`中的显式定义，二者都会在对象中创建一个**不包含值**的属性，对于这个属性的访问会自动调用一个隐藏函数，它的返回值会被当作属性访问的返回值


由于我们只定义了a的getter，所以对a的值进行设置时set操作会**忽略赋值操作**，不会抛出错误。而且即便有合法的setter，由于我们自定义的getter只会返回2，所以set操作是没有意义的

在**控制台打印** myObject **不会包含有 get 的属性**. 此外, 如果 enumerable 为 false, JSON 序列化及`for in`也会忽略他:

```js
var myObject = { 
    // 给 a 定义一个getter 
    get a() { return this._a_; },
    // 给 a 定义一个setter 
    set a(val) { this._a_ = val * 2; } 
};

myObject.a = 2;
myObject.a; // 4

console.log(myObject) // { _a_:4 }
JSON.stringify(myObject) // {"a":4, "_a_":4}
```

## 属性存在性

```js
var myObject = { a:2 };

("a" in myObject); // true 
("b" in myObject); // false 

myObject.hasOwnProperty( "a" ); // true 
myObject.hasOwnProperty( "b" ); // false
```

`in`操作符会检查属性是否在对象及其[[Prototype]]原型链中（参见第5章）。相比之下，`hasOwnProperty(..)`只会检查属性是否在 myObject 对象中，不会检查[[Prototype]]链

所有的普通对象都可以通过对于`Object.prototype`的委托来访问`hasOwnProperty(..)`， 但是有的对象可能没有连接到`Object.prototype`（通过`Object.create(null)`来创建）。在这种情况下，形如`myObejct.hasOwnProperty(..)`就会失败  
这时可以使用一种更加强硬的方法来进行判断：`Object.prototype.hasOwnProperty.call(myObject,"a")`，它借用基础的`hasOwnProperty(..)`方法并把它显式绑定到myObject上

**数组**  
`4 in [2, 4, 6]`的结果并不是你期待的True，因为[2, 4, 6]这个数组中包含的属性名是0、1、2，没有4

## 遍历

- `forEach(..)`会遍历数组中的所有值并忽略回调函数的返回值
- `every(..)`会一直运行直到回调函数返回falsy
- `some(..)`会一直运行直到回调函数返回truthy

`every(..)`和`some(..)`中特殊的返回值和普通for循环中的break语句类似，它们会提前终止遍历

`for ... of`获得**值**, `for ... in`获得**下标**