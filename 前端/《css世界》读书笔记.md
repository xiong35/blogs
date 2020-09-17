
# 《css世界》读书笔记

## 宽高尺寸

`width, height`属性默认作用在`content-box`上


### display: block

`display: block`的元素默认会*流动地*填充宽度, 不必也不要设置`width: 100%`, 这样反而会使得宽度布局不鲁棒

### display: inline

`display: inline`的元素具有*包裹性*, 其宽度根据内容长度自适应变化, 但是**一般不会超过包裹块宽度**

上文的"一般": 当包裹块宽度小于*首选最小宽度*时, 内联元素宽度以最小宽度为准

*首选最小宽度*: 中文一个字的宽度 / 英文最长单词宽度(以空格或连字符分割) / 替换元素本身的宽度

> 浮动元素和绝对定位也都有包裹性

### 宽度分离原则

当同时需要给一个组件设置`width, border, padding`时, 最佳实践是多加一个父级元素, 给他设置宽度, 再给自己设置其余属性. 这样子元素会自适应的**填满**父元素的空间, 而实际大小只由父元素设置的宽度决定

用这种方法替代`* { box-sizing: border-box; }`的好处在于, box-sizing 对 inline 元素是无效的, 会造成不必要的开销, 而且 box-sizing 不支持 border-box, 而分离的方法可以解决一切问题

### height: 100%

通常情况下, height 默认值为 aotu, 无法与百分数进行运算, 想要生效, 必须满足以下条件之一:

1. 父元素显示的设置了高度, **height 基于 content-box 计算**
2. 当前元素使用绝对定位(absolute), **height 基于 padding-box 计算**

## 替换元素的细节

1. img 如果只设置 width, height 会根据比例自动计算
2. 替换元素设置`display: block`不会让元素有流动性
3. 如果 img 没有 src 属性, 不同浏览器会做出不同解释, 导致大小表现统一. 可以设置`display: inline-block`和 width 属性来统一指定
4. 替换元素的**固有尺寸无法修改, 看起来被修改了只是因为有默认的`object-fit: fill`属性
5. `object-fit: contain`属性+定宽高 可以实现图片自适应居中效果
6. img 在没有 src 属性时表现为**非替换元素**, 可以使用`::before, ::after`等伪元素:
   
   ```css
   /* 更好看的 alt 显示 */
   img::after {
       content: attr(alt);
       position: absolute;
       bottom: 0;
       width: 100%;
       background-color: rgba(0, 0, 0, 0.5);
   }
   ```

7. 设置 img 的 conmtent 属性等同于设置 src, 如`content: src(xxx)`, 可以利用这个实现 hover 改变图片之类的效果
8. **替换元素和非替换元素的距离只有`src`和`content`属性**

## counter 计数器

