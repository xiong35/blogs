
# 深入vue之vue-loader

## css 作用域

```html
<style scoped>
.a >>> .b { /* ... */ }
</style>
<!-- 编译为 -->
.a[data-v-f3f3eg9] .b { /* ... */ }
```

> 尽量使用 class/id 进行选择, 而非元素

## css module

使用 scoped 时, 类名冲突会带来样式冲突, 尽管 vue 会编译css, 这个问题也不能完全避免

使用 css module 则可以完全解决此问题

但是我还是喜欢 scoped, 原文贼在[这里](https://vue-loader-v14.vuejs.org/zh-cn/features/css-modules.html)

## postcss

[啥玩意啊](https://vue-loader-v14.vuejs.org/zh-cn/features/postcss.html)