# js 严格模式

> 关键词: JavaScript

## 启用严格模式

```js
"use strict"; // 全局启用
//code

function foo() {
  "use strict"; // 局部启用
  //code
}
```

**注意**, `'use strict'`前必须没有任何**语句**, 包括空语句, **不包括**注释

## 严格模式的限制

1. 不使用 var 声明变量严格模式中将不通过

   ```js
   "use strict";
   g = 100; //错误

   for (i = 0; i < 5; i++) {
     //错误
     console.log(i);
   }

   function foo() {
     "use strict"; // 局部启用
     g = 10; // 错误
   }
   ```

2. 任何使用`eval`这个**变量**的操作都会被禁止

   ```js
   "use strict";
   var obj = {};
   // 全部错误
   var eval = 3;
   for (var eval in obj) {
   }
   function eval() {}
   function func(eval) {}
   ```

3. 引入了`eval`作用域

   ```js
   "use strict";
   var a = 10;
   eval("var a = 20; console.log(a)"); //20
   console.log(a); //10
   ```

4. `with`被禁用

   ```js
   "use strict";
   var obj = {
     name: "zhangsan",
     sex: "男",
   };
   with (obj) {
     //报错
     console.log(name);
     console.log(sex);
   }
   ```

5. `caller/callee`被禁用
6. 对禁止扩展的对象添加新属性会报错

   ```js
   "use strict";
   var obj = {};
   Object.preventExtensions(obj);
   obj.a = 1; // 报错
   ```

7. 删除系统内置的属性(`prototype`等)会报错
8. `delete`使用 var 声明的变量或挂在 window 上的变量报错
9. `delete`不可删除属性(`isSealed`或`isFrozen`)的对象时报错
10. 对一个对象的只读属性进行赋值将报错
11. 函数有重名的**参数**将报错
12. 八进制表示法被禁用
13. 函数内对`arguments`的修改无效
14. 在条件判断 / 循环语句 里声明的函数无效
15. ES5 里新增的关键字(let, yield 等)不能当做变量名
16. `call/apply/bind`的第一个参数直接传入原本的值(非严格则是将字面量包装为对象)
17. `call/apply/bind`的第一个参数为`null/undefined`时，`this`为`null/undefined`(非严格模式则为全局对象)
