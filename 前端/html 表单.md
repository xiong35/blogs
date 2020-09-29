
# html 表单知识摘要

- 表单中组件的属性一览
  - `value` 为提交时的值
  - `name` 为键
  - `id` 为唯一标识, 可以用来挂载 label.
  - label 的 `for`: 点击 label 会 focus 到对应的表单元素
  - `type`
    - submit: 提交按钮, value 为内部文字
    - reset: 重置表单, value 同上
    - hidden: 隐藏表单元素, 常用作 csrf token
- `<form action="/getinfo" method="get">`会向`action`指定的 url 发送 GET 请求, 形式为字符串拼接的 query 参数
  - 如果为 POST 形式, 发送数据格式为`application/x-www-form-urlencoded`
- 有相同 name 的 radio 会被视为一组, checkbox 同理
- select(弹出的选择菜单) 应该这样写:

  ```html
  <select name="mycar"> 
      <option value="三菱" selected>三菱</option>
      <option value="奥迪">奥迪</option>
      <option value="MINI">MINI</option>
  </select>
  ```