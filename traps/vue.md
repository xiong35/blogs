
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

# 使用 Nuxt+Vuetify 时
## 引入 FontAwesome5 图标出现问题

正确的引入方法是

```bashscript
npm install @fortawesome/fontawesome-free -D
```

```js
// nuxt.config,js 中
  buildModules: [
    '@nuxtjs/vuetify',
  ],
  css: [
    '@fortawesome/fontawesome-free/css/all.css'
  ],
  vuetify: {
    icons: {
      iconfont: 'fa',
    }
  },
```

```html
<!-- vue 文件中 -->
<v-icon small left>fas fa-home</v-icon>
<v-icon small left>fab fa-weixin</v-icon>
<!-- 注意这里有 fas fab far 等一系列乱七八糟的... -->
```