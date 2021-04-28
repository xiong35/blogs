
# 《你不知道的js(中卷)》-类型

## null

```js
var a = null;

typeof a === "object"; // true

(!a && typeof a === "object"); // true. 真正能判断 null 的方法
```

## function

```js
typeof function a(){ /* .. */ } === "function"; // true

function a(b,c) {
 /* .. */
}

a.length; // 2, 函数对象的 length 属性是其声明的参数的个数
```

## typeof Undeclared

`typeof <Undeclared>` 并不会报错。这是因为 `typeof` 有一个特殊的安全防范机制

```js
// 这样会抛出错误
if (DEBUG) {
 console.log( "Debugging is starting" );
}

// 这样是安全的
if (typeof DEBUG !== "undefined") {
 console.log( "Debugging is starting" );
}

// 当然也可以这样, 但是只能在浏览器运行
if (window.DEBUG) {
 // ..
}
```

## array

delete 运算符可以将单元从数组中删除，但是请注意，单元删除后，数
组的 length 属性并不会发生变化

## string

JavaScript 中字符串是不可变的，而数组是可变的。并且 a[1] 在 JavaScript 中并非总是合法语法，在老版本的 IE 中就不被允许（现在可以了）。正确的方法应该是 `a.charAt(1)`

许多数组函数用来处理字符串很方便。虽然字符串没有这些函数，但可以通过“借用”数组的非变更方法来处理字符串

```js
a.join; // undefined
a.map; // undefined

var c = Array.prototype.join.call( a, "-" );
var d = Array.prototype.map.call( a, function(v){
    return v.toUpperCase() + ".";
} ).join("");

c; // "f-o-o"
d; // "F.O.O."

// 反转字符串
var c = a
 // 将a的值转换为字符数组
 .split( "" )
 // 将数组中的字符进行倒转
 .reverse()
 // 将数组中的字符拼接回字符串
 .join( "" );
c; // "oof"
// 注意对 unicode 等并不适用
```

## number

特别大和特别小的数字默认用指数格式显示，与 `toExponential()` 函数的输出结果相同。例如：

```js
var a = 5E10;
a; // 50000000000
a.toExponential(); // "5e+10"

var b = a * a;
b; // 2.5e+21

var c = 1 / a;
c; // 2e-11
```

由于数字值可以使用 Number 对象进行封装（参见第 3 章），因此数字值可以调用 `Number.prototype` 中的方法

```js
// 保留小数
var a = 42.59;
a.toFixed( 0 ); // "43"
a.toFixed( 1 ); // "42.6"
a.toFixed( 2 ); // "42.59"
a.toFixed( 3 ); // "42.590"

var a = 42.59;
// 保留有效数字
a.toPrecision( 1 ); // "4e+1"
a.toPrecision( 2 ); // "43"
a.toPrecision( 3 ); // "42.6"
a.toPrecision( 4 ); // "42.59"
a.toPrecision( 5 ); // "42.590"
```

## void

void 并不改变表达式的结果，只是让表达式不返回值

```js
var a = 42;
console.log( void a, a ); // undefined 42

// 实际中的用处
function doSomething() {
    // 注： APP.ready 由程序自己定义
    if (!APP.ready) {
    // 稍后再试
    return void setTimeout( doSomething, 100 );
    }
    var result;
    // 其他
    return result;
}
// 现在可以了吗？
if (doSomething()) {
    // 立即执行下一个任务
}
```

## NaN

```js
typeof NaN === "number"; // true

NaN == NaN // false
NaN != NaN // true, 可以用这个性质判断是不是nan

isNaN(NaN) // true
isNaN("foo") // true(Mozilla) / false(Chrome), 取决于实现(显然存在bug)

Number.isNaN(NaN) // true
```

## 值和引用

简单值总是通过值复制的方式来赋值 / 传递，包括 null、undefined、字符串、数字、布尔和 ES6 中的 symbol  
复合值总是通过引用复制的方式来赋值 / 传递, 包括对象（包括数组和封装对象）和函数

## [[class]]属性

所有 typeof 返回值为 "object" 的对象（如数组）都包含一个内部属性 [[Class]]（我们可以把它看作一个内部的分类，而非传统的面向对象意义上的类）。这个属性无法直接访问，一般通过 `Object.prototype.toString(..)` 来查看

```js
Object.prototype.toString.call( [1,2,3] );
// "[object Array]"
Object.prototype.toString.call( /regex-literal/i );
// "[object RegExp]"

Object.prototype.toString.call( null );
// "[object Null]"
Object.prototype.toString.call( undefined );
// "[object Undefined]"
```

## prototype

`Function.prototype` 是一个空函数，`RegExp.prototype` 是一个“空”的正则表达式（无任何匹配），而 `Array.prototype` 是一个空数组
