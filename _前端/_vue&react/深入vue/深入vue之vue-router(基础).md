
# 深入vue之vue-router(基础)

## hello world

```html
<script src="https://unpkg.com/vue/dist/vue.js"></script>
<script src="https://unpkg.com/vue-router/dist/vue-router.js"></script>

<div id="app">
  <h1>Hello App!</h1>
  <p>
    <!-- 使用 router-link 组件来导航. -->
    <!-- 通过传入 `to` 属性指定链接. -->
    <!-- <router-link> 默认会被渲染成一个 `<a>` 标签 -->
    <router-link to="/foo">Go to Foo</router-link>
    <router-link to="/bar" tag="div">Go to Bar</router-link>
  </p>
  <!-- 路由出口 -->
  <!-- 路由匹配到的组件将渲染在这里 -->
  <router-view></router-view>
</div>
```

```js
// 0. 如果使用模块化机制编程, 导入Vue和VueRouter, 要调用 Vue.use(VueRouter)

// 1. 定义 (路由) 组件。
// 可以从其他文件 import 进来
const Foo = { template: '<div>foo</div>' }
const Bar = { template: '<div>bar</div>' }

// 2. 定义路由
// 每个路由应该映射一个组件。 其中"component" 可以是
// 通过 Vue.extend() 创建的组件构造器, 
// 或者, 只是一个组件配置对象。
// 我们晚点再讨论嵌套路由。
const routes = [
  { path: '/foo', component: Foo },
  { path: '/bar', component: Bar }
]

// 3. 创建 router 实例, 然后传 `routes` 配置
// 你还可以传别的配置参数, 不过先这么简单着吧。
const router = new VueRouter({
  routes // (缩写) 相当于 routes: routes
})

// 4. 创建和挂载根实例。
// 记得要通过 router 配置参数注入路由, 
// 从而让整个应用都有路由功能
const app = new Vue({
  router
}).$mount('#app')

// 现在, 应用已经启动了！
```

## 动态路由匹配

在 path 里设置动态参数: ```path: '/user/:id', component: User```  
一个“路径参数”使用冒号 : 标记。当匹配到一个路由时, 参数值会被设置到 this.$route.params, 可以在每个组件内使用

```js
const User = {
  template: '<div>User {{ $route.params.id }}</div>'
}
```

可匹配多个参数:  
设置路径为```/user/:username/post/:post_id```, ```/user/evan/post/123```匹配到的 params 为```{ username: 'evan', post_id: '123' }```

当使用路由参数时, 例如从 /user/foo 导航到 /user/bar, 原来的组件实例会被复用, 若想检测到参数变化, 可以 watch params, 或使用导航守卫

"*" 为通配符, 可与```params.pathMatch```搭配使用

```js
// 给出一个路由 { path: '/user-*' }
this.$router.push('/user-admin')
this.$route.params.pathMatch // 'admin'
```

> 正则路由: 参考[这里](https://github.com/pillarjs/path-to-regexp/tree/v1.7.0)

## 嵌套路由

```js
routes: [
  { path: '/user/:id', component: User,
    children: [
      {
        // 当 /user/:id/profile 匹配成功, 
        // UserProfile 会被渲染在 User 的 <router-view> 中
        path: 'profile',
        component: UserProfile
      }
    ]
  }
]
```

以 / 开头的嵌套路径会被当作根路径, 而无开头的会以父级目录为根目录  
此时访问 /user/foo 不会匹配到组件, 设置 path: "" 后才会匹配

## 编程式导航

```js
// 字符串
router.push('home')
// 对象
router.push({ path: 'home' })
// 命名的路由
router.push({ name: 'user', params: { userId: '123' }})
// 带查询参数, 变成 /register?plan=private
router.push({ path: 'register', query: { plan: 'private' }})
```

如果提供了 path, params 会被忽略

```js
const userId = '123'
router.push({ name: 'user', params: { userId }}) // -> /user/123
router.push({ path: `/user/${userId}` }) // -> /user/123
// 这里的 params 不生效
router.push({ path: '/user', params: { userId }}) // -> /user
```

其他还有

```js
router.replace(location, onComplete?, onAbort?)
router.go(n)
```

## 命名路由

```js
routes: [
  {
    path: '/user/:userId',
    name: 'user',
    component: User
  }
]

router.push({ name: 'user', params: { userId: 123 }})
```

或者↓

```html
<router-link :to="{ name: 'user', params: { userId: 123 }}">User</router-link>
```

## 命名视图

有时候想同时 (同级) 展示多个视图, 而不是嵌套展示, 这个时候命名视图就派上用场了

```html
<!-- 默认为 default -->
<router-view class="view one"></router-view>
<router-view class="view two" name="a"></router-view>
<router-view class="view three" name="b"></router-view>
```

```js
routes: [
  {
    path: '/',
    // 复数, 要加 S
    components: {
      default: Foo,
      a: Bar,
      b: Baz
    }
  }
]
```

## 重定向

```js
routes: [
  { path: '/a', redirect: '/b' },
  { path: '/bar', redirect: { name: 'foo' }},
  { path: '/a', redirect: to => {
      // 方法接收 目标路由 作为参数
      // return 重定向的 字符串路径/路径对象
    }
  }
]
```

别名: /a 的别名是 /b, 意味着, 当用户访问 /b 时, URL 会保持为 /b, 但是路由匹配则为 /a, 就像用户访问 /a 一样

```js
routes: [
  { path: '/a', component: A, alias: '/b' }
]
```

### 路由组件传参

Hello 组件有 ```props: {name: {type: String, default: 'Vue!'}```

```js
function dynamicPropsFn (route) {
  const now = new Date()
  return {
    name: (now.getFullYear() + parseInt(route.params.years)) + '!'
  }
}

const router = new VueRouter({
  mode: 'history',
  base: __dirname,
  routes: [
    { path: '/', component: Hello }, // No props, no nothing
    { path: '/hello/:name', component: Hello, props: true }, // Pass route.params to props
    { path: '/static', component: Hello, props: { name: 'world' }}, // static values
    { path: '/dynamic/:years', component: Hello, props: dynamicPropsFn }, // custom logic for mapping between route and props
    { path: '/attrs', component: Hello, props: { name: 'attrs' }}
  ]
})
```