
# vue 学习笔记

## 14 自定义事件

### 14.1 自定义v-model

一个组件上的 v-model 默认会利用名为 value 的 prop 和名为 input 的事件, 但是像单选框、复选框等类型的输入控件可能会将 value attribute 用于不同的目的。model 选项可以用来避免这样的冲突:

```js
Vue.component('base-checkbox', {
  model: {
    prop: 'checked',
    event: 'change'
  },
  props: {
    checked: Boolean
  },
  template: `
    <input
      type="checkbox"
      v-bind:checked="checked"
      v-on:change="$emit('change', $event.target.checked)"
    >
  `
})
```

现在在这个组件上使用 v-model 的时候: ```<base-checkbox v-model="lovingVue"></base-checkbox>```  
这里的 lovingVue 的值将会传入这个名为 checked 的 prop。同时当 \<base-checkbox\> 触发一个 change 事件并附带一个新的值的时候，这个 lovingVue 的属性将会被更新  
注意你仍然需要在组件的 props 选项里声明 checked 这个 prop

### 14.2 绑定原生事件

e.g:

```html
<base-input v-on:focus.native="onFocus"></base-input>
```

#TODO https://cn.vuejs.org/v2/guide/components-custom-events.html#%E5%B0%86%E5%8E%9F%E7%94%9F%E4%BA%8B%E4%BB%B6%E7%BB%91%E5%AE%9A%E5%88%B0%E7%BB%84%E4%BB%B6
但是如果根元素不是事件的直接接收者, 如下:

```html
<label>
  {{ label }}
  <input
    v-bind="$attrs"
    v-bind:value="value"
    v-on:input="$emit('input', $event.target.value)"
  >
</label>
```

### 14.3 sync

#TODO https://cn.vuejs.org/v2/guide/components-custom-events.html#sync-%E4%BF%AE%E9%A5%B0%E7%AC%A6

## 15 插槽

### 15.1 基本用法

```html
<navigation-link url="/profile">
  Your Profile
</navigation-link>
<!-- 在 <navigation-link> 的模板中可能会写为 -->
<a
  v-bind:href="url"
  class="nav-link"
>
  <slot></slot>
</a>
<!-- 当组件渲染的时候，<slot></slot> 将会被替换为“Your Profile -->

<!-- 包含标签/html都是可以的 -->
<navigation-link url="/profile">
  <!-- 添加一个图标的组件 -->
  <font-awesome-icon name="user"></font-awesome-icon>
  Your Profile
</navigation-link>
```

如果 \<navigation-link\> 没有包含一个 \<slot\> 元素，则该组件起始标签和结束标签之间的任何内容都会被抛弃

### 15.2 作用域

```html
<navigation-link url="/profile">
  Clicking here will send you to: {{ url }}
  <!--
  这里的 `url` 会是 undefined，因为 "/profile" 是
  _传递给_ <navigation-link> 的而不是
  在 <navigation-link> 组件*内部*定义的。
  -->

  <!-- 但是这样的就可以 -->
  {{ something_from_father }}
</navigation-link>
```

### 15.3 默认值

在子类两个slot标签间加默认值

### 15.4 具名插槽

```html
<!-- 子类中 -->
<div class="container">
  <header>
    <slot name="header"></slot>
  </header>
  <main>
    <!-- 一个不带 name 的 <slot> 出口会带有隐含的名字“default” -->
    <slot></slot>
  </main>
  <footer>
    <slot name="footer"></slot>
  </footer>
</div>

<!-- 父类中 -->
<base-layout>
  <template v-slot:header>
    <h1>Here might be a page title</h1>
  </template>

  <p>A paragraph for the main content.</p>
  <p>And another one.</p>
  <!-- ↑ 等价于 ↓
  <template v-slot:default>
    <p>A paragraph for the main content.</p>
    <p>And another one.</p>
  </template> -->

  <template v-slot:footer>
    <p>Here's some contact info</p>
  </template>
</base-layout>
```

除了作用域插槽之外, v-slot 只能添加在 \<template\> 上 

### 15.5 作用域插槽

```html
<!-- 默认内容为 -->
<span>
  <slot>{{ user.lastName }}</slot>
</span>

<!-- 想修改为 -->
<current-user>
  {{ user.firstName }}
</current-user>
```

上述代码是**错误的**, 因为我们提供的内容是在父级渲染的

为了让 user 在父级的插槽内容中可用，我们可以**在子级中**将 user 作为 \<slot\> 元素的一个 attribute 绑定上去

```html
<!-- 子级 -->
<span>
  <slot v-bind:user="user">
    {{ user.lastName }}
  </slot>
</span>

<!-- 父级 -->
<current-user>
  <template v-slot:default="myAttrs">
    {{ myAttrs.user.firstName }}
  </template>
</current-user>
<!-- ↑ 都可以 ↓ -->
<current-user v-slot="slotProps">
  {{ slotProps.user.firstName }}
</current-user>
```

父级收到的是子级模板里传递的**所有参数**构成的对象

```html
<div id="app">
    <child :czip="pzip">
        <template #default="attrs">
            {{attrs.pass.a}}
            <br>
            {{attrs.passa}}
        </template>
    </child>
</div>

<div>
    <slot :pass="czip" :passa="czip.a">
    </slot>
</div>
```

只要出现多个插槽，请始终为所有的插槽使用完整的基于 \<template\> 的语法

```html
<current-user>
  <template v-slot:default="slotProps">
    {{ slotProps.user.firstName }}
  </template>

  <template v-slot:other="otherSlotProps">
    ...
  </template>
</current-user>
```

### 15.6 动态插槽名

```html
<base-layout>
  <template v-slot:[dynamicSlotName]="balabala">
    ...
  </template>
</base-layout>
```

### 15.7 缩写

```html
<base-layout>
  <template #header>
    <h1>Here might be a page title</h1>
  </template>

  <p>A paragraph for the main content.</p>
  <p>And another one.</p>

  <template #footer>
    <p>Here's some contact info</p>
  </template>
</base-layout>

<current-user #default="user">
  {{ user.firstName }}
</current-user>

<!-- 或: -->
<base-layout>
  <h1 slot="header">Here might be a page title</h1>

  <p>A paragraph for the main content.</p>
  <p>And another one.</p>

  <p slot="footer">Here's some contact info</p>
</base-layout>
```
