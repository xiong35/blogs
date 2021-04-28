
# vue 学习笔记

## 10 表单输入绑定

可以用 v-model 指令在表单 \<input\>、\<textarea\> 及 \<select\> 元素上创建双向数据绑定。它会根据控件类型自动选取正确的方法来更新元素

被绑定的元素的初始值将不受原有设置影响, 而完全取决于Vue的初始值

v-model 在内部为不同的输入元素使用不同的属性并抛出不同的事件

- text 和 textarea 元素使用 value 属性和input 事件；
- checkbox 和 radio 使用 checked 属性和change 事件；
- select 字段将 value 作为 prop 并将 change作为事件。

### 10.1 字面量绑定

```html
<!-- 单行文本 -->
<input v-model="message" placeholder="edit me">
<p>Message is: {{ message }}</p>

<!-- 多行文本 -->
<span>Multiline message is:</span>
<p style="white-space: pre-line;">{{ message }}</p>
<br>
<textarea v-model="message" placeholder="add multiple lines"></textarea>

<!-- 单个复选框 -->
<input type="checkbox" id="checkbox" v-model="checked">
<label for="checkbox">{{ checked }}</label>

<!-- 多个复选框, 绑定到数组 -->
<div id='example-3'>
  <input type="checkbox" id="jack" value="Jack" v-model="checkedNames">
  <label for="jack">Jack</label>
  <input type="checkbox" id="john" value="John" v-model="checkedNames">
  <label for="john">John</label>
  <input type="checkbox" id="mike" value="Mike" v-model="checkedNames">
  <label for="mike">Mike</label>
  <br>
  <span>Checked names: {{ checkedNames }}</span>
</div>

<!-- 单选按钮, 绑定的是value -->
<div id="example-4">
  <input type="radio" id="one" value="One" v-model="picked">
  <label for="one">One</label>
  <br>
  <input type="radio" id="two" value="Two" v-model="picked">
  <label for="two">Two</label>
  <br>
  <span>Picked: {{ picked }}</span>
</div>

<!-- 选择框同理 -->

<!-- 和for结合 -->
<select v-model="selected">
  <option v-for="option in options" v-bind:value="option.value">
    {{ option.text }}
  </option>
</select>
<span>Selected: {{ selected }}</span>

new Vue({
  el: '...',
  data: {
    selected: 'A',
    options: [
      { text: 'One', value: 'A' },
      { text: 'Two', value: 'B' },
      { text: 'Three', value: 'C' }
    ]
  }
})
```

### 10.2 变量绑定

```html
<input type="radio" v-model="pick" v-bind:value="a">

// 当选中时
vm.pick === vm.a

<select v-model="selected">
    <!-- 内联对象字面量 -->
  <option v-bind:value="{ number: 123 }">123</option>
</select>

// 当选中时
typeof vm.selected // => 'object'
vm.selected.number // => 123
```

### 10.3 修饰符

```html
<!-- 在“change”时而非“input”时更新 -->
<input v-model.lazy="msg">

<!-- 寻常type=number得到的输入还是字符串, 加了.number自动转换为数字 -->
<input v-model.number="age" type="number">

<input v-model.trim="msg">
```

#TODO 在组件上使用v-model https://cn.vuejs.org/v2/guide/forms.html#%E5%9C%A8%E7%BB%84%E4%BB%B6%E4%B8%8A%E4%BD%BF%E7%94%A8-v-model