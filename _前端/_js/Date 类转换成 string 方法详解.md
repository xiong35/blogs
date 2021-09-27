# Date 类转换成 string 方法详解

> 关键词: JavaScript

## Date 类内置方法

| 方法                                   | 描述                               | 效果                                                 |
| -------------------------------------- | ---------------------------------- | ---------------------------------------------------- |
| `toString`                             | 返回时区表示, 具体实现和时区有关   | `"Wed Apr 28 2021 10:56:43 GMT+0800 (中国标准时间)"` |
| `toDateString`                         | 以**美式**英语习惯返回**日期部分** | `"Wed Apr 28 2021"`                                  |
| `toTimeString`                         | 以**美式**英语习惯返回**时间部分** | `"11:08:06 GMT+0800 (中国标准时间)"`                 |
| `toGMTString`(正在被废除, 用 UTC 替代) | 返回 GMT 时间表示                  | `"Wed, 28 Apr 2021 02:49:28 GMT"`                    |
| `toUTCString`                          | 返回 UTC 时间表示                  | `"Wed, 28 Apr 2021 03:06:52 GMT"`                    |
| `toISOString`                          | ISO 格式, 时区总是 UTC             | `"2021-04-28T02:55:19.303Z"`                         |

附:

- [UTC 和 GMT 的联系与区别](https://www.zhihu.com/question/27052407)
- [UTC vs ISO format for time](https://stackoverflow.com/questions/58847869/utc-vs-iso-format-for-time)

## Date 内置的三个特殊方法

> ie 可能不支持

```ts
interface Date {
  toLocaleString(
    locales?: string | string[],
    options?: Intl.DateTimeFormatOptions
  ): string;

  toLocaleDateString(
    locales?: string | string[],
    options?: Intl.DateTimeFormatOptions
  ): string;

  toLocaleTimeString(
    locales?: string | string[],
    options?: Intl.DateTimeFormatOptions
  ): string;
}

interface DateTimeFormatOptions {
  localeMatcher?: "best fit" | "lookup";
  weekday?: "long" | "short" | "narrow";
  era?: "long" | "short" | "narrow";
  year?: "numeric" | "2-digit";
  month?: "numeric" | "2-digit" | "long" | "short" | "narrow";
  day?: "numeric" | "2-digit";
  hour?: "numeric" | "2-digit";
  minute?: "numeric" | "2-digit";
  second?: "numeric" | "2-digit";
  timeZoneName?: "long" | "short";
  formatMatcher?: "best fit" | "basic";
  hour12?: boolean;
  timeZone?: string;
}
```

示例

```js
var date = new Date(Date.UTC(2012, 11, 20, 3, 0, 0));

//请求参数(options)中包含参数星期(weekday)，并且该参数的值为长类型(long)
var options = {
  weekday: "long",
  year: "numeric",
  month: "long",
  day: "numeric",
};
alert(date.toLocaleString("de-DE", options));
// → "Donnerstag, 20. Dezember 2012"

//一个应用使用 世界标准时间(UTC),并且UTC使用短名字(short)展示
options.timeZone = "UTC";
options.timeZoneName = "short"; //若不写这一行那么仍然显示的是世界标准时间；但是GMT三个字母不会显示
alert(date.toLocaleString("en-US", options));
// → "Thursday, December 20, 2012, GMT"

// 使用24小时制
alert(date.toLocaleString("en-US", { hour12: false }));
// → "12/19/2012, 19:00:00"
```

## 终极方法: 正则

```js
function dateFormat(fmt, date) {
  let ret;
  const opt = {
    "Y+": date.getFullYear().toString(), // 年
    "m+": (date.getMonth() + 1).toString(), // 月
    "d+": date.getDate().toString(), // 日
    "H+": date.getHours().toString(), // 时
    "M+": date.getMinutes().toString(), // 分
    "S+": date.getSeconds().toString(), // 秒
    // 有其他格式化字符需求可以继续添加，必须转化成字符串
  };
  for (let k in opt) {
    ret = new RegExp("(" + k + ")").exec(fmt);
    if (ret) {
      fmt = fmt.replace(
        ret[1],
        ret[1].length == 1 ? opt[k] : opt[k].padStart(ret[1].length, "0")
      );
    }
  }
  return fmt;
}

dateFormat("MM分SS秒 foobar YY年", new Date());
// "38分49秒 foobar 2021年"
```
