
- router-link 如何设置为 \<a/\> 以外的元素
- \<router-link tag="div" to="/blog"\>

- 动态绑定标题

```js
Vue.directive('title', {
  inserted: function (el, binding) {
    document.title = el.dataset.title
  }
})

const routes = [
  { path: '/a', component: { template: '<div v-title data-title="标题内容aaa">内容aaaa</div>' } },
  { path: '/b', component: { template: '<div v-title data-title="标题内容bbb">内容bbbb</div>' } }
]

const router = new VueRouter({
  routes
})

new Vue({
    router,
  el: '#app'
})
```