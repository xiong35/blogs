
# shadow dom

## 它是什么?

传统 DOM 是对全局暴露的, 无论是 js 还是 css 都总有办法获得/修改他. 为了更好的封闭组件, 为了封装一些功能/样式, shadow dom 被引入了. e.g:

1. `video`, `range`等元素有自己的样式和功能, 就是使用了 shadow dom
2. 为了避免元素样式被其他样式修改/覆盖, 可以创建 shadow dom 来进行封装

shadow dom 是用特殊 api 创建出来的 dom 树(见下文), 他需要在正常 dom 树上选取一个元素进行挂载, 这颗新的 dom 树和原来的树互相隔绝(可以理解为创建了新的作用域)

shadow dom 中的元素无法被访问, css 样式几乎无法修改, 事件对象被移交给宿主元素

## 创建与使用

```html
<span class="shadow-host">
    <a href="https://twitter.com/ireaderinokun">
    Follow @ireaderinokun
    </a>
</span>
```

```js
const shadowEl = document.querySelector(".shadow-host") // 获取宿主
// 宿主中可以放退化样式/元素作为不支持 shadow dom / js 时的备选方案
const shadow = shadowEl.attachShadow({mode: 'open'})    // 创建

// 创建子元素
const link = document.createElement("a")
link.href = shadowEl.querySelector("a").href
link.innerHTML =`
    <span aria-label="Twitter icon"></span>
    ${shadowEl.querySelector("a").textContent}
`
shadow.appendChild(link);   // 并插入


// 创建 style 元素以设置样式
const styles = document.createElement("style");
styles.textContent = `
a, span {
  vertical-align: top;
  display: inline-block;
  box-sizing: border-box;
}

a:hover {  background-color: #0c7abf; }

span {
    position: relative;
    top: 2px;
    width: 14px;
    height: 14px;
    margin-right: 3px;
    background: transparent 0 0 no-repeat;
}
/* more styles */
`
shadow.appendChild(styles)  // 并插入
```

## 对 shadow dom 内部的访问

通过某些特定的 api 可以访问, 但是兼容性不好

```css
video::-webkit-media-controls-panel{
    display:flex!important;
    background-color: deeppink;
}
```

## 参考资料

- [神秘的 shadow-dom 浅析](https://www.cnblogs.com/coco1s/p/5711795.html)
- [\[译\]什么是Shadow Dom？](https://www.toobug.net/article/what_is_shadow_dom.html)
- [什么是Shadow DOM？](https://segmentfault.com/a/1190000017970486)