
# 深入vue之vue-router(进阶)

## 导航守卫

params / query 的变化不会触发守卫  
要想监视他们的变化, 可以 watch $route 对象, 或者调用**组件内**的```beforeRouteUpdate```守卫

### 全局守卫

```js
const router = new VueRouter({ ... })
router.beforeEach((to, from, next) => {
  // ...
})
```

- ```to: Route```: 即将要进入的目标[路由对象](https://router.vuejs.org/zh/api/#%E8%B7%AF%E7%94%B1%E5%AF%B9%E8%B1%A1)
- ```from: Route```: 正要离开的路由对象
- ```next: Function```: 不太懂, 参考[这里](https://router.vuejs.org/zh/guide/advanced/navigation-guards.html#%E5%85%A8%E5%B1%80%E5%89%8D%E7%BD%AE%E5%AE%88%E5%8D%AB)

### 全局解析守卫

可以用 router.beforeResolve 注册一个全局守卫。这和 router.beforeEach 类似，区别是在导航被确认之前，**同时在所有组件内守卫和异步路由组件被解析之后**，解析守卫就被调用

### 全局后置钩子

```js
router.afterEach((to, from) => {
  // ...
})
```

> ps: 后置钩子没有 next 函数

### 路由内钩子

```js
routes: [
  {
    path: '/foo',
    component: Foo,
    beforeEnter: (to, from, next) => {
      // ...
    }
  }
]
```

### 组件内钩子

```js
const Foo = {
  template: `...`,
  beforeRouteEnter (to, from, next) {
    // 在渲染该组件的对应路由被 confirm 前调用
    // 不！能！获取组件实例 `this`
    // 因为当守卫执行前，组件实例还没被创建
    // 但是可以传 next 回调
    next(vm => {
      // 通过 `vm` 访问组件实例
    })
  },
  beforeRouteUpdate (to, from, next) {
    // 在当前路由改变，但是该组件被复用时调用
    // 举例来说，对于一个带有动态参数的路径 /foo/:id，在 /foo/1 和 /foo/2 之间跳转的时候，
    // 由于会渲染同样的 Foo 组件，因此组件实例会被复用。而这个钩子就会在这个情况下被调用。
    // 可以访问组件实例 `this`
  },
  beforeRouteLeave (to, from, next) {
    // 导航离开该组件的对应路由时调用
    // 可以访问组件实例 `this`
  }
}
```

### 总体顺序

1. 导航被触发
2. 在失活的组件里调用离开守卫
3. 调用全局的 beforeEach 守卫
4. 在重用的组件里调用 beforeRouteUpdate 守卫
5. 在路由配置里调用 beforEnter
6. 解析异步路由组件
7. 在被激活的组件里调用 beforeRouteEnter
8. 调用全局的 beforeResolve 守卫
9. 导航被确认
10. 调用全局的 afterEach 钩子
11. 触发 DOM 更新
12. 在创建好的实例调用 beforeRouteEnter 守卫中传给 next 的回调函数

## meta

略, 详见[这里](https://router.vuejs.org/zh/guide/advanced/meta.html)

## 滚动行为

```js
const router = new VueRouter({
  routes: [...],
  scrollBehavior (to, from, savedPosition) {
    // return 期望滚动到哪个的位置
  }
})
```

返回滚动位置的对象, 形如:

- ```{ x: number, y: number }```
- ```{ selector: string, offset? : { x: number, y: number }}```
- Promise, 见下文例子

举例:

```js
scrollBehavior (to, from, savedPosition) {
  if (savedPosition) {
    return savedPosition
  } else {
    return { x: 0, y: 0 }
  }
}

scrollBehavior (to, from, savedPosition) {
  if (to.hash) {
    return {
      selector: to.hash
    }
  }
}

scrollBehavior (to, from, savedPosition) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve({ x: 0, y: 0 })
    }, 500)
  })
}
```

## 懒加载

```js
const Foo = () => Promise.resolve({ /* 组件定义对象 */ })

const Foo = () => import('./Foo.vue') // import返回 Promise