
# vue 学习笔记 2

## 6 特殊绑定: class/style

操作元素的 class 列表和内联样式是数据绑定的一个常见需求。因为它们都是属性，所以我们可以用 v-bind 处理它们: 只需要通过表达式计算出字符串结果即可。不过，字符串拼接麻烦且易错。因此，在将 v-bind 用于 class 和 style 时，Vue.js 做了专门的增强。表达式结果的类型除了字符串之外，还可以是对象或数组

### 6.1 class

我们可以传给 v-bind:class 一个对象，以动态地切换 class：```<div v-bind:class="{ active: isActive }"></div>```  
上面的语法表示 active 这个 class 存在与否将取决于数据属性 isActive 的 truthiness  
> (truthy(真值)指的是在布尔值上下文中，转换后的值为真的值。所有值都是真值，除非它们被定义为 假值(即除 false、0、""、null、undefined 和 NaN 以外皆为真值))

可以在对象中传入更多属性来动态切换多个 class。此外，v-bind:class 指令也可以与普通的 class 属性共存

```html
<div
  class="static"
  v-bind:class="{ active: isActive, 'text-danger': hasError }"
></div>
```

也可以直接传递一个对象: ```<div class="static active"></div>```  
还可以传递一个返回对象的计算属性/方法

还可以指定为数组: ```<div v-bind:class="[activeClass, errorClass]"></div>```

组合使用也是可以的: ```<div v-bind:class="[{ active: isActive }, errorClass]"></div>```

用在组件上: # TODO https://cn.vuejs.org/v2/guide/class-and-style.html#%E7%94%A8%E5%9C%A8%E7%BB%84%E4%BB%B6%E4%B8%8A

### 6.2 style

v-bind:style 的对象语法十分直观——看着非常像 CSS，但其实是一个 JavaScript 对象。CSS 属性名可以用驼峰式 (camelCase) 或短横线分隔 (kebab-case，记得用引号括起来) 来命名: ```<div v-bind:style="{ color: activeColor, fontSize: fontSize + 'px' }"></div>```  
也可以传递对象, 其中**属性不用引号**  
多个对象可以放到数组里  
**会自动兼容浏览器**

## 7 条件渲染

指v-if/v-show

### 7.1 if

v-if 指令用于条件性地渲染一块内容。这块内容只会在指令的表达式返回 truthy 值的时候被渲染

```html
<div v-if="Math.random() > 0.5">
  Now you see me
</div>
<div v-else>
  Now you don't
</div>
```

v-else 元素必须紧跟在带 v-if 或者 v-else-if 的元素的后面，否则它将不会被识别

#### tip: 用key管理复用元素

```html
<!-- 这种情况, 两个输入框会共用输入, 因为他们被简化渲染了 -->
<template v-if="loginType === 'username'">
  <label>Username</label>
  <input placeholder="Enter your username">
</template>
<template v-else>
  <label>Email</label>
  <input placeholder="Enter your email address">
</template>

<!-- 加入key之后就可以指定他们是独立的 -->
<template v-if="loginType === 'username'">
  <label>Username</label>
  <input placeholder="Enter your username" key="username-input">
</template>
<template v-else>
  <label>Email</label>
  <input placeholder="Enter your email address" key="email-input">
</template>
```

### 7.2 show

与if类似, 不同的是带有 v-show 的元素始终会被渲染并保留在 DOM 中。v-show 只是简单地切换元素的 CSS 属性 display

注意，v-show 不支持 <template> 元素，也不支持 v-else

### 7.3 对比

v-if 是“真正”的条件渲染，因为它会确保在切换过程中条件块内的事件监听器和子组件适当地被销毁和重建

v-if 也是惰性的：如果在初始渲染时条件为假，则什么也不做——直到条件第一次变为真时，才会开始渲染条件块

相比之下，v-show 就简单得多——不管初始条件是什么，元素总是会被渲染，并且只是简单地基于 CSS 进行切换

一般来说，v-if 有更高的切换开销，而 v-show 有更高的初始渲染开销。因此，如果需要非常频繁地切换，则使用 v-show 较好；如果在运行时条件很少改变，则使用 v-if 较好

#TODO:查看风格指南 https://cn.vuejs.org/v2/style-guide/#%E9%81%BF%E5%85%8D-v-if-%E5%92%8C-v-for-%E7%94%A8%E5%9C%A8%E4%B8%80%E8%B5%B7%E5%BF%85%E8%A6%81
