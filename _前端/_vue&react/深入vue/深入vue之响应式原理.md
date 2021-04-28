
# 深入vue-响应式原理

## 追踪变化

利用 js 的```Object.defineProperty```函数, 重新设置 vue 对象所有的 property, 将他们套上 getter/setter.

> 关于 defineProperty, 参考[这里](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Guide/Working_with_Objects#%E5%AE%9A%E4%B9%89_getters_%E4%B8%8E_setters)

每个组件实例都对应一个 watcher 实例, 它会在组件渲染的过程中把“接触”过的数据 property 记录为依赖. 之后当依赖项的 setter 触发时, 会通知 watcher，从而使它关联的组件重新渲染, 如下图:

![vue watcher](https://cn.vuejs.org/images/data.png)

## 注意事项

### 对象

由于 vue 是在初始化的时候添加的 getter/setter, 所以中途对某个对象 ```$data.someProp``` 添加/移除属性并不会被检测

```js
var vm = new Vue({
  data:{
    a:1
  }
})
// `vm.a` 是响应式的
vm.b = 2
// `vm.b` 是非响应式的
```

要想这么做, 需要使用 vue 的 api: ```Vue.set(object, propertyName, value)```, 或者 ```this.$set(this.someObject, 'b', 2)```

> vue **禁止**在运行时向 data 添加新的属性! 只能在 data 里已有的对象上新增属性(用上述方法)

### 数组

直接取下标操作/设置长度不是响应式的, 可以用以下操作之一替换:

```js
Vue.set(vm.arr, indexOfItem, newValue);

vm.arr.splice(indexOfItem, 1, newValue);

vm.$set(vm.items, indexOfItem, newValue);
```

## 异步更新

vue 在更新组件的时候采用的是事件队列的形式, 可以保证多次触发 watcher 只更新一次

实现: 优先使用 Promise, 如果不支持就改用 ```setTimeout(fn, 0)```

刷新队列时, 组件在下一个 tick 中更新, 如果想操做更新后的 DOM, 可以使用```Vue.nextTick(callback)```

```js
Vue.component('example', {
  template: '<span>{{ message }}</span>',
  data: function () {
    return {
      message: '未更新'
    }
  },
  methods: {
    updateMessage: function () {
      this.message = '已更新'
      console.log(this.$el.textContent) // => '未更新'
      this.$nextTick(function () {
        console.log(this.$el.textContent) // => '已更新'
      })
    }
  }
})
```
