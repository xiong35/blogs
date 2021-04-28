
# vue 学习笔记

## 23 渲染函数/JSX

```html
<!-- 需求: -->
<h1>
  <a name="hello-world" href="#hello-world">
    Hello world!
  </a>
</h1>

<!-- 组件: -->
<anchored-heading :level="1">Hello world!</anchored-heading>
```

```js
Vue.component('anchored-heading', {
  render: function (createElement) {
    //   用js原生的方法
    return createElement(
      'h' + this.level,   // 标签名称
      this.$slots.default // 子节点数组
    )
  },
  props: {
    level: {
      type: Number,
      required: true
    }
  }
})
```

#TODO https://cn.vuejs.org/v2/guide/render-function.html#%E8%8A%82%E7%82%B9%E3%80%81%E6%A0%91%E4%BB%A5%E5%8F%8A%E8%99%9A%E6%8B%9F-DOM

## 24 插件

```js
var VueRouter = require('vue-router')

// 不要忘了调用此方法
Vue.use(VueRouter)
```

## 25 管道操作/过滤器

过滤器可以用在两个地方：双花括号插值和 v-bind 表达式

```html
<!-- 在双花括号中 -->
{{ message | capitalize }}

<!-- 在 `v-bind` 中 -->
<div v-bind:id="rawId | formatId"></div>
```

e.g: 将字符串转换成首字母大写

```js
filters: {
  capitalize: function (value) {
    if (!value) return ''
    value = value.toString()
    return value.charAt(0).toUpperCase() + value.slice(1)
  }
}

// 全局过滤器
Vue.filter('capitalize', function (value) {
  if (!value) return ''
  value = value.toString()
  return value.charAt(0).toUpperCase() + value.slice(1)
})

{{ message | filterA('arg1', arg2) }}
// 这里，filterA 被定义为接收三个参数的过滤器函数。
// 其中 message 的值作为第一个参数，普通字符串 'arg1' 作为第二个参数，表达式 arg2 的值作为第三个参数
```

## 26 高级

#TODO https://cn.vuejs.org/v2/guide/single-file-components.html