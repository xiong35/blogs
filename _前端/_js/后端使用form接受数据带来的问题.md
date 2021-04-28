
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
