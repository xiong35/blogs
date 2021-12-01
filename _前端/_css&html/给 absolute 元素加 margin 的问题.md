# 给 absolute 元素加 margin 的问题

> 关键词: CSS

定义:

根据[文档](https://www.w3.org/TR/CSS21/visudet.html#abs-non-replaced-width), 绝对定位的非替换元素的位置和大小计算方式为:

```txt
'left' + 'margin-left' + 'border-left-width' + 'padding-left' + 'width' + 'padding-right' + 'border-right-width' + 'margin-right' + 'right' = width of containing block
```

那么什么是 containing block 呢? 根据[文档中的定义](https://www.w3.org/TR/CSS21/visudet.html#containing-block-details), CB 即为

1. 根元素的 CB 为 [界面范围(page area)](https://www.w3.org/TR/CSS21/page.html#page-area)
2. 对于其他元素:
   1. 如果它是 `relative` 或者 `static` 定位, 其 CB 为其祖先中距离最近的`display`为 `block`, `inline-block`, `table-cell`, `list-item` // TODO 的元素的 content box 边界
   2. 如果它是 `fixed`, 其 CB 为界面范围
   3. 如果它是 `absolute`:
      1. 如果祖先元素是 inline 的:
         1. CB 即为// TODO
