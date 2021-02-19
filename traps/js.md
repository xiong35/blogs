# 在用js替换字符串内容时, replace函数只能替换匹配的第一个字符串

将匹配项改写成正则表达式:

```js
"foobar".replace("o", "O");
// "fOobar"

"foobar".replace(/o/g, "O"); // g表示global, 会匹配多项
// "fOObar"
```

# 实现返回顶部效果时, 自己写js又麻烦又容易错

js 原生窗口滚动:

```js
window.scrollTo({
top: 0,
behavior: "smooth"
});
```

# 使用箭头函数时得不到返回值

箭头函数只有在简写的时候可以省略返回值, 带了大括号就得显式的返回

```js
(a, b)=> a + b // ok

(a, b)=> { return a + b} // ok

(a, b)=> { a + b } // undefined
```

# 优雅地在浏览器中调试

```js
function potentiallyBuggyCode() {
    debugger;
    // do potentially buggy stuff to examine, step through, etc.
}
```

代码会在运行到`debugger`时自动暂停!!!

详见[MDN debugger](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Statements/debugger)

# js 类中函数 this 指向问题

```js
class Foo {
    bar() {
        console.log(this);
    }

    baz = () => {
        console.log(this);
    }
}

var foo = new Foo()

foo.bar()
foo.baz()

let foobar = foo.bar
let foobaz = foo.baz

foobar()
foobaz()
```

结果为

```js
Foo { baz: [Function: baz] }
Foo { baz: [Function: baz] }
undefined
Foo { baz: [Function: baz] }
```

实际上类里面的普通函数 this 使用的是`隐式绑定`(具体可参考我的[这篇文章](http://www.xiong35.cn/blog2.0/articles/blog/79)), 而使用箭头函数相当于做了这样一件事:

```js
class Foo {

    constructor () {
        this.baz = this.baz.bind(this)
    }

    baz () { // 注意这里不是箭头函数
        console.log(this);
    }
}
```

这样才能快乐的使用 this

# map parseInt

```js
[1,2,3].map(parseInt);
//-> [1, NaN, NaN]
```

`parseInt`接受两个参数, 第二个参数如果为 0, 就会默认parse十进制

而`map`函数传递两个参数: `val, ind`, 当 `ind`(即`parseInt`的第二个参数不为 0)时, 返回`NaN`

# 浏览器提示框

```js
alert("...");       // 返回 undefined

confirm("...");     // 返回 true/false

prompt("...");      // 返回用户输入, 取消则返回 null
```

# js ...args探究

```js

let fn1 = (args1, ...args2) => {
    console.log(args1);
    console.log(args2);
}

// error, Rest parameter must be last formal parameter
let fn2 = (...args1, ...args2) => {/* ... */}   


fn1(1, 2, 3)
// 1
// [2, 3]

fn1(1)
// 1
// []

fn1()
// undefined
// []
```

# 后端使用form接受数据带来的问题

在某项目中后端使用了`contentType = "application/x-www-form-urlencoded"`而非`"application/json"`来获取数据, 带来了以下问题:

1. 前端用 js 发送数据(而非用 html 的表单)时需要对数据进行预处理
2. 难以发送复杂度格式的数据, 如多级 对象/列表 嵌套

解决:

1. 引入 **qs** 模块, 生成 form 格式请求

```js
import qs from "qs";    // 下载并引入这个序列化模块

export async function POST(
  url,
  data,
  contentType = "application/json"
) {
  if (contentType == "application/x-www-form-urlencoded") {
    data = qs.stringify(data);  // 进行序列化
  }

  let res = await request({
    url,
    data,
    method: "POST",
    headers: {
      "Content-Type": contentType,
    },
  });
}
```

2. 目前没找到很好的的解决方案, 暂时的解决方案是把需要用到复杂数据的接口临时改为 json 格式

# js 上传图片等文件

```js
async function upload(url, data) {
  let res = await request({
    url,
    data,
    method: "POST",
    headers: {
      "Content-Type": "multipart/form-data;",
    },
  });
}

function selectFile() {
  return new Promise((res, rej) => {
    const el = document.createElement("input");
    el.type = "file";
    el.accept = this.accept;
    el.multiple = false;
    el.addEventListener("change", (_) => {
      res(el.files[0]);
    });
    el.click();
  });
}

async function uploadFile() {
  let file = await this.selectFile();

  if (!file || !~this.accept.indexOf(file.type)) {
    return;
  }

  let formData = new FormData(); //创建form对象
  formData.append("file", file); //通过append向form对象添加数据

  let res = await upload("/img", formData);
}
```

# img 的 onload 回调

html 中 img 在 src 的资源完全加载后会触发 onload 回调, 可以利用这个特性在 img 加载时展示 placeholder, 在加载好后隐藏 placeholder
