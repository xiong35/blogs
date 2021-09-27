# cookie 超级详解

> 关键词: 浏览器

## 简介

由于 http 是无状态的, 而很多服务都是有状态的, 为了标记不同的用户, 可以在 http 的**header**中设置 cookie. 设置和发送 cookie 的头部字段分别为`Set-Cookie`和`Cookie`.

## 限制

- 只能携带 4kb 数据
- 不能跨根域名
- 同一个域名下最多有 20 个 cookie (具体取决于浏览器实现)
- 总 cookie 数有限制 (具体取决于浏览器实现)

## 生命周期

如果 cookie 的生存时间是整个**会话期间**的话，那么浏览器会将 cookie 保存在**内存**中，浏览器**关闭时就会自动清除**这个 cookie。另外一种情况就是保存在客户端的**硬盘**中，浏览器关闭的话，该 cookie 也不会被清除，下次打开浏览器访问对应网站时，这个 cookie 就会自动再次发送到服务器端

## 增删改查

js 中用 `document. cookie` 即可访问, 访问到的是这个界面的**所有** cookie 拼成的字符串  
cookie 是以键值对的形式保存的，即 key=value 的格式。各个 cookie 之间一般是以“;”分隔

### 增

```js
document.cookie =
  "username=John Doe; expires=Thu, 18 Dec 2043 12:00:00 GMT; path=/";
```

> 如果不设置过期时间, 默认在关闭浏览器后失效

### 删

> 设置立马失效

### 改

同增, key 相同就直接覆盖

### 查

先读取字符串, 再用正则或者字符串操作查询 key

完整代码:

```js
function setCookie(cname, cvalue, exdays) {
  var d = new Date();
  d.setTime(d.getTime() + exdays * 24 * 60 * 60 * 1000);
  var expires = "expires=" + d.toGMTString();
  document.cookie = cname + "=" + cvalue + "; " + expires;
}

function getCookie(cname) {
  var name = cname + "=";
  var ca = document.cookie.split(";");
  for (var i = 0; i < ca.length; i++) {
    var c = ca[i].trim();
    if (c.indexOf(name) == 0) {
      return c.substring(name.length, c.length);
    }
  }
  return "";
}

function checkCookie() {
  var user = getCookie("username");
  if (user != "") {
    alert("欢迎 " + user + " 再次访问");
  } else {
    user = prompt("请输入你的名字:", "");
    if (user != "" && user != null) {
      setCookie("username", user, 30);
    }
  }
}
```

## 域名

Cookie 具有不可跨域名性(同一根域名的子域名默认也是不行的), 这一点是由浏览器保证实现的的.

如果想一个域名下的子域名都可以使用该 Cookie，需要设置 Cookie 的 `domain` 参数

例如, 设置 `domain` 为 `.foo.com`, 则这个 cookie 在所有以 `.foo.com` **结尾**的域名下都可以被使用

某个域下的 cookie 如果希望能够对他的**子域**具有可见性（即可以读取），必须要注意的一点是，应该保证这个 cookie 在被 Set 的时候，应该以"."开头(关于这一点, 根据 [StackOverflow 上的解释](https://stackoverflow.com/questions/9618217/what-does-the-dot-prefix-in-the-cookie-domain-mean), 按照最新标准 leadind dot **并没有什么作用**了)

## 路径

path 的匹配遵守[以下规范](https://tools.ietf.org/html/rfc6265#section-5.1.4):

0. 记访问的地址(以`/`开头, 不带 query, 不带最右边的`/`)为`uriPath`, 记 cookie 设置的 path 为 `cookiePath`, 满足以下条件之一即认为匹配:
1. `cookiePath === uriPath`
2. `cookiePath.endsWith("/") && uriPath.startsWith(cookiePath")`
3. `uriPath.startsWith(cookiePath") && uriPath(uriPath.indexOf(cookiePath)+1)[0] === "/"`

> 如果未设置 cookie 的 path, cookie path 的默认值按上述规则 0 自动获得([ref](https://www.jianshu.com/p/48556e5c44f5))

用人话说, 正常情况下, 你 cookie path 加不加 trailing `/` 无所谓, 只要你请求的地址**以 cookie path 开头**就能使用这个 cookie

**但是**, 早期的 ie 浏览器并没有很好的遵循第 3 点规范, 导致 cookie path 为 `/abc` 会匹配 `/abcdef` 的请求地址([ref](https://stackoverflow.com/questions/8292449/internet-explorer-sends-the-wrong-cookie-when-the-paths-overlap)
)

举个栗子, 现在我有四个请求地址, 分别为 cookie 设置如下 path, 匹配情况如下:

| request\\cookie path     | `/abc`            | `/abc/` |
| ------------------------ | ----------------- | ------- |
| `http://foo.bar/abc`     | true              | true    |
| `http://foo.bar/abc/`    | true              | true    |
| `http://foo.bar/abc/xyz` | true              | true    |
| `http://foo.bar/abcde`   | false/true(on IE) | false   |

此外, 在设置 cookie 时, 只有 `域名 + path + name` **完全一致**的 cookie 会被视作同一个 cookie

## 有效期

- `expries`: 设置过期的时间点
- `max-age`: 设置过期时间(单位为秒)

- maxAge 为正数的 Cookie 会被浏览器持久化，即写到对应的 Cookie 文件中
- Cookie 默认的 maxAge 值为–1
- maxAge 为 0，则表示立马删除该 Cookie

## 安全

1. W3C 标准的浏览器会阻止 JavaScript 读写任何不属于自己网站的 Cookie
2. 设置 `Secure` 字段会只允许 cookie 被 https 携带: `document.cookie = 'name=Flavio; Secure;'`
3. 设置 `HttpOnly` 字段会只允许 cookie 在服务端被访问, `document.cookie` 将无法读写此 cookie: `document.cookie = 'name=Flavio; HttpOnly;'`
4. 设置 `SameSite`, 详见[前端安全 CSRF+XSS](http://www.xiong35.cn/blog2.0/articles/blog/105)

## 实用的库

[js-cookie](https://github.com/js-cookie/js-cookie)

## 参考资料

- [好好了解一下 Cookie](https://blog.csdn.net/zhangquan_zone/article/details/77627899)
- [Cookie](https://blog.csdn.net/sinat_36594453/article/details/88870899)
- [Learn how HTTP Cookies work](https://flaviocopes.com/cookies/)
- [what does the dot prefix in the cookie domain mean](https://stackoverflow.com/questions/9618217/what-does-the-dot-prefix-in-the-cookie-domain-mean)
- [Cookie path and its accessibility to subfolder pages](https://stackoverflow.com/questions/576535/cookie-path-and-its-accessibility-to-subfolder-pages)
