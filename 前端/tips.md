
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