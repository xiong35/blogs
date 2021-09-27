# react 封装对话框

> 关键词: React

## 需求

网页中为了更好的用户交互, 常需要给用户一些提示信息, 原生的 alert 太 low 了, 故准备自己封装一个

## 分析

首先, 用户的点击是一个异步事件, 此函数应该返回一个 promise  
因为对话框可能有对应的 action, 且不确定 action 的个数有多少, 我认为不适合在对话框底部对每种动作绑定传递进来的回调(要为每个回调装饰一个 resolve promise 操作, 代码冗余很大), 亦不适合直接渲染传递进来的 button(每次使用都要重复写 bottom 的样式), 所以我决定由使用者传入每个 button 内部的文字, 而每个按钮的点击回调就是 resolve 它对应的文字

## 第一版代码

```js
import ReactDOM from "react-dom";
import DialogBox from "../components/CommonDialogBox";
import OutlinedBtn from "../components/CommonOutlinedBtn";

/**
 * @param {object} content 若为对象, 则直接传入 DialogBox 里
 * @param {Array<string>} [actions=["取消", "确认"]]
 *    为字符串数组, 默认值为 ["取消", "确认"]
 *    函数返回的 promise 所 resolve 的值为字符串, 对应所点击的 action 的按钮内文字
 * @return {Promise<string>} resolve 的值为点击的按钮内的文字(string类型)
 */
export default async (text, actions = ["取消", "确认"]) => {
  // 创建一个挂载 dialog box 的元素
  let div = document.createElement("div");
  // 绑定唯一 id
  const id = "__dialog__" + new Date().getTime();
  div.setAttribute("id", id);
  // 将盒子挂载到 dom 树上
  document.body.appendChild(div);

  // 销毁组件的函数
  function del() {
    if (document.getElementById(id)) {
      document.getElementById(id).remove();
    }
  }

  // 返回 promise
  return new Promise((resolve, _) => {
    // 根据 actions 创建按钮, 绑定的点击回调为 resolve 其内容
    const btns = actions.map((action) => (
      <OutlinedBtn
        content={action}
        onClick={() => {
          del();
          resolve(action);
        }}
      />
    ));

    // 将 dialog 用 react 渲染出来
    ReactDOM.render(
      <DialogBox
        content={content}
        actions={btns}
        isMasked
        isMaskedChange={() => {
          // 点击对话框旁边也能关闭, resolve 的值为 null
          del();
          resolve(null);
        }}
      />,
      div
    );
  });
};
```

以上代码就完成了 dialog box 的基本功能

## 改进

由于 dialog box 不在整体的 react dom tree 里, 而且是用完即弃的, 所以他现在不存在状态变化, 重新渲染啥的, 但是我想为他加上一个渐进渐出的效果, 于是有了改进后的代码

```js
import ReactDOM from "react-dom";
import DialogBox from "../components/CommonDialogBox";
import OutlinedBtn from "../components/CommonOutlinedBtn";

const TRANSITION = 150; // ms
/**
 * @param {object} content 若为对象, 则直接传入 DialogBox 里
 * @param {Array<string>} [actions=["取消", "确认"]]
 *    为字符串数组, 默认值为 ["取消", "确认"]
 *    函数返回的 promise 所 resolve 的值为字符串, 对应所点击的 action 的按钮内文字
 * @return {Promise<string>} resolve 的值为点击的按钮内的文字(string类型)
 */
export default async function showDialog(content, actions = ["取消", "确认"]) {
  // 创建一个挂载 dialog box 的元素
  let div = document.createElement("div");
  // 绑定唯一 id
  const id = "__dialog__" + new Date().getTime();
  div.setAttribute("id", id);
  // 将盒子挂载到 dom 树上
  document.body.appendChild(div);

  // 利用闭包保存当前 dialog 是否被移除的信息
  var isGone = false;

  function del() {
    div.remove();
  }

  return new Promise((resolve, _) => {
    const btns = actions.map((action) => (
      <OutlinedBtn
        content={action}
        onClick={async () => {
          // 需要等 dialog 彻底消失
          await close();
          del();
          resolve(action);
        }}
      />
    ));

    // 重要的函数
    function close() {
      if (isGone) return;
      isGone = true;
      return new Promise((res) => {
        ReactDOM.render(
          <DialogBox
            content={content}
            actions={btns}
            // 重新渲染组件, 与原组件的区别是此组件透明度为 0
            // 由于还给组件设置了 transition, 透明度就会平滑的降为 0
            isMasked={false}
            isMaskedChange={() => {}}
          />,
          div
        );
        // 一段时间后 resolve, 即告知外界当前组件已经彻底消失
        setTimeout(res, TRANSITION);
      });
    }

    // 点击空白处的回调
    async function isMaskedChange() {
      await close();
      del();
      resolve(null);
    }

    // 先渲染透明的对话框
    ReactDOM.render(
      <DialogBox
        content={content}
        actions={btns}
        isMasked={false}
        isMaskedChange={isMaskedChange}
      />,
      div
    );
    setTimeout(
      () =>
        // 一帧后重新渲染不透明度对话框, 以让他平滑的出现
        ReactDOM.render(
          <DialogBox
            content={content}
            actions={btns}
            isMasked
            isMaskedChange={isMaskedChange}
          />,
          div
        ),
      0
    );
  });
}
```
