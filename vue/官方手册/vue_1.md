
# vue 学习笔记 1

## 3 模板语法

### 3.1 插值

#### 3.1.1 文本/html

纯文本/非响应式文本/原生html

```html
<span>Message: {{ msg }}</span>

<span v-once>这个将不会改变: {{ msg }}</span>

<p>Using v-html directive: <span v-html="rawHtml"></span></p>
```

注意, 不能使用 v-html 来复合局部模板

#### 3.1.2 attribute

```html
<div v-bind:id="dynamicId"></div>
<!-- 缩写 -->
<img :src="imageSrc">
```

#### 3.1.3 js

基本可以随便写...  
有个限制就是, 每个绑定都只能包含单个表达式, 所以下部分的例子都不会生效

```html
<!-- ok ↓ -->
{{ number + 1 }}

{{ ok ? 'YES' : 'NO' }}

{{ message.split('').reverse().join('') }}

<div v-bind:id="'list-' + id"></div>

<!-- not gonna work ↓ -->
<!-- 这是语句, 不是表达式 -->
{{ var a = 1 }}

<!-- 流控制也不会生效, 请使用三元表达式 -->
{{ if (ok) { return message } }}
```

就是说只能有**一个语句, 一行代码!**

关于全局变量: 只有特定变量可以访问, e.g : Math 和 Date

### 3.2 指令

以 "v-" 开头  
指令 attribute 的值预期是单个 JavaScript 表达式 (v-for 是例外情况)  
指令的职责是, 当表达式的值改变时, 将其产生的连带影响, 响应式地作用于 DOM

#### 3.2.1 参数

##### 3.2.1.1 静态参数

一些指令能够接收一个“参数”, 在指令名称之后以冒号表示。例如, v-bind 指令可以用于响应式地更新 HTML attribute:

```html
<a v-bind:href="url">...</a>
```

在这里 href 是参数, 告知 v-bind 指令将该元素的 href attribute 与表达式 url 的值绑定

另一个例子是 v-on 指令, 它用于监听 DOM 事件:

```html
<a v-on:click="doSomething">...</a>
```

在这里参数是监听的事件名

##### 3.2.1.2 动态参数

从 2.6.0 开始, 可以用方括号括起来的 JavaScript 表达式作为一个指令的参数: ```<a v-bind:[attributeName]="url"> ... </a>```
  
这里的 attributeName 会被作为一个 **JavaScript 表达式**进行动态求值, 求得的值将会作为最终的参数来使用

动态参数预期会求出一个字符串, 异常情况下值为 null。这个特殊的 null 值可以被显性地用于移除绑定。任何其它非字符串类型的值都将会触发一个警告。

动态参数表达式有一些语法约束, 因为某些字符, 如**空格**和**引号**, 放在 HTML attribute 名里是无效的。例如: ```<a v-bind:['foo' + bar]="value"> ... </a>```

#### 3.2.2 修饰符

修饰符 (modifier) 是以半角句号 "." 指明的特殊后缀, 用于指出一个指令应该以特殊方式绑定。例如: ".prevent" 修饰符告诉 v-on 指令对于触发的事件调用 event.preventDefault(): ```<form v-on:submit.prevent="onSubmit">...</form>```

### 3.3 缩写

#### 3.3.1 v-bind

```html
<!-- 完整语法 -->
<a v-bind:href="url">...</a>

<!-- 缩写 -->
<a :href="url">...</a>

<!-- 动态参数的缩写 (2.6.0+) -->
<a :[key]="url"> ... </a>
```

#### 3.3.2 v-on

```html
<!-- 完整语法 -->
<a v-on:click="doSomething">...</a>

<!-- 缩写 -->
<a @click="doSomething">...</a>

<!-- 动态参数的缩写 (2.6.0+) -->
<a @[event]="doSomething"> ... </a>
```

## 4 计算属性

对于任何复杂逻辑, 都应当使用计算属性, 以避免模板过于臃肿

e.g.

```html
<div id="example">
  <p>Original message: "{{ message }}"</p>
  <p>Computed reversed message: "{{ reversedMessage }}"</p>
</div>

var vm = new Vue({
  el: '#example',
  data: {
    message: 'Hello'
  },
  computed: {
    // 计算属性的 getter
    reversedMessage: function () {
      // `this` 指向 vm 实例
      return this.message.split('').reverse().join('')
    }
  }
})
```

可以像绑定普通属性一样在模板中绑定计算属性  

和直接调用vue对象的函数对比:  
计算属性是基于它们的响应式依赖进行缓存的。只在相关响应式依赖发生改变时它们才会重新求值。这就意味着只要 message 还没有发生改变，多次访问 reversedMessage 计算属性会立即返回之前的计算结果，而不必再次执行函数  
这也同样意味着下面的计算属性将不再更新，因为 Date.now() 不是响应式依赖:

```js
computed: {
  now: function () {
    return Date.now()
  }
}
```

各有优劣

### 4.1 侦听属性

尽量避免滥用watch, 改用计算属性:

```js
var vm = new Vue({
  el: '#demo',
  data: {
    firstName: 'Foo',
    lastName: 'Bar',
    fullName: 'Foo Bar'
  },
  watch: {
    firstName: function (val) {
      this.fullName = val + ' ' + this.lastName
    },
    lastName: function (val) {
      this.fullName = this.firstName + ' ' + val
    }
  }
})
<!-- 上面代码是命令式且重复的 -->
```

### 4.2 getter和setter

setter: 理解为重载赋值运算  
getter: @property

计算属性默认只有 getter，不过在需要时也可以提供一个 setter:

```js
computed: {
  fullName: {
    // getter
    get: function () {
      return this.firstName + ' ' + this.lastName
    },
    // setter
    set: function (newValue) {
      var names = newValue.split(' ')
      this.firstName = names[0]
      this.lastName = names[names.length - 1]
    }
  }
}
```

现在再运行```vm.fullName = 'John Doe'```时，setter 会被调用，vm.firstName 和 vm.lastName 也会相应地被更新

## 5 watch

```js
  watch: {
    // 如果 `question` 发生改变，这个函数就会运行
    question: function (newQuestion, oldQuestion) {
      this.answer = 'Waiting for you to stop typing...'
      this.debouncedGetAnswer()
    }
  },
```

question: 要监视的值
function: 如果发生变动执行的操作

#TODO [vm.$watch](https://cn.vuejs.org/v2/api/#vm-watch)