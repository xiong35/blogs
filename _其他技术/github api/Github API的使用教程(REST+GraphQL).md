# Github API 的使用教程(REST+GraphQL)

> 关键词: 指北, 前端杂记, 工具记录

github 提供了公开的 api 来让你进行几乎一切的 github 操作(什么搜索仓库啊, 发 issue 啊, 删库跑路啊...一应俱全)

登录[github 开发者网站](https://developer.github.com/)即可看到英文版的 API 使用说明, 我在此仅演示几个基础功能

## REST api

### 前言

> 前置知识: 会使用 api, [什么是 rest api](https://blog.csdn.net/D_R_L_T/article/details/82562902), 英文阅读能力

先来直观感受下使用效果:

- [查询名字包含 react 的仓库, 按 star 数降序排列](https://api.github.com/search/repositories?q=react&sort=stars&order=desc)
- [查看**我**的所有 follower](https://api.github.com/users/xiong35/followers), 如果你也去 follow 我就可以看到你自己了 ;)

### 使用

在上文提到的开发者网站上, 按下图所示选择 REST API

![homepage](https://s1.ax1x.com/2020/06/30/N5jTAJ.png)

在右边找到你想搜索的项目, 点进去就可以看到相关教程, 现以搜索仓库为例:

![choose repo](https://s1.ax1x.com/2020/06/30/N5jq91.png)

根据文档, 使用 GET 方法请求 `/search/repositories` 这个 url 即可得到信息, 此外还有可选的 query:

> ps: base url 是 https://api.github.com

![repo_illustration](https://s1.ax1x.com/2020/06/30/N5jxBD.png)

实例: [https://api.github.com/search/repositories?q=react+language:javascript&sort=stars&order=desc](https://api.github.com/search/repositories?q=react+language:javascript&sort=stars&order=desc), 查询名字包含 react 的仓库, 且仓库主要使用 js 语言, 按 star 数降序排列

## GraphQL api

> 前置知识: [什么是 GraphQL](https://www.zhihu.com/question/264629587), 英语阅读能力

查看官方文档你会发现你一脸懵逼, 这个 api 到底应该怎么使用呢?

### 网页上测试 GraphQL

进入[GitHub's GraphQL Explorer](https://developer.github.com/v4/explorer/)

![GraphQL explorer](https://s1.ax1x.com/2020/06/30/N5jHhR.png)

举个比方, 你想查询自己 github 的 hot map, 就是那个画满了<del>灰色</del>绿色格子的 Contribute 表, 该怎么查询呢?

首先需要**确认**你查询的用户, 也就是你自己. 怎么确认呢, 我们在 docs 里搜索一下 user 看看能不能找到相关信息:

![search_user](https://s1.ax1x.com/2020/06/30/N5jvnO.png)

点进去看看, 发现 user 有很多属性, 怎么确定搜索的用户是你, 而不是别人呢? 我们需要一个你的**唯一标识**. 找找 user 属性里能当唯一标识的项目, 发现一个叫 login 的项目, 对, 这就是你的用户名!

> GraphQL 的查询是层层嵌套的, 此处的 User 是一个对象, 有很多基本属性, 也包含很多其他对象, 而对象是不能当作查询结果的, 只有基本属性才可以
> 基本属性是指 string, date, datetime, bool, int...之类的属性

![query1](https://s1.ax1x.com/2020/06/30/N5jzHe.png)

接下来我们需要 user 对象的活动信息, 在搜索栏查看 user 的属性, 找到 contributionsCollection 属性, 这是一个对象.

![user_contribute](https://s1.ax1x.com/2020/06/30/N5vpAH.png)

contributionsCollection 的 from 属性接受一个 Datetime 类型的参数, 来指定统计 commit 活动的最早时间, 我们将代码添加为:

```json
query {
  user(login:"xiong35"){
    contributionsCollection(from:"2020-01-01T00:00:00+08:00"){
      // todo
    }
  }
}
```

> Datetime 属性是遵循[ISO 8601 规范](https://baike.baidu.com/item/ISO%208601/3910715?fr=aladdin)的字符串

接下来就一层层找, 直到找到需要的基本类型的信息就直接用他的名字接受即可. 完善代码为:

```json
query {
  user(login:"xiong35"){
    contributionsCollection(from:"2020-01-01T17:30:08+08:00"){
      contributionCalendar{
        colors
        weeks{
          contributionDays{
            date
          }
        }
      }
    }
  }
}
```

其中 colors, date 是基本属性, 其他的都是对象

查询结果如下图

![query_result](https://s1.ax1x.com/2020/06/30/N5jXjK.png)

### 代码中使用

好了, 我们已经学会在 github 提供的网页上使用了, 该怎么在生产中的代码里使用呢?

首先, 我们需要一个 github 的 access token  
进去 github, 按下图所示依次点击 `头像 > settings > developer settings > personal access token > generate new token`

![github_settings](https://s1.ax1x.com/2020/06/30/N5j7N9.png)

![developer_settings](https://s1.ax1x.com/2020/06/30/N5jI74.png)

![personal_access_token](https://s1.ax1x.com/2020/06/30/N5jL1x.png)

输入密码后即可创建 token  
提前提醒一句, 创建好 token 后**只能看到他一次**, **务必在此时保存好**, 不然退出之后就再也看不见他了!

关于 token 的权限, 如果有讲究就慢慢看介绍, 一个一个勾选, 没讲究就**全打勾**得了

好的你现在得到了一个热乎的 token, 该怎么使用呢?

> 以 postman 为例, 讲解必备的操作, 实际上使用任何语言都能实现同样的效果

1. 在 http 请求的 header 中设置以下字段:`Authorization: token <你的token>`
2. 在 body 中按以下格式添加你的查询语句(注意将换行符, 引号等转义)
3. 发送 POST 请求到`https://api.github.com/graphql`

```json
{
  "query": "query {user(login:\"xiong35\"){contributionsCollection(from:\"2020-01-01T17:30:08+08:00\"){contributionCalendar{colors weeks{contributionDays{date}}}}}}"
}
```

即可得到查询结果:

![postman_result](https://s1.ax1x.com/2020/06/30/N5jOc6.png)

#### 参考资料

- [github 开发者文档](https://developer.github.com/)
- [使用 GitHub 的 GraphQL API](https://blog.csdn.net/caiqiiqi/article/details/97936365)
- [GraphQL Tutorial: Using Github GraphQL API with Node.js](https://www.scaledrone.com/blog/graphql-tutorial-using-github-graphql-api-with-nodejs/)
