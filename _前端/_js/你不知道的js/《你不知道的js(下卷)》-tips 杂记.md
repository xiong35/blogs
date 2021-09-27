# 《你不知道的 js(下卷)》-tips 杂记

> 关键词: 读书笔记, JavaScript

本篇内容几乎全是使用 es6 的语法

## 解构

重复赋值

```js
var {
  a: { x: X, x: Y },
  a,
} = { a: { x: 1 } };
X; // 1
Y; // 1
a; // { x: 1 }
```

组合

```js
var a = [2, 3, 4];
var [b, ...c] = a;
console.log(b, c); // 2 [3,4]
```

默认值赋值

```js
var a = {
  x: 4,
  y: 5,
  z: 6,
};

var { x = 5, y = 10, z = 15, w = 20 } = a;
console.log(x, y, z, w); // 4 5 6 20
```

嵌套解构

```js
var a1 = [1, [2, 3, 4], 5];
var o1 = { x: { y: { z: 6 } } };

var [a, [b, c, d], e] = a1;
var {
  x: {
    y: { z: w },
  },
} = o1;

console.log(a, b, c, d, e); // 1 2 3 4 5
console.log(w); // 6
```

## set

```js
var s = new Set();

var x = { id: 1 },
  y = { id: 2 };

s.add(x);
s.add(y);
s.add(x);
s.size; // 2

s.delete(y);
s.size; // 1

s.has(x); // true
s.has(y); // false

s.clear();
s.size; // 0
```

```js
var s = new Set([1, 2, 3, 4, "1", 2, 4, "5"]),
  uniques = [...s];
uniques; // [1,2,3,4,"1","5"] // 不进行类型转化
```

## some / find / findIndex

```js
var points = [
  { x: 10, y: 20 },
  { x: 20, y: 30 },
  { x: 30, y: 40 },
  { x: 40, y: 50 },
  { x: 50, y: 60 },
];

points.some(function matcher(point) {
  return point.x % 3 == 0 && point.y % 4 == 0;
}); // true

points.find(function matcher(point) {
  return point.x % 3 == 0 && point.y % 4 == 0;
}); // { x: 30, y: 40 } // 未找到就是 undefined

points.findIndex(function matcher(point) {
  return point.x % 3 == 0 && point.y % 4 == 0;
}); // 2 // 未找到就是 -1
```

他们都可以接受一个可选的第二个参数，如果设定这个参数就绑定到第一个参数回调的 this。否则，this 就是 undefined。

## entries / values / keys

`entries()`、`values()` 和 `keys()` 都是迭代器方法

```js
var a = [];
a.length = 3;
a[1] = 2;

[...a.values()]; // [undefined,2,undefined]
[...a.keys()]; // [0,1,2]
[...a.entries()]; // [ [0,undefined], [1,2], [2,undefined] ]
```

## Math / Number

- `Math.trunc(..)`: 返回数字的整数部分
- `Number.EPSILON`: 任意两个值之间的最小差
- `Number.isInteger(..)`: 略

## String

```js
"foo".repeat(3); // "foofoofoo"

var palindrome = "step on no pets";

palindrome.startsWith("step on"); // true
palindrome.startsWith("on", 5); // true

palindrome.endsWith("no pets"); // true
palindrome.endsWith("no", 10); // true

palindrome.includes("on"); // true
palindrome.includes("on", 6); // false
```

## 完结撒花(/≧▽≦)/
