
# vue 学习笔记

## 16 动态组件

有时我们更希望那些标签的组件实例能够被在它们第一次被创建的时候缓存下来。为了解决这个问题，我们可以用一个 \<keep-alive\> 元素将其动态组件包裹起来:

```html
<keep-alive>
  <component v-bind:is="currentTabComponent"></component>
</keep-alive>
```

这样这个组件只会被创建一次

## 17 异步组件

在大型应用中，我们可能需要将应用分割成小一些的代码块，并且只在需要的时候才从服务器加载一个模块。为了简化，Vue 允许你以一个工厂函数的方式定义你的组件，这个工厂函数会异步解析你的组件定义。Vue 只有在这个组件需要被渲染的时候才会触发该工厂函数，且会把结果缓存起来供未来重渲染。  
#TODO https://cn.vuejs.org/v2/guide/components-dynamic-async.html#%E5%BC%82%E6%AD%A5%E7%BB%84%E4%BB%B6

## 18 特殊用法

在绝大多数情况下，我们最好不要触达另一个组件实例内部或手动操作 DOM 元素。不过也确实在一些情况下做这些事情是合适的

### 18.1 根/父实例

```js
// Vue 根实例
new Vue({
  data: {
    foo: 1
  },
  computed: {
    bar: function () { /* ... */ }
  },
  methods: {
    baz: function () { /* ... */ }
  }
})

// 获取根组件的数据
this.$root.foo
// 写入根组件的数据
this.$root.foo = 2
// 访问根组件的计算属性
this.$root.bar
// 调用根组件的方法
this.$root.baz()
```

> ```$parent```同理

### 18.2 访问子组件

通过 ref 这个 attribute 为子组件赋予一个 ID 引用:

```html
<base-input ref="usernameInput"></base-input>
```

现在在已经定义了这个 ref 的组件里，可以使用 ```this.$refs.usernameInput``` 来访问这个 \<base-input\> 实例

### 18.3 依赖注入

provide 选项允许我们指定我们想要提供给后代组件的数据/方法:

```js
provide: function () {
  return {
    getMap: this.getMap
  }
}
```

然后在任何后代组件里，我们都可以使用 inject 选项来接收指定的我们想要添加在这个实例上的属性: ```inject: ['getMap']```

可以把依赖注入看作一部分“大范围有效的 prop”，除了:

- 祖先组件不需要知道哪些后代组件使用它提供的属性
- 后代组件不需要知道被注入的属性来自哪里

> **所提供的属性是非响应式的!!!**

### 18.4 侦听器

- 通过 $on(eventName, eventHandler) 侦听一个事件
- 通过 $once(eventName, eventHandler) 一次性侦听一个事件
- 通过 $off(eventName, eventHandler) 停止侦听一个事件

```js
// $once
mounted: function () {
  this.attachDatepicker('startDateInput')
  this.attachDatepicker('endDateInput')
},
methods: {
  attachDatepicker: function (refName) {
    var picker = new Pikaday({
      field: this.$refs[refName],
      format: 'YYYY-MM-DD'
    })

    this.$once('hook:beforeDestroy', function () {
      picker.destroy()
    })
  }
}
```

### 18.5 循环引用

#### 18.5.1 递归

当你使用 Vue.component 全局注册一个组件时，这个全局的 ID 会自动设置为该组件的 name 选项: ```name: 'unique-name-of-my-component'```

```html
name: 'stack-overflow',
template: '<div><stack-overflow></stack-overflow></div>'
```

用 v-if 控制

### 18.6 其他模板定义

#### 18.6.1 内联模板

当 inline-template 这个特殊的 attribute 出现在一个子组件上时，这个组件将会使用其里面的内容作为模板，而不是将其作为被分发的内容。这使得模板的撰写工作更加灵活

```html
<father id="xxx">
  <my-component inline-template>
    <div>
      <p>These are compiled as the component's own template.</p>
      <p>Not parent's transclusion content.</p>
    </div>
  </my-component>
</father>
```

这样声明子组件的时候就不用写 ```template:xxx``` 了

#### 18.6.2 X-template

另一个定义模板的方式是在一个 \<script\> 元素中，并为其带上 text/x-template 的类型，然后通过一个 id 将模板引用过去

```html
<script type="text/x-template" id="hello-world-template">
  <p>Hello hello hello</p>
</script>
```

```js
Vue.component('hello-world', {
  template: '#hello-world-template'
})
```

> 这些可以用于模板特别大的 demo 或极小型的应用，但是其它情况下请避免使用，因为这会将模板和该组件的其它定义分离开

### 18.7 控制更新

### 18.7.1 强制更新

> 如果你发现你自己需要在 Vue 中做一次强制更新，99.9% 的情况，是你在某个地方做错了事

用法: ```vm.$forceUpdate```

### 18.7.2 v-once

渲染普通的 HTML 元素在 Vue 中是非常快速的，但有的时候你可能有一个组件，这个组件包含了大量静态内容。在这种情况下，你可以在根元素上添加 v-once attribute 以确保这些内容只计算一次然后缓存起来，就像这样:

```js
Vue.component('terms-of-service', {
  template: `
    <div v-once>
      <h1>Terms of Service</h1>
      ... a lot of static content ...
    </div>
  `
})
```
