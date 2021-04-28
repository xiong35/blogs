
# vue学习笔记 3

## 8 列表渲染

### 8.1 基本语法

```html
<!-- 迭代列表 -->
<ul id="example-1">
  <li v-for="item in items" :key="item.message">
    {{ item.message }}
  </li>
</ul>

<!-- 支持index -->
<ul id="example-2">
  <li v-for="(item, index) in items">
    {{ parentMessage }} - {{ index }} - {{ item.message }}
  </li>
</ul>

<!-- 更'js'的写法: of -->
<div v-for="item of items"></div>

<!-- 也可以迭代对象(顺序没有保证) -->
<ul id="v-for-object" class="demo">
  <li v-for="value in object">
    {{ value }}
  </li>
</ul>

<div v-for="(value, name) in object">
  {{ name }}: {{ value }}
</div>

<div v-for="(value, name, index) in object">
  {{ index }}. {{ name }}: {{ value }}
</div>
```

建议尽可能在使用 v-for 时提供 key attribute，除非遍历输出的 DOM 内容非常简单，或者是刻意依赖默认行为以获取性能上的提升

### 8.2 更新检测

Vue 将被侦听的数组的变异方法进行了包裹，所以它们也将会触发视图更新。这些被包裹过的方法包括：

- push()
- pop()
- shift()
- unshift()
- splice()
- sort()
- reverse()

e.g: ```vm.items.push({ message: 'foo' })```

也有非变异 (non-mutating method) 方法，例如 filter()、concat() 和 slice():

```javascript
example1.items = example1.items.filter(function (item) {
  return item.message.match(/Foo/)
})
```

### 8.3 处理数据

```html
<ul v-for="set in sets">
  <li v-for="n in even(set)">{{ n }}</li>
</ul>
```

```javascript
data: {
  sets: [[ 1, 2, 3, 4, 5 ], [6, 7, 8, 9, 10]]
},
methods: {
  even: function (numbers) {
    return numbers.filter(function (number) {
      return number % 2 === 0
    })
  }
}
```

### 8.4 重复操作

```html
<div>
  <span v-for="n in 10">{{ n }} </span>
</div>
```

template 也支持for

### 8.5 组合使用

```html
<ul v-if="todos.length">
  <li v-for="todo in todos">
    {{ todo }}
  </li>
</ul>
<p v-else>No todos left!</p>
```

### 8.6 在组件上使用

#TODO https://cn.vuejs.org/v2/guide/list.html#%E5%9C%A8%E7%BB%84%E4%BB%B6%E4%B8%8A%E4%BD%BF%E7%94%A8-v-for
