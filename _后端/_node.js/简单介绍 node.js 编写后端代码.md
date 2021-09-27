# [科普] node.js 编写后端代码

> 关键词: Node.js, 指北

## node.js 是什么

这就得从 js 的起源讲起...众所周知, js 是一门用来操作网页的语言. js 的设计目标就是让网页能动起来. 既然要操纵网页, 那就必须**有**网页, 所所以在很长一段时间里 js 都必须在浏览器中运行, 每个浏览器都配有 js 的解释器以执行 js 代码, 这也让 js 成为了世界上装机量最大的语言之一(小灵通都能上网, 不会有电子设备不能用浏览器吧 😅)

在**前端**这个概念崛起前, 没有*前端工程师*这种说法, 网页都是通过后端用一种不优雅的方式编写的(后续会展示), 而当**前端**概念崛起后, 涌现了一大批前端工程师. 但想制作一个网页, 必须既有前端又有后端, 为了~~压榨员工~~节省人力成本, 出现了对全栈工程师的需求.

但是, 前端使用的是 js 语言, 后端使用的是 go, java, python 等语言, 语言不通, 想成为全栈工程师的学习成本较高, 一定程度上阻止了全栈工程师的培养. 那么有没有办法让前后端统一语言, 至少减去学习语言的成本!

