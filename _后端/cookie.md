# cookie, session, token 对比

> 关键词: 前端杂记, 浏览器

后端会接受相当多的前端请求, 但是有时候请求不止一次, 要持续交互, 而这时候后端并不认识前端请求各自是谁、操作到哪一步了, 所以需要一些存贮信息的手段, 其中主要就是 cookie, session, token 三种方式

## cookie

将键值对直接存在 http 请求中, 下次来了前端请求, 直接读取他 http 里的 cookie 就可以获取信息

- 优点
  - 简单方便
- 缺点
  - 在前端可以自行修改数据, 并不安全
  - 有的地方不支持 cookie(如手机 app/桌面应用/某些 ie)
- 适用于
  - 简单且不重要的数据(如主题颜色/用户名什么的[我随便说的])
  - 下面说到的 session

## session

将键值对存在后端数据库里, 凭借伪随机的独一无二的 session id 来认领数据, 并将 session id 存在 cookie 中  
随你前端修改 cookie, 反正如果对应不上后端的 id, 我不把数据该你就完事了

- 优点
  - 后端管理数据, 比较安全
- 缺点
  - 同样有不支持 cookie 的问题
  - 需要防止[csrf 跨站攻击](https://zhuanlan.zhihu.com/p/22521378)
- 适用于
  - 绝大部分添加了 csrf 防御的场景

## token

和 session 类似, 但是不将 token(类似 session id, 即认领数据的 id)放在 cookie 里, 而是放在返回 http 回应的 body 数据里, 类似这样:

```json
{
  "status": "200",
  "data": "......",
  "token": "wwiduobv6coiasv4ignq446ftfbvg6fvrqbi"
}
```

- 优点
  - 这样的 token 兼容性好, 各个平台自行选择自己的方式存储
  - 一定程度上避免了 csrf 攻击
- 适用于
  - 所有场景

ps.本博客采用的就是 token 的认证方式
