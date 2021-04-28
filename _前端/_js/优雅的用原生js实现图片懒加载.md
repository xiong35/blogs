
# 优雅的用原生js/css实现图片懒加载

## 懒加载原理

对所有页面中的图片, 先不设置 src 属性, 转而将地址设为`data-src`, 等需要加载时再将 src 属性设置为地址  

如何判断何时需要加载: 利用以下三个属性

- `document.documentElement.scrollTop`: 页面滚到窗口上方的距离
- `document.documentElement.clientHeight`: 窗口高度
- `<el>.offsetTop`: 某个html元素顶部距离页面顶部的距离

利用`offsetTop-scrollTop-clientHeight > 0`判断图片是否进入页面. 如下图:

![load_condition](https://s1.ax1x.com/2020/07/11/UQu8Dx.jpg)

所以只要在界面滚动时利用上述公式判断是否有图片进入可视区域, 并把进入可视区域的图片都添加上 src 属性即可

## 基本实现

```html
<!DOCTYPE html>
<html lang="en">
  <body>
    <div class="container">
      <img
        class="lazy"
        data-src="http://static.xiong35.cn/image/placeHolder.gif"
      />
      <img
        class="lazy"
        data-src="http://static.xiong35.cn/image/placeHolder.gif"
      />
      <img
        class="lazy"
        data-src="http://static.xiong35.cn/image/placeHolder.gif"
      />
      <img
        class="lazy"
        data-src="http://static.xiong35.cn/image/placeHolder.gif"
      />
      <img
        class="lazy"
        data-src="http://static.xiong35.cn/image/placeHolder.gif"
      />
      <img
        class="lazy"
        data-src="http://static.xiong35.cn/image/placeHolder.gif"
      />
      <img
        class="lazy"
        data-src="http://static.xiong35.cn/image/placeHolder.gif"
      />
      <img
        class="lazy"
        data-src="http://static.xiong35.cn/image/placeHolder.gif"
      />
      <img
        class="lazy"
        data-src="http://static.xiong35.cn/image/placeHolder.gif"
      />
      <img
        class="lazy"
        data-src="http://static.xiong35.cn/image/placeHolder.gif"
      />
    </div>
  </body>
  <style>
    .container {
      width: 100%;
    }
    .container img {
      margin: 20px auto;
      width: 300px;
      min-height: 200px;
      display: block;
      border: 2px solid #000;
    }
  </style>
  <script>
    // lazy loading
    function lazyLoad(imgs) {
      const scrollTop = document.documentElement.scrollTop;
      const clientHeight = document.documentElement.clientHeight;

      imgs.forEach((it) => {
        if (!it.classList.contains("lazy")) {
          return;
        }
        if (it.offsetTop - scrollTop - clientHeight < -300) {
          // 为了更好的演示效果, 这里设置为图片在界面上出现超过300px才显示
          it.src = it.dataset.src; // 将保存在 data-src 里的图片地址赋给 src
          it.classList.remove("lazy"); // 加载完去除"lazy"类, 避免重复操作
        }
      });
    }
    function load() {
      const imgs = document.querySelectorAll(".lazy");

      window.onscroll = () => {
        lazyLoad(imgs);
      };
    }

    load();
  </script>
</html>
```

## 改进

### 设置防抖, 优化性能

将上面的 load 函数改为:

```js
function load() {
  const imgs = document.querySelectorAll(".lazy");

  var timmer;
  window.onscroll = () => {
    if (timmer) {
      return;
    }
    timmer = setTimeout(() => {
      timmer = null;
    }, 100);
    lazyLoad(imgs);
  };
}
```

每次滚动后设置一个0.1s的定时器, 在此期间不再调用lazyLoad函数, 可以显著降低调用次数, 优化性能

### 设置预加载, 提升用户体验

将 lazyLoad函数改为:

```js
function lazyLoad(imgs) {
  const scrollTop = document.documentElement.scrollTop;
  const clientHeight = document.documentElement.clientHeight;

  imgs.forEach((it) => {
    if (!it.classList.contains("lazy")) {
      return;
    }
    if (it.offsetTop - scrollTop - clientHeight < 150) {
      /* 为了更好的用户体验, 这里设置为图片距离界面下达到150px时就加载, 让用户不用看到图片加载的过程 */
      it.src = it.dataset.src;
      it.classList.remove("lazy");
    }
  });
}
```

在图片即将出现在可视范围时预加载, 避免用户有过长的等待图片加载时间

### 设置加载动画, 优化体验

给图片添加浮现出来的效果, 代码稍后展示

### 在页面刚加载时触发一次检测

避免刚打开界面还未滚动时, 已经在可视范围内的图片不加载, 代码稍后展示

## 完整代码

```html
<!DOCTYPE html>
<html lang="en">
  <body>
    <div class="container">
      <img
        class="lazy"
        data-src="http://static.xiong35.cn/image/placeHolder.gif"
      />
      <!-- img * n -->
      <img
        class="lazy"
        data-src="http://static.xiong35.cn/image/placeHolder.gif"
      />
    </div>
  </body>

  <style>
    .container {
      width: 100%;
    }
    .container img {
      margin: 20px auto;
      width: 300px;
      min-height: 200px;
      display: block;
      border: 2px solid #000;
      opacity: 0; /* 设置一开始不可见 */
      transition: all 0.5s;
    }
    /* 浮现效果 */
    img.float-up { 
      opacity: 1;
      transition-delay: 0.3s;
      animation: float 0.8s linear;
    }
    @keyframes float {
      from {
        transform: translateY(30px);
      }
      to {
        transform: translateY(0);
      }
    }
  </style>

  <script>
    // lazy loading
    function lazyLoad(imgs) {
      const scrollTop = document.documentElement.scrollTop;
      const clientHeight = document.documentElement.clientHeight;

      imgs.forEach((it) => {
        if (!it.classList.contains("lazy")) {
          return;
        }
        /* 差150px时就开始加载图片 */
        if (it.offsetTop - scrollTop - clientHeight < 150) {
          it.src = it.dataset.src;
        }
        /* 真正出现时添加动画效果 */
        if (it.offsetTop - scrollTop - clientHeight < 0) {
          it.classList.replace("lazy", "float-up");
        }
      });
    }
    const imgs = document.querySelectorAll(".lazy");
    function load() {

      var timmer;
      window.onscroll = () => {
        if (timmer) {
          return;
        }
        timmer = setTimeout(() => {
          timmer = null;
        }, 100);
        lazyLoad(imgs);
      };
    }
    load();
    /* 在最开始时检测一次图片位置 */
    lazyLoad(imgs)
  </script>
</html>
```

最终结果如下:

![result](http://static.xiong35.cn/image/imgBed/result.gif)