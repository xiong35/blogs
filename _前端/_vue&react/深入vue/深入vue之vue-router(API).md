
# 深入vue之vue-router(API)

## \<router-link\>

### to

- string  
- required

e.g.

```html
<router-link to="home">Home</router-link>
<router-link :to="'home'">Home</router-link>
<router-link :to="{ path: 'home' }">Home</router-link>
<router-link :to="{ name: 'user', params: { userId: 123 }}">User</router-link>
<!-- 带查询参数, 下面的结果为 /register?plan=private -->
<router-link :to="{ path: 'register', query: { plan: 'private' }}"
  >Register</router-link>
```

### replace

设置 replace 属性的话, 当点击时, 会调用 router.replace() 而不是 router.push()

e.g.

```html
<router-link :to="{ path: '/abc'}" replace></router-link>
```

### append

设置 append 属性后, 则在当前 (相对) 路径前添加基路径. 例如, 我们从 /a 导航到一个相对路径 b, 如果没有配置 append, 则路径为 /b, 如果配了, 则为 /a/b

e.g.

```html
<router-link :to="{ path: 'relative/path'}" append></router-link>
```

### tag

```html
<router-link to="/foo" tag="li">foo</router-link>
```

### active-class

设置链接激活时使用的 CSS 类名. 默认值可以通过路由的构造选项 linkActiveClass 来全局配置

默认值: "router-link-active"

### exact

“是否激活”默认类名的依据是包含匹配, 如果当前的路径是 /a/foo , 那么 ```<router-link to="/a">``` 也会被设置 active 类名

### exact-active-class

默认值: "router-link-exact-active"

## \<router-view\>

name: 设置了 name 就会渲染对应的路由配置中 components 下的相应组件

## router构建选项

### routes

类型: ```Array<RouteConfig>```

RouteConfig:

```js
interface RouteConfig = {
  path: string,
  component?: Component,
  name?: string, // 命名路由
  components?: { [name: string]: Component }, // 命名视图组件
  redirect?: string | Location | Function,
  props?: boolean | Object | Function,
  alias?: string | Array<string>,
  children?: Array<RouteConfig>, // 嵌套路由
  beforeEnter?: (to: Route, from: Route, next: Function) => void,
  meta?: any,

  // 2.6.0+
  caseSensitive?: boolean, // 匹配规则是否大小写敏感？(默认值：false)
  pathToRegexpOptions?: Object // 编译正则的选项
}
```

### base

设置基路径

### linkActiveClass / linkExactActiveClass

## 路由对象

### $route.path

类型: string

字符串, 对应当前路由的路径, 总是解析为绝对路径, 如 "/foo/bar"

### $route.params

类型: Object

一个 key/value 对象, 包含了动态片段和全匹配片段, 如果没有路由参数, 就是一个空对象

### $route.query

类型: Object

一个 key/value 对象, 表示 URL 查询参数. 例如, 对于路径 ```/foo?user=1```, 则有 ```$route.query.user == 1```, 如果没有查询参数, 则是个空对象

### $route.hash

类型: string

当前路由的 hash 值 (带 #) , 如果没有 hash 值, 则为空字符串

### $route.fullPath

类型: string

完成解析后的 URL, 包含查询参数和 hash 的完整路径

### $route.matched

类型: Array\<RouteRecord\>

一个数组, 包含当前路由的所有嵌套路径片段的路由记录 . 路由记录就是 routes 配置数组中的对象副本 (还有在 children 数组)

```js
routes: [
  // 下面的对象就是路由记录
  {
    path: '/foo',
    component: Foo,
    children: [
      // 这也是个路由记录
      { path: 'bar', component: Bar }
    ]
  }
]
```

当 URL 为 ```/foo/bar```, ```$route.matched``` 将会是一个包含从上到下的所有对象 (副本)

### $route.name

当前路由的名称, 如果有的话. (查看命名路由)

### $route.redirectedFrom

如果存在重定向, 即为重定向来源的路由的名字. (参阅重定向和别名)

## 注入的组件

### this.$router

router 实例(是真正的**实例**)

### this.$route

当前激活的路由信息对象(只是一个**路由对象**). 这个属性是只读的, 里面的属性是 immutable (不可变) 的, 不过你可以 watch (监测变化) 它