
# js 给 event 事件附加信息

场景: 需要做一个拖拽照片到垃圾桶组件进行删除的功能, 但是  
如果使用原生的 onDrop 事件只能在垃圾桶上监听, 且 `e.target` 也是垃圾桶, 无法获得被丢下的照片的 id  
如果使用 onDrag 事件, 可以得到照片的坐标, 但是 `e.target` 是照片组件, 不知道他被丢到哪个组件上了

综上, 使用原生的不加处理的 js 事件都没法完整的完成丢弃的过程

在此引入 event 对象的一个属性: `dataTransfer`, 他有两个方法: `setData`和`getData`, 可在事件上附加额外信息

```js
// image 组件上的拖拽开始时附加其 id
onDragStart= (e) => e.dataTransfer.setData("id", image.id)

// bin 组件上的 drop 事件里即可获得被拖动的 image 的 id
onDrop = (e) => {
    const id = e.dataTransfer.getData("id");
    /* ... */
}
```
