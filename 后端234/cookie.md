
# cookie, session, token 对比

后端会接受相当多的前端请求, 但是有时候请求不止一次, 要持续交互, 而这时候后端并不认识前端请求各自是谁、操作到哪一步了, 所以需要一些存贮信息的手段, 其中主要就是 cookie, session, token 三种方式

## cookie

将键值对直接存在http请求中, 下次来了前端请求, 直接读取他http里的cookie就可以获取信息

- 优点
  - 简单方便
- 缺点
  - 在前端可以自行修改数据, 并不安全
  - 有的地方不支持cookie(如手机app/桌面应用/某些ie)
- 适用于
  - 简单且不重要的数据(如主题颜色/用户名什么的[我随便说的])
  - 下面说到的session

## session

将键值对存在后端数据库里, 凭借伪随机的独一无二的session id来认领数据, 并将session id存在cookie中  
随你前端修改cookie, 反正如果对应不上后端的id, 我不把数据该你就完事了

- 优点
  - 后端管理数据, 比较安全
- 缺点
  - 同样有不支持cookie的问题
  - 需要防止[csrf跨站攻击](https://zhuanlan.zhihu.com/p/22521378)
- 适用于
  - 绝大部分添加了csrf防御的场景

## token

和session类似, 但是不将token(类似session id, 即认领数据的id)放在cookie里, 而是放在返回http回应的body数据里, 类似这样:

```json
{
    "status": "200",
    "data": "......",
    "token": "wwiduobv6coiasv4ignq446ftfbvg6fvrqbi"
}
```

- 优点
  - 这样的token兼容性好, 各个平台自行选择自己的方式存储
  - 一定程度上避免了csrf攻击
- 适用于
  - 所有场景

ps.本博客采用的就是token的认证方式