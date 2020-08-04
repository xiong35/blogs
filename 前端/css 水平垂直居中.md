
# css 水平垂直居中的 8 种方式

> 父子都已知宽高就不谈了, 直接讲未知宽高的情况

先看 html 代码:

```html
<div class="father" style="
    background-color: pink;
    position: relative; top: 0; left: 0;
    width: 200px; height: 200px;">
    <div class="son" style="
        background-color: red;
        width:100px; height:100px;">
    </div>
</div>
```

## 1 absolute + margin auto

已知子元素宽高时用这种贼简单+鲁棒

```css
.son {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    margin: auto;
}
```

## 2 absolute + transform

直接硬定位, 适用于任何场景, 缺点是兼容性不够好, 这是 css3 的特性

```css
.son {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}
```

## 3 lineheight

设置`line-height`为你想要的父组件总高度, 并且不设置`height`. 利用`text-align`设置水平居中, 利用`inline-block`属性设置子元素为内联, 这样才能撑起来`line-height`, 最后修正子元素的`text-align`

```css
.father {
    line-height: 300px;
    text-align: center;
    height: auto !important;
}

.son {
    display: inline-block;
    vertical-align: middle;
    text-align: left;
    /* 修正文字 */
}
```

## 4 writing-mode

这种方法实际是设置son元素的子元素水平垂直居中, son 本身只有垂直居中. 思路是: 先竖着写, 用一次`text-align`, 再横着写, 继续用一次, 不过son元素必须足够宽以撑满整个father, 才能让自己水平居中, 同时`height`也得刚好和里面的内容一样高

```css
.father {
    writing-mode: vertical-lr;
    text-align: center;
}

.son {
    display: inline-block;
    writing-mode: horizontal-tb;
    text-align: center;
    width: 100% !important;
    height: auto !important;
}
```

## 5 table

table 本身自带水平垂直居中,,,只要把东西放到 table 里即可, 这里就不细讲了, 比较简单, 用table就完事了. 而且这里的语义化不是很好, 代码冗余, 不推荐

## 6 css-table

原理同上, 但是是直接用的 css 属性`table-cell`

```css
.father {
    display: table-cell;
    text-align: center;
    vertical-align: middle;
}

.son {
    display: inline-block;
}
```

## 7 flex

优雅简洁! 但是兼容性有一丢丢问题

```css
.father {
    display: flex;
    justify-content: center;
    align-items: center;
}
```

## 8 grid

同样优雅简洁! 但是兼容性有更大的问题

```css
.father {
    display: grid;
}

.son {
    align-self: center;
    justify-self: center;
}
```


## 参考资料

- [CSS实现水平垂直居中的1010种方式（史上最全）](https://segmentfault.com/a/1190000016389031)