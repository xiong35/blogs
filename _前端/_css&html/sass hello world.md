
# sass hello world

在开始前, 你可以看看: [Sass 与 SCSS 是什么关系？](https://zhuanlan.zhihu.com/p/21319396)

## 配置环境

```bash
export SASS_BINARY_SITE=https://npm.taobao.org/mirrors/node-sass/

npm i node-sass -g --registry=http://registry.npm.taobao.org

node-sass -v    # 验证是否成功
```

这样就下载好了编译 scss 用的 node-sass 环境了

## 使用命令并简化使用

在**工作路径**下新建 scss 和 css 两个文件夹, 在 scss 目录下新建一个 .scss 文件, 然后写入以下内容:

```scss
body {
    font-size: 18px;
}
```

在**工作路径**下打开命令行, 输入`node-sass --output-style compressed sass/hello.scss > css/hello.css`, 即可看到css文件夹下出现被编译好的css文件!

> --output-style 可选值如下:  
> nested：(根据sass的嵌套)嵌套缩进的css代码，它是默认值  
> expanded：没有缩进的、扩展的css代码  
> compact：简洁格式的css代码  
> compressed：压缩后的css代码

还可以对修改开启监视, 自动编译  
在工作目录下输入以下指令: `node-sass -wro css scss --output-style nested`

> tips: 通过配置 code-runner 和 alias 可以让编译操作更丝滑

## 基本操作

### 变量

```scss
/* scss */
$primary: #287fd6;
$primary-border: 1px solid $primary;

div {
  background-color: $primary;
}

h1 {
  border: $primary-border;
}

/* 编译后
   css   */
div {
  background-color: #287fd6; }

h1 {
  border: 1px solid #287fd6; }
```

### 嵌套

```scss
/* scss */
.nav {
  height: 100px;
  ul {
    margin: 0;
    li {
      padding: 5px;
    }
  }
}

/* 编译后
   css   */
.nav {
  height: 100px; }
  .nav ul {
    margin: 0; }
    .nav ul li {
      padding: 5px; }
```

但是有这种情况:

```scss
/* scss */
a {
  margin: 0;
  :hover {
    color: blue;
  }
}

/* 编译后
   css   */
a {
  margin: 0; }
  a :hover {    // 不行!
    color: blue; }
```

我们可以使用父选择器(在使用伪类等时常用)

```scss
/* scss */
a {
  margin: 0;
  &:hover {     // 父选择器
    padding: 5px;
  }
  &pple {
    padding: 5px;
  }
}

/* 编译后
   css   */
a {
  margin: 0; }
  a:hover {     // ok!
    padding: 5px; }
  apple {
    padding: 5px; }
```

属性嵌套:

```scss
/* scss */
.nav {
  border: 1px solid #ccc {
    left: 0;
    right: 0;
  }

  font: {
    weight: bold;
    size: 14px;
  }
}

/* 编译后
   css   */
.nav {
  border: 1px solid #ccc;
    border-left: 0;
    border-right: 0;
  font-weight: bold;
  font-size: 14px; }
```

### mixin

> 相当于函数

```scss
/* scss */
@mixin theme($text-color: #222, $bgc: #ddd) {   // 设置默认值
  color: $text-color;
  background-color: $bgc;
  a {           // 内部嵌套选择
    color: darken($text-color, 10%);    // 内置函数
  }
}

.nav {
  @include theme($bgc: #eee);   // 如果是不带参数的, 可以不写括号
}

/* 编译后
   css   */
.nav {
  color: #222;
  background-color: #ddd; }
  .nav a {
    color: #090909; }
```

### extend

```scss
/* scss */
.nav {
  padding: 10px;
}

.nav a {
  font-weight: bold;
}

.nav-info {
  @extend .nav;
  background-color: #3499d3;
}

/* 编译后
   css   */
.nav, .nav-info {
  padding: 10px; }

.nav a, .nav-info a {
  font-weight: bold; }

.nav-info {
  background-color: #3499d3; }
```

### import

> css 直接 import 会发送多次 http 请求, sass 的 import 则是直接打包成一个文件

被 import 的文件被称为"partial", partial 的文件名必须以"_"开头:

```scss
/* _base.scss */
body {
  padding: 0;
  margin: 0; 
}

/* hello.scss */
@import "base";     // import 时既不用写后缀名, 又不用写下划线

.nav {
  padding: 10px;
}

/* 编译后
   css   */
body {
  padding: 0;
  margin: 0; }

.nav {
  padding: 10px; }
```

### comment

单行注释会在编译时被去掉

多行注释会在普通模式下保留, 压缩模式去除

强制注释(`/*! */`, 带一个`!`)无论如何都保留

### 数据类型

- "number": `5`, `5rem`等
  - `2 * 5px + 8` => `18px`
  - `(8 / 2)` => `4`(除法要用括号)
  - `(10px / 2px)` => `2`(不带单位)
- "string": `foo`, `"foo"`等
  - `foo + "bar"` => `foobar`
  - `"foo" + bar` => `"foobar"`
  - `"foo" + 8` => `"foo8"
- "color": `red`, `#000`, `rgb(0, 0, 0)`等
- "list": `1px solid #000`(以空格分割)
- "map": `(light: #eee, dark: #111)`
- "boolean": 可用`and`, `or`, `not`等连接

### 内置函数

number

- `abs(num)`, `min(num[])`, `max(num[])`
- `round(num)`, `ceil(num)`, `floor(num)`
- `percentage(num)`

string

- `to-upper-case(str)`, `to-lower-case(str)`
- `str-length(str)`
- `str-index(str, substr)`, 返回子串在父串中第一次出现的位置, 以**1**为起点!!!
- `str-insert(target, str, ind)`, 把str插入到target的ind位置

color

- `adjust-hue(color, deg)`, deg是单位为`deg`的数字
- `lighten/darken(color, percent)`
- `saturate/desaturate(color, percent)`, 增加/减少饱和度
- `opacify/transparency(color, alpha)`, 增加/减少alpha

list

- `length(list)`
- `nth(list, ind)`, 从 1 开始
- `index(list, item)`
- `append(list, item)`, 第三个参数指定列表分隔符, 取值为[space(默认), comma]
- `join(list, list)`, 同上

map

- `length(map)`
- `map-get(map, key)`
- `map-keys(map)`, `map-values(map)`
- `map-has-key(map)`
- `map-merge(map, map)`
- `map-remove(map, key, [key], ...)`, 返回新map, 而不改变原来的

### 插值表达式

语法: `#{$var}`

```scss
/* scss */
$version: "1.2.3";
/*! version: #{$version} */

$attr: "border";
$type: "info";

.nav-#{$type} {
  #{$attr}-color: blue;
}

/* 编译后
   css   */
/*! version: 1.2.3 */
.nav-info {
  border-color: blue; }
```

### 流程控制

```scss
/* if */
/* scss */
$theme: "dark";
.nav {
  @if $theme== "dark" {
    color: white;
  } @else if $theme== "light" {
    color: black;
  } @else {
    color: gray;
  }
}
/* css */
.nav {
  color: white; }

/* for */
/* scss */
$columns: 4;
@for $i from 1 to $columns {
  // from ... to: 不包含最后一项
  .col-#{$i} {
    // from ... through: 包含
    width: (100% / $columns) * $i;
  }
}
/* css */
.col-1 {
  width: 25%; }
.col-2 {
  width: 50%; }
.col-3 {
  width: 75%; }

/* each */
/* scss */
$items: success error warning;
@each $item in $items {
  .nav-#{$item} {
    background-image: url(../images/#{$item}.png);
  }
}
/* css */
.nav-success {
  background-image: url(../images/success.png); }
.nav-error {
  background-image: url(../images/error.png); }
.nav-warning {
  background-image: url(../images/warning.png); }

/* while */
/* scss */
$i: 1;
@while $i <= 3 {
  .item-#{$i} {
    width: 5rem * $i;
  }
  $i: $i + 1;
}
/* css */
.item-1 {
  width: 5rem; }
.item-2 {
  width: 10rem; }
.item-3 {
  width: 15rem; }
```

### function

```scss
/* scss */
$colors: (
  light: #eee,
  dark: #111,
);

@function color($key) {
  @if not map-has-key($map: $colors, $key: $key) {
    @warn "color is not found"; // 在命令行显示信息
    /* @error "color is not found"; // 在输出的css中加入错误提示的注释 */
  }

  @return map-get($colors, $key);
}

body {
  background-color: color(light);
}

/* css */
body {
  background-color: #eee; }
```