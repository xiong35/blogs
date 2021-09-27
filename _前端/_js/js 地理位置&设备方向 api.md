# js 地理位置 & 设备方向 api

> 关键词: JavaScript

## 地理位置

> 兼容性良好

api: `navigator.geolocation`

### `getCurrentPosition()`

`navigator.geolocation.getCurrentPosition(callback, [callback], [option])`

成功的 callback 会被传入一个以下格式的对象

```js
<GeolocationPosition> {
    coords: <GeolocationCoordinates> {
        accuracy: 25000,    // 所提供的以米为单位的经度和纬度估计的精确度
​​        altitude: null,
​​        altitudeAccuracy: null,   // 所提供的以米为单位的高度估计的精确度
​​        heading: null,    // 移动的角度方向，相对于正北方向顺时针计算
​​        latitude: 30.5856,
​​        longitude: 114.2665,
​​        speed: null,
    },
    timestamp: 1601368073818
}
```

失败回调的参数则是

```js
<GeolocationPositionError> {
    code: 2,
    message: "Network location provider at 'https://www.googleapis.com/' : No response received."
}
```

code 中 1 代表没有权限, 2 代表无法定位, 3 代表超时

option 对象来决定定位的细节:

- `enableHighAccuracy`: 默认为 false, 设置为 true 可以开启更精准的定位，同时也会增加响应时间
- `timeout`: 设定超时时间, 单位为毫秒, 默认无限大. 设置负数会变为 0
- `maximumAge`: 地理位置的缓存时间. 默认为 0, 设置负数也为 0

### `watchPosition(), clearWatch()`

`watchPosition`的调用与`getCurrentPosition`相同, 只不过`watchPosition`会不断的获取位置, 且会返回一个 ID，把该值传入`clearWatch`即可停止轮询(就像是 setInterval 和 clearInterval 那样的组合)，当然定位失败一次，也会导致`watchPosition`循环停止，然后调用第二个 callback 来处理错误。

## 设备方向

> 兼容性良好

```js
const mql = window.matchMedia("(orientation: portait)"); // 实际上是 css 媒体查询
/* 
mql: {
    matches: A Boolean that returns true if the document currently matches the media query list
    media: A DOMString representing a serialized media query
    addListener()
    removeListener()
}
*/

function listenerOrientationChange(mql) {
  if (mql.matches) {
    // 坚屏
  } else {
    // 横屏
  }
}

listenerOrientationChange(mql);

mql.addListener(listenerOrientationChange);

mql.removeListener(handleOrientationChange);
```

## 参考资料

- [js 获取地理位置的接口 navigator.geolocation](https://www.cnblogs.com/splitgroup/p/6835690.html)
- [mdn Geolocation](https://developer.mozilla.org/zh-CN/docs/Web/API/Geolocation)
- [mdn Window.matchMedia()](https://developer.mozilla.org/en-US/docs/Web/API/Window/matchMedia)
- [JS 获取和监听屏幕方向变化](https://blog.csdn.net/To_Be_Better0822/article/details/90410539)
