
# 如何在html中操作剪切板

```js
let text = 'whatever';
let textArea = document.createElement("textarea");
textArea.style.zIndex = -1;
textArea.value = text;
document.body.appendChild(textArea);
textArea.select();
try {
    document.execCommand("copy");
} catch (err) {
    console.log("该浏览器不支持点击复制到剪贴板");
}
document.body.removeChild(textArea);
```

# 如何避免html换行时产生不必要的空格

```html
 <span>New York</span
 ><span>London</span
 ><span>Paris</span
 ><span>Bogota</span>
```

我以前一直觉得 prettier 这么做丑死了, 现在才知道他有这种深意QwQ

# 如何实现固定比例展示图片

```html
<body>
    <div class="container">
        <img src="foo.bar" />
    </div>
</body>

<style>
    .container {
        position: relative;
        padding-bottom: 75%;
        height: 0;
    }
    .container img {
        position: absolute;
        top: 0;
        width: 100%;
        height: 75%;
    }
</style>
```

解释:

- 设置`container`定位为`relative`是为例给子元素`img`提供`absolute`定位的基坐标  
- 设置`img`的`width: 100%; height: 100%;`是为了固定住长宽比例为4:3  
- 设置`container`的`padding-bottom: 75%; height: 0;`是为了将`img`的位置留出来, 且留的不多不少刚好是`img`的高度: 75% 的总宽度
