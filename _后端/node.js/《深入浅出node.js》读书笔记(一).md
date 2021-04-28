
# 《深入浅出node.js》读书笔记(一)

## module

### 基本用法

node 中导出, 导入模块的方式为:

```js
//导出
const { PI } = Math;

exports.area = (r) => PI * r ** 2; // export的属性即是被导出对象的属性

exports.circumference = (r) => 2 * PI * r;
```

```js
//导入
const circle = require('./circle.js');

console.log(`The area of a circle of radius 4 is ${circle.area(4)}`);
```

也可以导出/导入类

```js
//导出
module.exports = class Square {
  constructor(width) {
    this.width = width;
  }

  area() {
    return this.width ** 2;
  }
};
```

```js
// 导入
const Square = require('./square.js');
const mySquare = new Square(2);
console.log(`The area of mySquare is ${mySquare.area()}`);
```

### 关于module的tips

判断/获得入口程序

```js
// 判断
require.main === module
// 获得
require.main.filename
```

### 模块加载

顺序如下:

1. 缓存
2. 二进制的核心模块
3. 路径形式的文件模块(以/|../|./开头的路径), 引入后会存到缓存中, 即是多次调用, 模块中的代码也只执行一次
4. 自定义模块(既不以/|./|../开头, 又不是核心模块), 会从当前目录开始, 递归向上的查找`node_modules`目录下的同名js文件

> 详细流程见[官方文档](https://nodejs.org/dist/latest-v12.x/docs/api/modules.html#modules_all_together)

### 发布模块

```bash
npm adduser
cd your_dir
npm publish .

npm owner ls <package name> 
npm owner add <user> <package name> 
npm owner rm <user> <package name>
```

## 异步io

### 常用io方式

- 同步阻塞: 应用发起io, **等**到系统返回后才继续运行
- 同步非阻塞(read): 发起请求后自己干别的去, 同时一直询问系统io完成与否, 直到得到肯定答复为止
- 异步阻塞(select、poll、epoll): 发起请求就**等着**, io请求结束后会反过来通知进程
- 异步非阻塞(AIO): 发起请求后自己干别的去, io请求结束后会反过来通知进程

### node 的异步 io

1. 发送异步请求时, js 产生一个**请求对象**, 他包含了参数, 回调等信息, 之后就被推到了线程池里等待执行
2. js调用立即返回, 执行当前任务后续操作, 当前io任务在线程池中等待
3. 等线程池中的io任务排到队了就执行
4. 执行完毕后将结果放到请求对象中, 告知进程异步操作已结束, 归还线程
5. 将请求对象放到io观察者队列(等待队列)
6. 主循环检查等待队列, 取出事件处理

如下图:

![event_loop](https://s1.ax1x.com/2020/07/13/UYbuHs.png)

### nextTick / setTimeout / setImmediate

每次调用`process.nextTick()`方法, 只将回调函数放入队列, 在下一Tick时执行  
定时器中用红黑树的操作时间复杂度为O(lg(n)), `nextTick()`的时间复杂度为O(1). 相比之下, `process.nextTick()`更高效

不同类型的观察者，处理的优先级不同，idle观察者 > I/O观察者 > check观察者

- idle观察者：就是早已等在那里的观察者，如`process.nextTick`
- I/O观察者：就是I/O相关观察者，也就是I/O的回调事件，如网络，文件，数据库I/O等
- check观察者：就是需要检查的观察者，如`setTimeout, setInterval`

`process.nextTick()`使用数组实现, 每次循环会按顺序将数组内所有回调执行完  
`setImmediate()`使用链表实现, 每次循环按顺序执行链表中的回调

## 内存

v8引擎主要将内存分为两大块: 新生代和老生代

- 新生代
  - 存活时间较短
  - 管理方式为: 将此部分内存一分为二, 先只是用一边, 内存回收时将这边的存活对象复制到另一边, 同时清空这边
  - 当一个对象在多次复制后还存活, 就把他提升为老生代中.  
此外, 如果复制时发现 to 那边的空间已经使用了25%以上, 则直接提升为老生代
- 老生代
  - 存活时间长
  - 管理方式为
    - Mark-Sweep: 遍历所有活着的对象, 直接清除死亡对象(会产生内存碎片, 但是是主流做法)
    - Mark-Compact: 遍历所有活着的对象, 将活着的对象复制到一侧, 清除外侧的内存(速度较慢, 对由于空间不足而晋升的对象才使用)

> v8 还使用了 步进清理, 延迟清理, 增量清理 等方式进行改进

## buffer

类似数组(支持取下标运算, 又length属性), 但是是存放二进制数据的

略

