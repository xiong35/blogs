
# 初探 vue render函数

有一个需求是在 vue 中动态选择要展示的组件, 同时在点击时隐藏整个组件,
使用 template 很难动态选择组件, 而一开始用 render 函数也不知道怎么使用`v-show`
理清楚后特此记录

```jsx
render() {
  const dialogVNode = h(
    UseMenu,  // 父组件的盒子
    {
      onCancel: () => (showActions.value = false),  // prop传回调
    },
    () => h(char2Action[character.value] ?? "div")  // 动态渲染子组件
  );
  // `withDirectives`可以使用`v-show`
  //    第一个参数接受要包装的元素
  //    第二个接受一个`DirectiveArguments`数组, 每个`DirectiveArguments`是一个多元组
  // 其中`vShow`是从 vue 中引入的
  return withDirectives(dialogVNode, [[vShow, showActions.value]]);
},
```
