
# vue 学习笔记

## 11 组件基础

### 11.1 示例

```js
// 定义一个名为 button-counter 的新组件
Vue.component('button-counter', {
  data: function () {
    return {
      count: 0
    }
  },
  template: '<button v-on:click="count++">You clicked me {{ count }} times.</button>'
})
```

组件是可复用的 Vue 实例，且带有一个名字：在这个例子中是 \<button-counter\>。我们可以在一个通过 new Vue 创建的 Vue 根实例中，把这个组件作为自定义元素来使用:

```html
<div id="components-demo">
  <button-counter></button-counter>
</div>

new Vue({ el: '#components-demo' })
```

因为组件是可复用的 Vue 实例，所以它们与 new Vue 接收相同的选项，例如 data、computed、watch、methods 以及生命周期钩子等。仅有的例外是像 el 这样根实例特有的选项

每用一次组件，就会有一个它的新实例被创建, 互不干扰  
一个组件的 data 选项必须是一个函数，因此每个实例可以维护一份被返回对象的独立的拷贝

### 11.2 组件的组织/注册简介

通常一个应用会以一棵嵌套的组件树的形式来组织  

例如，你可能会有页头、侧边栏、内容区等组件，每个组件又包含了其它的像导航链接、博文之类的组件

为了能在模板中使用，这些组件必须先注册以便 Vue 能够识别。这里有两种组件的注册类型：全局注册和局部注册

全局注册的组件可以用在其被注册之后的任何 (通过 new Vue) 新创建的 Vue 根实例，也包括其组件树中的所有子组件的模板中

### 11.3 向子组件传递数据-基础

```js
Vue.component('blog-post', {
  props: ['title'],
  template: '<h3>{{ title }}</h3>'
})
```

一个组件默认可以拥有任意数量的 prop，任何值都可以传递给任何 prop。在上述模板中，你会发现我们能够在组件实例中访问这个值，就像访问 data 中的值一样

一个 prop 被注册之后，你就可以像这样把数据作为一个自定义 attribute 传递进来:

```html
<blog-post title="My journey with Vue"></blog-post>
<blog-post title="Blogging with Vue"></blog-post>
<blog-post title="Why Vue is so fun"></blog-post>
```

如果是数组, 可以这样传参:

```html
<blog-post
  v-for="post in posts"
  :key="post.id"
  :title="post.title"
></blog-post>
```

此外, 将prop作为对象传递, 通过调用属性来获取数据, 是一种更简洁的写法, 参考以下代码:

```html
<blog-post
  v-for="post in posts"
  :key="post.id"
  :title="post.title"
  :content="post.content"
  :publishedAt="post.publishedAt"
  :comments="post.comments"
></blog-post>

<!-- vs -->

<blog-post
  v-for="post in posts"
  v-bind:key="post.id"
  v-bind:post="post"
></blog-post>
```

### 11.4 自定义事件/监听

```html
<button>
  Enlarge text
</button>
<!-- 当点击这个按钮时，我们需要告诉父级组件放大所有博文的文本 -->

<!-- 子级通过$emit方法触发事件 -->
<button v-on:click="$emit('enlarge-text')">
  Enlarge text
</button>

<!-- 父级监听这个事件 -->
<blog-post
  ...
  v-on:enlarge-text="postFontSize += 0.1"
></blog-post>


<!-- 还可以带参数 -->
<button v-on:click="$emit('enlarge-text', 0.1)">
  Enlarge text
</button>
<!-- 用$event捕获 -->
<blog-post
  ...
  v-on:enlarge-text="postFontSize += $event"
></blog-post>
<!-- 如果是一个方法, 这将成为他的第一个参数 -->
```

