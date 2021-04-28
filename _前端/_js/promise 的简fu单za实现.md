
# promise 的简fu单za实现

## 最最基础的promise

最简单的 promise 至少得要这几个部件:

- 有一个回调函数`fn`作为初始化的参数
- `then`方法, 给 promise 传递回调函数
- 要一个数组(`callbacks`)保存回调函数
- 记得给回调函数传递**通知这个promise执行回调**的参数(即`resolve`函数)

> 关于类里面箭头函数的作用可以参看我的[《js 类中函数 this 指向问题》](http://www.xiong35.cn/blog2.0/articles/blog/96)

我们来跟着代码手动单步调试:

```js
// 1. 声明类, 暂时不执行(向下看)
class MyPromise {
    callbacks = [];
    constructor(fn) {
        // 3. 参数 fn 是一个以 resolve 为形参的函数
        //    现在把 _resolve 函数传给他作为参数,
        //    并直接调用这个 fn(向下看)
        fn(this._resolve);
    }
    then = (onFulfilled) => {
        // 6. then 方法的回调暂时不执行
        //    而是放到callback队列中等待以后再执行
        //    至此同步方法都指向完毕, 下面就等计时器到点了(向下)
        this.callbacks.push(onFulfilled);
    }
    _resolve = (value) => {
        // 8. 回调函数调用 promise 的_resolve方法
        //    依次执行回调列表里的函数(第6步中加入进来的onFulfilled函数)
        //    并以 "5秒" 作为参数(向下)
        this.callbacks.forEach(fn => fn(value));
    }
}

// 2. new 调用了构造器(向上看)
new MyPromise((resolve) => {
    // 4. fn 被调用, 定时器启动
    //    构造函数调用完毕, 接下来调用实例的then方法(向下)
    setTimeout(() => {
        // 7. 5s后, 计时器到点被触发, 打印 done, 触发 resolve 函数
        //    这里的resolve函数其实是第3步传进来的参数
        //    他本身是peomise类的 _resolve 方法(向上)
        console.log('done');
        resolve('5秒');
    }, 5000);
}).then((res) => { // 5. 调用then方法, 并传递一个回调(向上)
    // 9. 这里的函数实际上就是onFulfilled, 现在接受了 "5秒" 作为参数
    //    在 5 秒后的现在打印了 "5秒" 这句话
    //    至此整个 promise 运行结束
    console.log(ras);
})
```

怎么样, 是不是很<nig>**简单**</big>呢  
虽然这个程序和完整的 promise 相比还有很多差距, 但是基本思路就是这样的了, 理解了思路再往后 加/改 功能就简单多了

## 添加亿点细节

我们的 promise 还需要(包括但不限于)以下功能:

1. 除了可以在回调结束时`resolve`, 还要**可以`reject`**
2. 保存`fulfilled/rejected`状态, 一旦决定就**不能再改变**
3. 保存`recolve`的值/`reject`的原因
4. 就算没有进行异步操作, 也应该**异步调用各个 then**
5. 可以进行**链式调用**, 且链上的每一个 promise 都能单独保存自己的状态
6. 可以在`onFulfill/onReject`里返回**新的promise**, 在拿到上一次异步操作的结果后, 开始下一段异步操作

改进后代码如下(改进的地方都写在注释了)  
这里的`resolvePromise`方法是依照**promise A+规范**第 2.3 则(的阉割版)来实现的(规范详情见底部的参考文献)

```js

const PENDING = "pending";
const FULFILLED = "fulfilled";
const REJECTED = "rejected";

class MyPromise {
  callbackObjs = [];  // 保存了成功和失败两个回调
                      // 后面的_resolve/_reject也得改
  status = PENDING;   // 2
  value = null;       // 3

  constructor(fn) {
    fn(this._resolve, this._reject);
  }

  then = (onFulfilled, onRejected) => {       // 1
    let pro2 = new Promise((resolve, reject) => { // 5
      if (this.status === PENDING) {
        // 如果当前promise还没决定, 这个返回的promise也不急着决定
        // 而是将当前promise的回调存到自己里面(对他就是当前promise的工具人)
        // 等当前peomise决定了
        let callbackObj = {
          onFulfilled: () => {
            setTimeout(() => {                // 4
              let ret = onFulfilled(this.value);  // 6
              resolvePromise(pro2, ret, resolve, reject);
            });
          },
          onRejected: () => {
            setTimeout(() => {
              let ret = onRejected(this.value);
              resolvePromise(pro2, ret, resolve, reject);
            });
          },
        };
        this.callbackObjs.push(callbackObj);
      }
      else {
        let callback =
          this.status === FULFILLED ? onFulfilled : onRejected;
        setTimeout(() => {                    // 4
          let ret = callback(this.value);     // 6
          resolvePromise(pro2, ret, resolve, reject);
        });
      }
    });

    return pro2;
  }

  _resolve = (value) => {
    if (this.status === PENDING) {            // 2
      this.status = FULFILLED;                // 2
      this.value = value;                     // 3
      this.callbackObjs.forEach(obj => obj.onFulfilled());
    }
  }

  _reject = (reason) => {                     // 1
    if (this.status === PENDING) {
      this.status = FULFILLED;
      this.value = reason;
      this.callbackObjs.forEach(obj => obj.onRejected());
    }
  }
}

function resolvePromise(pro2, ret, resolve, reject) {
  if (
    // 如果 ret 是一个看起来想 promise 的东西
    // 即, 是一个有 then 方法的 函数/对象
    (ret && typeof ret === "object") ||
    typeof ret === "function"
  ) {
    let then = ret.then;
    if (typeof then === "function") {
      // (接上)那么就以 ret 为 this, 调用这个 then 方法
      // (见 promise A+ 规范 2.3.3.3 则)
      then.call(
        ret,
        (y) => {
          resolvePromise(pro2, y, resolve, reject);
        },
        (r) => {
          reject(r);
        }
      );
      return
    }
  }
  // 否则就以 ret 为值 resolve 上一个 promise
  resolve(ret);
}
```

用下面这段程序测试一下我们的代码, 发现一切顺利 :P

```js
new MyPromise((resolve, reject) => {
  console.log("begin pro1");
  setTimeout(() => {
    reject("pro1 reject");
  }, 3000);
})
  .then(
    (result) => {
      console.log("result in pro2's resolve:", result);
      return result;
    },
    (error) => {
      console.log("error in pro2's reject:", error);
      return "error msg from pro2";
    }
  )
  .then((result) => {
    return new MyPromise((resolve) => {
      setTimeout(() => {
        console.log("result in pro3's resolve:", result);
        resolve("msg from pro3");
      }, 3000);
    });
  })
```

## what's more

你以为这就是 promise 了么, 呵呵, 天真

来, 测一测这个 promise
测试的方法为(在 node 环境下)执行`npm install -g promises-aplus-tests`, 下载一个 A+ 标准的 promise 测试脚本, 在你的 promise 代码最后加入以下内容

```js
exports.deferred = () => {
  let dfd = {};
  dfd.promise = new MyPromise((resolve, reject) => {
    dfd.resolve = resolve;
    dfd.reject = reject;
  });
  return dfd;
};
```

然后在代码所在文件夹里执行`promises-aplus-tests yourPromise.js`, 你会看到...满屏的红色

还差哪里?

差的功能包括而不限于:

1. 错误及异常处理
2. 多次调用同一个 promise 的 then 的处理
3. 类直接创建 resolve / reject 的静态方法
4. catch / finally 方法
5. race / all 方法
6. 解决循环引用的 promise 链问题

**...**我反正吐了, 你呢

然而在一顿爆肝后, 终于写出完整的promise, 上述测试 872 条全部通过, 那个感觉, 啊~爽~

## 完整代码

[完整 promise 代码](https://github.com/xiong35/unique-web-summer/blob/master/assignment/2/promise/promise.js)

## 参考资料

- [promise A+ 规范文档](https://promisesaplus.com/)
- [promise A+ 规范中文翻译](https://www.ituring.com.cn/article/66566)
- [图解 Promise 实现原理](https://zhuanlan.zhihu.com/p/58428287?utm_source=wechat_timeline)
- [promise 源码实现](https://segmentfault.com/a/1190000018428848?utm_source=tag-newest)