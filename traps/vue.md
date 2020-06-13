
- router-link 如何设置为 \<a/\> 以外的元素
- \<router-link tag="div" to="/blog"\>

# vue中设置动态绑定网站标题

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

# 使用 Nuxt+Vuetify 时, 引入 FontAwesome5 图标出现问题

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

# 使用 vuetify 时, 找不到 v-col 对应的 xs 的 flex 布局

当前版本(@nuxtjs/vuetify 1.11.2)**确实没有** xs 布局, 但是想要实现这个布局怎么办呢? 可以指定默认布局

```html
<v-col
  class="col-12"
  sm="6"
  md="4"
  lg="3"
>
  <v-card class="pa-2">
    One of three columns
  </v-card>
</v-col>
```

```class="col-12"```就是指定的默认布局

# 使用 nuxt 时想在 middleware 里获取 localStorage

nuxt 会在服务端渲染, 而服务端没有浏览器对象, 无法获取 localStorage

解决方案:

在 mounted 钩子里强行实现跳转检验  

或参考[这篇文章](https://zhuanlan.zhihu.com/p/82481387)