# Flutter 踩坑记录

> 关键词: Flutter, 踩坑记录

## app bar 的 leading icon

根据官方解释, leading 如果不设置是会进行自动推断的:

> If this is null and `automaticallyImplyLeading` is set to true, the `AppBar` will imply an appropriate widget. For example, if the `AppBar` is in a `Scaffold` that also has a `Drawer`, the `Scaffold` will fill this widget with an `IconButton` that opens the drawer (using `Icons.menu`). If there's no `Drawer` and the parent `Navigator` can go back, the `AppBar` will use a `BackButton` that calls `Navigator.maybePop`.

即, 如果设置了抽屉, leading 会变成打开抽屉的控制开关  
如果没有抽屉且当前路由界面**不是应用的首页**, 则会变成返回按钮  
如果都不是, 则为**空**

## 内置组件的手势冲突问题

使用`PageView`实现轮播图时, 想监听用户触摸以暂停轮播计时, 但是发现在外部无法监听到任何手势. 查阅[资料](https://book.flutterchina.club/chapter8/gesture.html)后发现 flutter 存在"手势竞争"的概念, 即当有多个手势识别器时, 可能会产生冲突, 只有一个被处理.

为了解决这个问题, 可以直接使用`GestureDetector`内部使用的组件: `Listener`, 用它监听原生的交互事件.

详见[flutter 实战](https://book.flutterchina.club/chapter8/gesture.html)

## 可滚动组件嵌套问题

在一个可滚动组件内还想嵌套使用可滚动组件时, 由于 flutter 内部实际是不确定可滚动组件的长度的, 而且还可能存在手势冲突问题, 所以会产生奇怪的 bug.

但是有时候就是有需求需要使用, 解决方案如下:

```dart
// 在内部可滚动组件里加入以下属性:
{
    /* ... */
    shrinkWrap: true,   // 自动收缩至最小, 使高度变为定值
    physics: NeverScrollableScrollPhysics(),    // 禁用滚动, 防止手势冲突
}
```

## flutter HMR 的坑

在新增查 package 的时候不能直接热重载, 而要重启整个项目

## flutter import 的问题

在 import 时路径分割不能用 `\` 或者`\\`, 必须用 `/`

## flutter 在真机调试时不能联网

首先要在 xml 文件里请求获得联网权限, 其次安卓端只能访问 https 网址, 不能使用 http
