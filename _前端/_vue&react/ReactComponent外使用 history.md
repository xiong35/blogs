# ReactComponent 外使用 history

> 关键词: React

react router 可以用`withRouter`对组件进行包装, 在他的 props 里注入 history 对象, 从而控制网页路径, 但是还是无法在 ReactComponent 外使用 history 对象(如在 axios 中使用统一的跳转回调)

为了实现这一功能, react 提供了如下 api

## 手动创建 history 对象

react 的依赖里有 history 这个库, 所以不用自己下载  
利用其提供的 api 加上 webpack 的单例模式, 可以创建全局唯一的 history 对象, 供 react router 和 ReactComponent 外部的函数使用

创建 history.js, 写下如下代码

```js
// history.js
import { createBrowserHistory } from "history";

// history 本不能在 React Component 外用, 但是这样就可以了
const history = createBrowserHistory();
export default history;
```

## 挂载到 react-router 上

让 react router 和 我们创建的 history 对象产生关联

```js
// index.js
import { Router } from "react-router-dom";
import history from "./utils/history";

ReactDOM.render(
  <Router history={history}>
    <Layout />
  </Router>
  document.getElementById("root")
);
```

## 在外部使用

```js
import history from "./history";

export async function login(line) {
  const res = await showDialog(<LoginContent line={line} />, ["取消", "登录"]);
  if (res !== "登录") return;
  history.push("/login"); // 这里, 直接使用 history 对象进行界面跳转
}
```
