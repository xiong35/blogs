# 给 absolute 元素加 margin 的问题

> 关键词: CSS

根据[文档](https://www.w3.org/TR/CSS21/visudet.html#abs-non-replaced-width), **绝对定位的**
非替换元素的位置和大小计算方式为:

```txt
'left' + 'margin-left' + 'border-left-width' + 'padding-left' + 'width' + 'padding-right' + 'border-right-width' + 'margin-right' + 'right' = width of containing block
```

那么什么是 containing block(CB) 呢? 根据[文档中的定义](https://www.w3.org/TR/CSS21/visudet.html#containing-block-details):

1. 根元素的 CB 为 initial CB, 由客户端决定如何实现. 我理解为[界面范围(page area)](https://www.w3.org/TR/CSS21/page.html#page-area)
2. 对于其他元素:
   1. 如果它是 `relative` 或者 `static` 定位, 其 CB 为其祖先中距离最近的`display`不为 `inline` 的
      元素的 **content box 边界**
   2. 如果它是 `fixed`, 其 CB 为界面范围
   3. 如果它是 `absolute`:
      1. 若它的祖先元素中由 `display` 属性不是 `static` 的, 则:
         1. 如果祖先元素是 inline 的, CB 即为祖先元素所有 inline 的孩子中第一个孩子的 padding 的左上边
            缘和最后一个孩子 padding 的右下边缘围成的范围. 在 css2.1 中, 如果此元素是跨行
            的, 则 CB 为 undefined(见*例 1*)
         2. 否则为祖先元素的 **padding box**
      2. 若不存在符合的祖先, 则 CB 为 initial CB

关于 `left`, `right`, `width` 等属性, 还有以下规则:

1. 若 `left`, `right`, `width`都是 `auto`, 则宽度紧缩, `left`贴边, `right`自动计算
2. 若三者均不为 `auto`
   1. 若左右`margin`均为`auto`, 根据等式计算剩余空间
      1. 若计算出的空间小于 0, 则设置`margin-left`为 0, `margin-right`自动计算
      2. 否则左右平分剩余空间
   2. 若两者之一为 `auto`, 计算之使其自动适应填充
   3. 若设置的值不能计算出合理的结果, 无视`right`的值并重新计算
3. 否则, 设置`margin`中为`auto`的方向为 0, 应用以下规则之一:
   1. `left`(`right`), `width`是`auto`且`right`(`left`)不是, 则宽度为紧缩宽度, 计算出`left`(`right`)
   2. `left`, `right`是`auto`且`width`不是
      1. 若父元素是非`inline`的, 则紧贴**content box**左上(见*例 2*)
      2. 若父元素是`inline`的, 则左边紧贴**padding box**左边缘, 垂直上以不遮挡其前方任何元素为前提尽可能向前贴(见*例 3*)
   3. 三者之二不是`auto`, 则计算出第三者

根据实践, 还有以下规则:

1. 设置`margin`值时其相对值为按照上述结果计算后的位置(见*例 4*)

---

举几个例子:

```html
<!-- 基础的 css 和 html 结构如下 -->
<div class="grand-father">
  <div class="father">
    <div class="son"></div>
  </div>
</div>

<style>
  .grand-father {
    background: red;
    padding: 10px;
    width: 300px;
    height: 300px;
  }
  .father {
    background: blue;
    padding: 10px;
    width: 200px;
    height: 200px;
  }
  .son {
    background: yellow;
    padding: 10px;
    height: 100px;
    width: 100px;
    position: absolute;
  }
</style>
```

在 Edge 96.0.1054.34 上, 其效果如下:

![initial](https://cdn.bbhust.hust.online/post/ab061acf-1e35-462b-9c46-5328cd6cac1b)

例 1: 若添加以下代码:

```html
<div class="grand-father">
  <div class="father">
    <span>123123</span>
    <span>123123</span>
    <span>123123</span>
    <div class="son"></div>
    <span>123123</span>
    <span>123123</span>
    <span>123123</span>
    <span>123123</span>
  </div>
</div>

<style>
  .father {
    position: relative;
    display: inline;
  }
  .son {
    opacity: 0.5;
    top: 0;
    right: 0;
  }
</style>
```

可见`top: 0;`相对的是第一个元素的左上, `right: 0;`相对的是最后一个元素的右下

![eg1](https://cdn.bbhust.hust.online/post/b4f9f07d-6212-4c90-a519-35512d6a5cff)

例 2: 代码不变即可见, `.son`的左上边缘紧贴`.father`的 content box

例 3: 增加以下代码:

```html
<div class="grand-father">
  <div class="father">
    <span>123123</span>
    <span>123123</span>
    <span style="background: pink">123123</span>
    <div class="son"></div>
    <span>123123</span>
    <span>123123</span>
    <span>123123</span>
    <span>123123</span>
  </div>
</div>

<style>
  .father {
    display: inline;
  }
  .son {
    opacity: 0.5;
  }
</style>
```

可见, 它以不遮挡粉色`span`为前提尽可能向上靠, 且左边紧贴 padding box

![eg3](https://cdn.bbhust.hust.online/post/7e7bb445-5458-4a6f-8c1a-fc351c73303f)

例 4: 若修改以下代码:

```html
<style>
  .father {
    position: relative;
  }
  .son {
    top: 0;
    margin: 10px;
  }
</style>
```

可见垂直上是`top 0 + margin 10px`, 水平上是`padding 10px + margin 10px`

![eg4](https://cdn.bbhust.hust.online/post/a89e7d9b-2ac8-4da4-89e4-c231459ea235)

最后总结一下, 啃了半天文档试了半天, 较为特殊的就是以上的例子了! 建议搞清楚, 项目中遇到这种奇妙的情况就不会摸不着头脑了!
