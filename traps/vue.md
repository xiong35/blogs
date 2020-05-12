
- router-link 如何设置为 \<a/\> 以外的元素
- \<router-link tag="div" to="/blog"\>

# vue中
## 设置动态绑定网站标题

在main.js里添加

```js
Vue.directive('title', {
  inserted: function (el, binding) {
    document.title = el.dataset.title
  }
})
```

同时在 template 里加上

```html
<template>
  <div v-title data-title="标题内容aaa">内容aaaa</div>
</template>
```