于是 [node.js](https://nodejs.org/zh-cn/) 应运而生, 这是一个装在电脑上的程序, 可以**在浏览器外解析 js**, 并**调用一些系统功能**和**操作数据库**, 有了它, 我们就可以用世界上最好的语言 ---- js, 来快乐的编写后端代码啦!

## 安装 node

见[菜鸟教程](https://www.runoob.com/nodejs/nodejs-install-setup.html)

## 编写后端代码

### 从服务器是什么讲起

**服务器就是一台电脑**, 只是不能打游戏, 不能看视频, 不能快乐 happy, 它的唯一目的就是**提供服务**, 如让大家可以访问到网页, 可以进行较强的计算能力来训练 ai 等

服务器(其实任何电脑都有)有两个重要的属性: ip 地址 和 端口号

通过 _ip 地址_ 可以唯一确定一台服务器, 通过 _端口号_ 可以唯一确定服务器上运行的一个服务.

> **IP 地址**（英语：IP Address，全称 Internet Protocol Address），又译为网际协议地址、互联网协议地址。当设备连接网络，设备将被分配一个 IP 地址，用作标识。通过 IP 地址，设备间可以互相通讯，如果没有 IP 地址，我们将无法知道哪个设备是发送方，无法知道哪个是接收方。IP 地址有两个主要功能：标识设备或网络 和 寻址（英语：location addressing）。  
> 常见的 IP 地址分为 IPv4 与 IPv6 两大类，IP 地址由一串数字组成。IPv4 由十进制数字组成，并以点分隔，如：`172.16.254.1`；IPv6 由十六进制数字组成，以冒号分割，如：`2001:db8:0:1234:0:567:8:1`。

> **端口**是指逻辑意义上用于区分服务的端口，比如用于浏览网页服务的 80 端口，用于 FTP 服务的 21 端口等。如 TCP/IP 协议中的服务端口，通过不同的逻辑端口来区分不同的服务。一个 IP 地址的端口通过 16bit 进行编号，最多可以有 65536 个端口 。端口是通过端口号来标记的，端口号只有整数，范围是从 0 到 65535。

举个比方, 你要找你的快递(_你所需要的具体服务_), 需要通过名字(_ip_)先找到他的快递站点, 菜鸟 or 中通 or 韵达(_找到对应的服务器_), 再根据取件码(_端口号_)找到你的快递(_具体的服务_)

端口号的主要作用是表示一台计算机中的特定进程所提供的服务。网络中的计算机是通过 IP 地址来代表其身份的，它只能表示某台特定的计算机，但是一台计算机上可以同时提供很多个服务，如数据库服务、FTP 服务、Web 服务等，我们就通过端口号来区别相同计算机所提供的这些不同的服务，如常见的端口号 21 表示的是 FTP 服务，端口号 23 表示的是 Telnet 服务端口号 25 指的是 SMTP 服务等。端口号一般习惯为 4 位整数，在同一台计算机上端口号不能重复，否则，就会产生端口号冲突这样的例外

ok, 说了这么多, 我们来实操一下

### 找 ip 地址

```shell
ping 8.8.8.8            # 对谷歌的总服务说 hi
ping www.baidu.com      # 对辣鸡百度说 hi, 等价于 `ping 182.61.200.6`
```

### 找端口号

1. `telenet`

```shell
telnet www.baidu.com 80     # 查看百度的 80 端口是否打开
telnet www.baidu.com 99     # 查看百度的 99 端口是否打开
telnet xiong35.cn 99        # 查看我服务器的 99 端口是否打开
```

2. 浏览器地址栏分别输入`https://www.baidu.com:80/`和`https://www.baidu.com:90/`, 前者找到了百度, 后者炸了

### 编写具体的服务

1. hello node

```js
const http = require("http");
const url = require("url");

var server = http.createServer(function (req, res) {
  console.log(new Date().toISOString(), "\t", req.method, "\t", req.url);

  let urlPath = url.parse(req.url).pathname;
  res.writeHead(200);
  res.end(`
hello, there
you are accessing http://xiong35.cn${urlPath}
`);
});

server.listen("7777");
console.log(`Server running at port: 7777`);
```

2. 返回 html!

```js
res.end(`
<h1>WOW</h1>
<p>IT'S HTML !!!</p>
`);
```

3.  返回一个完整的网页!!!!

```js
res.setHeader("Content-Type", "text/html;charset=utf-8");
res.end(`
<style>
  body {
    background-color: pink;
  }
  input {
    margin: 5vh auto;
    width: 300px;
    display: block;
  }
  button {
    display: inline-block;
    margin: auto;
    display: block;
  }
  p {
    margin: 20vh auto 5vh;
    text-align: center;
  }
</style>

<p>你好, 今天你的运势是${~~(Math.random() * 100)}</p>
<input type="text" id="ipt" placeholder="输入你想去到哪个网站" />
<button id="submit">提交</button>

<script>
  let inputContent = "";
  window.onload = function () {
    ipt.addEventListener("change", function (e) {
      inputContent = e.target.value;
    });

    submit.addEventListener("click", function (e) {
      window.location.href = inputContent;
    });
  };
</script>
`);
```

### 这么写太要命了, 有没有牛一点的写法!

有! 有一些人受不了这种写法, 对上述 http 模块做了封装, 能够以更简洁的方式调用其功能, 然后把他们的代码公开出来给大家下载, 其中最著名的就是 [koa](https://koajs.com/) 和 express

#### hello koa

```shell
mkdir hello-koa
cd hello-koa

npm init -y
npm install koa

vim index.js
```

```js
const Koa = require("koa");
const app = new Koa();

app.use(async (ctx) => {
  ctx.body = "<h1>Hello World, 你好世界</h1>";
});

app.listen(7777);
console.log("server running at 7777");
```

### 前后端分离

假设你有一些新闻数据, 想把它做成一个新闻网站:

```js
const news = [
  {
    title: "震惊! 天翼3g居然这么快!",
    time: "2008-7-12",
  },
  {
    title: "震惊! 华中科技大学等来了小熊!",
    time: "2019-9-1",
  },
  {
    title: "震惊! 知名互联网团队内的椅子居然全是坏的!",
    time: "2021-7-13",
  },
];
```

直觉上来看, 我们可以这么写:

```js
const Koa = require("koa");
const cors = require("@koa/cors");

const app = new Koa();
app.use(cors({ origin: "*" }));
app.use(async (ctx) => {
  const news = [
    {
      title: "震惊! 天翼3g居然这么快!",
      time: "2008-7-12",
    },
    {
      title: "震惊! 华中科技大学等来了小熊!",
      time: "2019-9-1",
    },
    {
      title: "震惊! 知名互联网团队内的椅子居然全是坏的!",
      time: "2021-7-13",
    },
  ];
  let newsStr = "";
  for (let i = 0; i < news.length; i++) {
    newsStr += `<li>${news[i].title}---${news[i].time}</li>`;
  }
  const newsBody = `<ul>${newsStr}</ul>`;
  ctx.body = newsBody;
});

app.listen(7777);
console.log("server running at 7777");
```

这样固然能完成任务, 但是, 这样字符串拼接写出来的代码, 一来没有语法高亮, 二来不好维护, 不是很优的方案.

我们可以这样:

后端:

```js
const Koa = require("koa");
const app = new Koa();

app.use(async (ctx) => {
  const news = [
    {
      title: "震惊! 天翼3g居然这么快!",
      time: "2008-7-12",
    },
    {
      title: "震惊! 华中科技大学等来了小熊!",
      time: "2019-9-1",
    },
    {
      title: "震惊! 知名互联网团队内的椅子居然全是坏的!",
      time: "2021-7-13",
    },
  ];
  ctx.body = news;
});

app.listen(7777);
console.log("server running at 7777");
```

前端:

```html
<ul id="list"></ul>

<script>
  window.onload = function () {
    fetch("http://xiong35.cn:7777/")
      .then((_) => _.json())
      .then((res) => {
        console.log(res);
        res.forEach((r) => {
          const li = document.createElement("li");
          li.innerText = `${r.title}---${r.time}`;
          list.appendChild(li);
        });
      });
  };
</script>
```

这样就实现了前后端的解耦合, 让二者能各司其职, 互相合作, 共同完成出色的网站了!

## 总结

先行的前后端分离模式下, 后端要做的仅仅是根据前端发送的不同请求, 查出数据库里的数据, 将其传化成 json 格式返回给前端, 至于怎么用这些数据, 渲染到什么地方, 这都是前端的工作, 对数据进行增删改查, 这都是后端的工作.

作为前端, 学习后端的意义在于

1. 降低前后端交互的沟通成本, 以后你和别人合作不至于听不懂他在说什么
2. 需要自己完成小项目时, 自己动手丰衣足食
3. ~~拿更高的 offer~~
4. ~~全栈看起来就很牛逼呢~~

此教程只是抛砖引玉, 后端的知识同样是博大精深的, 需要大家自己多学多写.

<center><h2>干巴爹</h2></center>
