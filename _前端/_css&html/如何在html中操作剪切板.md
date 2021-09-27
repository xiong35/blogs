# 如何在 html 中操作剪切板

> 前端杂记

```js
let text = "whatever";
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