1. `counter-reset: NAME INIT-NUM [NAME INIT...]`: 初始化一个计数器, INIT-NUM 最好是自然数
2. `counter-increment: NAME [VAL]`, 改变计数器的值, VAL 默认为 1, 支持负数
3. `content: counter(NAME, STYLE) 'foo'`: 利用 content 显示 计数器的值, 这里的 counter **仅有**显示值的作用. 支持字符串拼接, 用空格分隔
4. **`counters`**的用法: (详见[书上的demo](https://demo.cssworld.cn/4/1-18.php)和[知乎回答](https://zhuanlan.zhihu.com/p/61688767))

    ```css
    ol {
        counter-reset: ol-list;
    }
    li:before {
        counter-increment: ol-list;
        content: counters(ol-list, "-" [, STYLE]);
    }
    ```

## margin

### margin 合并

只发生在以下条件下

1. 块级元素(不包括浮动和绝对定位元素)
2. 垂直方向

情况有以下几种:

1. 兄弟元素间
2. 父元素和第一个/最后一个子元素8
3. 空元素的上下 margin

> 可通过`overflow: hidden`或者设置来阻止合并

### margin: auto

> 触发条件: 假设去掉对应方向的宽/高, 元素有对应方向的自动填充特性

如果一边是定值, 另一边是 auto, 则 auto **自动填充**剩余空间(tip: 由于 maigin 默认是0, 可用这个特性实现左/右对齐)  
如果两边都是 auto, 则平分剩余空间

### margin的tips

1. **内联非替换元素**的垂直 margin 无效
2. **内联替换元素**的垂直 margin 不会合并
3. *table-cell, table-row* 的 margin 无效
4. *table-caption, table, inline-table, :first-letter* 可设置 margin
5. 内联特性导致 margin 无效 // TODO, 见 p99, (7)

## vertical-align

`vertical-align` 属性支持 正/负 数值/百分比(相对于`line-height`), 可以精细且兼容性良好的控制 inline 元素的垂直位置

只作用于 inline 元素上, 且不作用于浮动和绝对定位的元素(因为这会让元素块状化)

当设置无效时检查一下 line-height 是否过小, 且注意此属性是**作用于设置的对象**(而非子元素)上的

`vertical-align: middle`: 元素的垂直中心点和行框盒子基线往上 0.5 x-height 处对齐

## overflow

`overflow: hidden` 可以创建 BFC 结界, 无论内部如何调整都不会影响外部布局, 同时保留元素的流动延伸性

## 无依赖绝对定位

当**仅**设置元素为`position: absolute`时(即不设置父元素 relative, 不设置 left, top 等), 元素默认紧接在上一段文字后, 可通过 margin 来控制具体位置

text-align 会影响幽灵空白节点, 从而影响绝对定位元素的位置

所谓**依赖**, 实际是与元素 display 有关的. 内联元素依赖文字, 从而在文字后显示, 块级元素不依赖文字, 而是依赖上一个块状元素(可以通过 `:before` 来让他依赖文字)

## 层叠

> z-index 只作用于**定位元素**上和 flex 盒子的子元素上

![css2的层叠顺序](https://s1.ax1x.com/2020/09/17/wWN0ds.jpg)

当 z-index 为 **auto** 时, **不会**创造层叠上下文, 即兄弟元素的子元素的层叠顺序由各自的 z-index 指定.  
一旦 z-index 不为 auto 或者满足*以下条件*之一(实际上是自动应用了 auto)时, 将按照 z-index 优先, 出现顺序次之的考虑顺序排列, 可能就会出现后面的元素永远无法覆盖前面元素的问题

条件:

1. opacity 不为 1
2. transform 不是 none
3. mix-blend-mode 不是 normal
4. filter 不是 none

> 所以应用透明度变化时, 要注意 opacity 非 1 时的层级变化问题

当设置 display 为定位元素时, **z-index 自动生效**, 为 auto, 会天然高于非定位元素

设置 z-index 为负值时, 会向上寻找最近的一个由层叠上下文的(即设置了 z-index的)元素, 并止步于此

## 元素显隐

| \\           | opacity | visibility | display |
| ------------ | ------- | ---------- | ------- |
| 占据空间     | 1       | 1          | 0       |
| 子元素能显示 | 0       | 1          | 0       |
| 能触发事件   | 1       | 0          | 0       |
| 能阻挡点击   | 1       | 0          | 0       |
| 支持渐变     | 1       | 0.5        | 0       |



## tips

- 勤用`:after, :before`伪元素
- 利用 padding 不会影响内联元素布局的特点, 增加 按钮/超连接 的点击区域大小
- 可用 label + for 在保留按钮功能的同时自定义按钮样式
- 遍历生成列表的时候如果每个元素项目都加 `margin-right`, 每行的最后一项会多出一个 margin, 可以通过设置父元素`maigin-right: - MARGIN px`来消除之
- `border-color` 默认为当前 color 的值(currentColor)
- 注意内联元素前的 "幽灵空白节点"
- **`inline-block`元素里, 如果里面没有内联元素或者`overflow`不是`visible`, 则该元素的基线是`maigin`下边缘, 否则是最后一行内联元素的基线位置**(p135)
- 修改滚动条: p169
- 可利用`href="#"实现返回顶部`, 也可以利用锚点实现选项卡切换等功能
- 多用 clip
- relative 尽量只设置在需要的元素上, 而不影响别的元素. 必要时可以单独用 div 包住要设置的元素
- 善用 `text-tramsform: uppercase`
- 善用 hsl(hue, saturate, lightness)
- 善用`direction: rtl`
- 善用`text-overflow: ellipsis`