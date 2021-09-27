# `React.memo`比较的坑

> 关键词: React, 踩坑记录

`React.memo`只对 props 做浅比较, 当遇到复杂对象时每次都会被重新渲染, 带来性能问题

解决方案: memo 函数支持第二个参数, 来自定义对 props 的比较

[官方文档](https://zh-hans.reactjs.org/docs/react-api.html#reactmemo)
