
# Chromium 调试指南

## 保存变量值

调试过程中有可能会需要将一些变量值保存下来, 这时候只要在想要保存的变量上点击右键, 选择`Store as global variable`, 就可以在Console面板里使用这个变量(`temp1, temp2, temp3, ...`)

![save_as_global](https://s3.ax1x.com/2021/03/10/6GOJIO.png)

## 模拟元素状态

有时候我们会为元素的 hover 设置一个样式, 但是调试的时候只有把鼠标移上去才能看见样式, 很麻烦.

Chrome 里可以直接模拟这种状态

![force_class](https://s3.ax1x.com/2021/03/10/6GOuRJ.png)

## 录制屏幕

Chrome 提供了录屏功能, 可以录制页面的整个加载过程, 方便检查分析

![capture_images](https://s3.ax1x.com/2021/03/10/6GO1qx.png)

## Copy as Curl

如果要在命令行/ console 中模拟 Http 操作的话, 可以直接在 NetWork 面板中点右键, 复制为

![copy_as_curl](https://s3.ax1x.com/2021/03/10/6GOls1.png)

## 样式微调

通过 带有 或者 不带有修饰键的 上 / 下 箭头按键, 可以实现让 css 数值递增和递减 0.1, 1 或者 10 这样数值类型的值:

- 不带修饰: ±1
- 按住 alt: ± 0.1
- 按住 shift: ± 10
- 按住 ctrl: ± 100

## command list

按下 `ctrl+shift+p`, 打开新世界大门!

## async 的 console

console 自带 `async` 包裹, 可以直接写 `await` 语句!

## 更好的 `console`

- `console.assert`: 接受两个参数, 若第一个参数为 falsy, 则打印第二个. `console.assert(a === b, "Error: a!==b")`
- `console.table`: `console.table` 接受 数组 或是 类数组的对象 或是 一个对象, 将其打印成一个漂亮的表格! 它不仅会根据数组中包含的对象的所有属性, 去计算出表中的列名, 而且这些列都是可以 缩放 甚至 还可以排序!!!`console.table({name, url, chapter})`
- 加上 css 样式: 如果给打印文本加上 `%c` 那么 `console.log` 的第二个参数就变成了 CSS 规则: `console.log('%c foobar', 'background: #222; color: #FFF; font-size: 3rem');`

## console 里的内置函数/对象

- `$`: 相当于`querySelect`函数, 参数为querySelect的字符串, 返回值为 dom 节点
- `$$`: 相当于`querySelectAll`函数, 用法同上
- `$_`: 返回上一个 console 中运行语句的返回值
- `$0, $1, $2 ...`: 返回当前/上一个/上两个被聚焦到的 dom 节点
- `copy`: 接受任意参数, 将他 json 序列化后复制到电脑剪切板(仅处理可被序列化的部分, 如, 会忽视函数)
- `monitor`: 接受函数作为参数, 调用后监视指定函数, 函数每次调用都会打印相关信息(执行 `unmonitor(fn)` 可以停止对某一个函数的监控), 注意, 只能监视 function, **不能监视箭头函数**
- `monitorEvents`: 可监控对象上的事件, 如
  - `monitorEvents(window, "resize");`
  - `monitorEvents(window, ["resize", "scroll"])`
  - `monitorEvents($0, "key");`

| 类型    | 事件                                                                                            |
| ------- | ----------------------------------------------------------------------------------------------- |
| mouse   | "mousedown", "mouseup", "click", "dblclick", "mousemove", "mouseover", "mouseout", "mousewheel" |
| key     | "keydown", "keyup", "keypress", "textInput"                                                     |
| touch   | "touchstart", "touchmove", "touchend", "touchcancel"                                            |
| control | "resize", "scroll", "zoom", "focus", "blur", "select", "change", "submit", "reset"              |

## Dom, style

### Dom 断点

右键点击 dom 元素, 选择`break on`, 即可在指定情境下插入断点

### picker

许多样式支持使用 picker 微调. 在样式界面里点击设置的样式的最前面那个小方块, 即可打开 picker 面板

![shadow_picker](https://s3.ax1x.com/2021/03/10/6GOURH.png)

![animation_picker](https://s3.ax1x.com/2021/03/10/6GOwQA.png)



## 更多工具

在面板里还能找到更多工具! 

![more_tools](https://s3.ax1x.com/2021/03/10/6GOQMR.png)

- 可以逐帧调试动画的 Animations

![animation](https://s3.ax1x.com/2021/03/10/6GOazd.png)

- 方便调试 z-index 的 3d 视图

![z-index](https://s3.ax1x.com/2021/03/10/6GONJe.png)

- 方便 mock 地点/状态等的 传感器

![sensor](https://s3.ax1x.com/2021/03/10/6GOGdK.png)

- 详细的性能监控

![performance](https://s3.ax1x.com/2021/03/10/6GO8Z6.png)

## css overview

可以打开 settings 里的 Experiment 选项中的 css overview, 来查看界面的 css 总结

![settings](https://s3.ax1x.com/2021/03/10/6GOtiD.png)

![css_overview](https://s3.ax1x.com/2021/03/10/6GOKz9.png)

## 参考

- [dev tips](https://umaar.com/dev-tips/)
- [Chrome高阶调试指南](https://zhuanlan.zhihu.com/p/62177097)
- [Chrome调试技巧](https://www.frontendwingman.com/Chrome/)
