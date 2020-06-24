
# 《你不知道的js(中卷)》-类型转化

## json

`JSON.stringify(..)` 在对象中遇到 undefined、function 和 symbol 时会自动将其忽略，在数组中则会返回 null（以保证单元位置不变）

如果对象中定义了 `toJSON()` 方法，JSON 字符串化时会首先调用该方法，然后用它的返回值来进行序列化. `toJSON()` 返回的应该是一个适当的值，可以是任何类型，然后再由 `JSON.stringify(..)` 对其进行字符串化

我们可以向 `JSON.stringify(..)` 传递一个可选参数 replacer，它可以是数组或者函数，用来指定对象序列化过程中哪些属性应该被处理
如果 replacer 是一个数组，那么它必须是一个**字符串数组**，其中包含序列化**要处理**的对象的属性名称，除此之外其他的属性则被忽略。
如果 replacer 是一个函数，它会**对对象本身调用一次，然后对对象中的每个属性各调用一次**，每次传递两个参数，键和值。如果要忽略某个键就返回 undefined，否则返回指定的值


```js
var a = { 
    b: 42,
    c: "42",
    d: [1,2,3] 
};

JSON.stringify( a, ["b","c"] ); // "{"b":42,"c":"42"}"

JSON.stringify( a, function(k,v){
    if (k !== "c") return v;
} );
// "{"b":42,"d":[1,2,3]}"
```

`JSON.stringify(..)` 并不是强制类型转换。在这里介绍是因为它涉及 `ToString` 强制类型转换

## toNumber

`Number` 将 true 转换为 1，false 转换为 0。undefined 转换为 NaN，null 转换为 0

`Number` 操作对象（包括数组）时, 会首先被转换为相应的基本类型值，如果返回的是非数字的基本类型值，则再遵循以上规则将其强制转换为数字.  
首先检查该值是否有 `valueOf()` 方法。如果有并且返回基本类型值，就使用该值进行强制类型转换。如果没有就使用 `toString()` 的返回值（如果存在）来进行强制类型转换  
如果 `valueOf()` 和 `toString()` 均不返回基本类型值，会产生 `TypeError` 错误

例如:

```js
var a = {
    valueOf: function(){
        return "42";
    }
};

var b = {
    toString: function(){
        return "42";
    }
};

var c = [4,2];
c.toString = function(){
    return this.join( "" ); // "42"
};

Number( a ); // 42
Number( b ); // 42
Number( c ); // 42
Number( "" ); // 0
Number( [] ); // 0
Number( [ "abc" ] ); // NaN
```

## falsy

- undefined
- null
- false
- +0、-0 和 NaN
- ""

此外全是真值

## 位运算的骚操作

```js
~42; // -(42+1) ==> -43

~(-1); // -(-1+1) ==> 0

~a.indexOf( "lo" ); // 找到了就是真值, 找不到就是0!
```

```js
Math.floor( -49.6 ); // -50

~~(-49.6); // -49
(-49.6) | 0; // -49
```

> 位运算只适用于32位整型

## parse...

```js
var b = "42.6 rem";

Number( b ); // NaN
parseInt( b ); // 42
parseFloat( b ); // 42.6

/* notice */
parseInt( 0.000008 ); // 0 ("0" 来自于 "0.000008")
parseInt( 0.0000008 ); // 8 ("8" 来自于 "8e-7")
parseInt( false, 16 ); // 250 ("fa" 来自于 "false")
parseInt( parseInt, 16 ); // 15 ("f" 来自于 "function")
parseInt( "0x10" ); // 16
parseInt( "103", 2 ); // 2
```

## 加法操作

如果加法操作中某个操作数是字符串或者能够通过以下步骤转换为字符串的话，+ 将进行拼接操作  
如果其中一个操作数是对象（包括数组），则首先对其调用 `ToPrimitive` 抽象操作(调用`valueOf`, 如果没有再调用`toString`), 以数字作为上下文

```js
({a: 42}) + "88"    // "[object Object]88"

[1, 2] + [3, 4]     // "1,23,4"
```

## 逻辑操作

严格说 && 和 || 返回的不一定是布尔型, 而是两个操作数中的一个:

```JS
var a = 42;
var b = "abc";
var c = null;

a || b; // 42 
a && b; // "abc"

c || b; // "abc" 
c && b; // null
```

|| 和 && 首先会对第一个操作数执行条件判断，如果其不是布尔值就
先进行 `ToBoolean` 强制类型转换，然后再执行条件判

- 对于 || 来说，如果条件判断结果为 `true` 就**返回第一个操作数的值**，如果为 `false` 就**返回第二个操作数的值**。
- && 则相反，如果条件判断结果为 `true` 就**返回第二个操作数的值**，如果为 `false` 就**返回第一个操作数的值**

> 可以将这两个操作符理解为问号表达式, 区别在于问号表达式里的式子可能会被执行两次

## == / ===

== 会进行类型转化, === 不会

对 == 来说:

- 如果双方是同一类型, 仅判断值是否相等
- 如果两者都是对象, 指向同一个值则相等
- 尽量把两者都转化成数字比较

```js
true == "42"
// 转化成
1 == "42"
// 转化成
1 == 42 // false
```

> 所以不要用 `xxx == true`, 改用`!!xxx`

特殊:

```js
[] == ![]   // true
NaN != NaN  // true
NaN != !NaN // true
0 == "\n"   // true
```

- 如果两边的值中有 `true` 或者 `false`，千万不要使用 ==。
- 如果两边的值中有 `[]、""` 或者 `0`，尽量不要使用 ==。

附图:

![eequal](https://s1.ax1x.com/2020/06/23/NUH70f.png)

![eeequal](https://s1.ax1x.com/2020/06/23/NUHH78.png)

## 大于小于

比较双方首先调用 `ToPrimitive`，如果结果出现**非字符串**，就根据 ToNumber 规则将双方强制类型**转换为数字**来进行比较

如果比较双方都是字符串，则按字母顺序来进行比较

`a <= b`等价于`!(a > b)`, 而非`a < b || a == b`, 大于等于同理

```js
var a = { b: 42 };
var b = { b: 43 };

a < b; // false
a == b; // false
a > b; // false

a <= b; // true
a >= b; // true
```