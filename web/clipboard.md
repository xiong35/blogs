
# 如何在html中操作剪切板

```js
navigator.clipboard.writeText("some text")).then(function() {
/* clipboard successfully set */
}, function() {
/* clipboard write failed */
});
```

具体见[这里](https://developer.mozilla.org/zh-CN/docs/Web/API/Document/execCommand)