# 详解 js replace 函数

> 关键词: JavaScript

```js
// 测试用字符串
var str = "Lorem ipsum dolor sit amet consectetur";

str.replace("t", "@");
// -> "Lorem ipsum dolor si@ amet consectetur"
// 只替换第一个匹配项

str.replace(/t/, "@");
// -> "Lorem ipsum dolor si@ amet consectetur"
// 可以使用正则

str.replace(/t/g, "@");
// -> "Lorem ipsum dolor si@ ame@ consec@e@ur"
// 替换所有加上 `g` 参数

str.replace(/or(.)/g, " #$1# ");
// -> "L #e# m ipsum dol # # sit amet consectetur"
// 更复杂的正则

str.replace(/or(.)/g, (...args) => {
  console.log(args);
  return "&";
});
/*
打印
["ore", "e", 1, "Lorem ipsum dolor sit amet consectetur"]
["or ", " ", 15, "Lorem ipsum dolor sit amet consectetur"]

返回
"L&m ipsum dol&sit amet consectetur"

解释
若第二个参数为函数
  其参数为以下几项:
    正则匹配结果, ...分组匹配结果, 正则匹配结果的起始下标, 原字符串
  其返回值为:
    将完整匹配替换的结果
*/
```

其中:

| 字符                                        | 替换文本                                            |
| ------------------------------------------- | --------------------------------------------------- |
| `$1、$2、...、$99`                          | 与 regexp 中的第 1 到第 99 个子表达式相匹配的文本。 |
| `$&`                                        | 与 regexp 相匹配的子串。                            |
| <code>\$`</code> | 位于匹配子串左侧的文本。 |
| `$'`                                        | 位于匹配子串右侧的文本。                            |
| `$$`                                        | 直接量符号。                                        |
