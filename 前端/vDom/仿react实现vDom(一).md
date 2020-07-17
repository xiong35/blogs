
# 仿react实现vDom(一)

> 本文假设你已经对 vdom (虚拟dom树)有一定了解

## 简介

直接获取并操纵 dom 的坏处: 获得特定的 dom 元素开销大, 尤其是 dom 元素多且操作频繁时  
直接操纵 dom 树的坏处: dom 树信息量过大, 有一吨你不太会需要的属性/方法, 过于笨重

操作 dom 树的好处: 轻量, 且能准确反映真实 dom 树的关键属性

## 关键步骤

1. render: 在最开始时将虚拟 dom 渲染到界面上
2. diff: 找到新旧 dom 树的不同之处, 用和 vdom 结构类似的树型结构表示
3. patch: 打补丁, 将 diff 产生的反映新旧树差异的 diff 树应用到**真实 dom** 上

用下图表示:

![diff](https://s1.ax1x.com/2020/07/17/U60WTI.png)

这样做的意义在于, 你只需要**修改变化的部分**, 而**保留未改变的部分**, 大大节省操作开销

## 具体实现

vDom 的结构为:

```js
const vdom = {
  type: "ul",
  props: { class: "container" },
  children: [
    {
      type: "li",
      children: ["foo"],
    },
    {
      type: "li",
      children: ["bar"],
    },
    /* ... */
  ],
}
```

### render

这个好说, 只用递归的创建元素即可:

```js
const createElement = (vDom) => {
  if (typeof vDom === "string" || typeof vDom === "number") {
    return document.createTextNode(vDom);
  }

  const { tag, props, children } = vDom;

  const element = document.createElement(tag);

  for (let propName in props) {
    element.setAttribute(propName, props[propName]);
  }

  if (children) {
    children
      .map(createElement)
      .forEach(element.appendChild.bind(element));
  }
  return element;
};
```

### diff

这个就略微有些复杂, 我们先实现一个简单版本(讲解见注释):

```js
// 为了避免写错 & 方便 ide 提示, 先定义几个常量
const nodePatchTypes = {
  CREATE: "create node",
  REMOVE: "remove node",
  REPLACE: "replace node",
  UPDATE: "update node",
};

const propPatchTypes = {
  REMOVE: "remove prop",
  UPDATE: "update prop",
};

diff = (vDomOld, vDomNew) => {
  // add
  // 如果没有旧子树就标记要创建他, 将创建的树的结构存为`vDom`属性
  if (!vDomOld) {
    return {
      type: nodePatchTypes.CREATE,
      vDom: vDomNew,
    };
  }

  // del
  // 如果没有新树则是删除旧树
  if (!vDomNew) {
    return { type: nodePatchTypes.REMOVE };
  }

  // replace
  // 如果是不同的文本节点就替换文本
  if (
    typeof vDomOld !== typeof vDomNew ||
    ((typeof vDomOld === "string" ||
      typeof vDomOld === "number") &&
      vDomOld !== vDomNew) ||
    vDomOld.tag !== vDomNew.tag
  ) {
    return {
      type: nodePatchTypes.REPLACE,
      vDom: vDomNew,
    };
  }

  // update child
  // 如果当前旧树是个有标签, 有孩子的元素节点,
  // 就检查他的属性, 并递归的检查子节点
  if (vDomOld.tag) {
    const propsDiff = _diffProps(vDomOld, vDomNew);
    const childrenDiff = _diffChildren(vDomOld, vDomNew);

    if (
      // 如果属性或者子节点有修改, 就返回这些修改
      propsDiff.length > 0 ||
      childrenDiff.some((patch) => !!patch)
    ) {
      return {
        type: nodePatchTypes.UPDATE,
        props: propsDiff,
        children: childrenDiff,
      };
    }
  }
};

_diffProps = (vDomOld, vDomNew) => {
  const patches = [];
  const allProps = { ...vDomOld.props, ...vDomNew.props };
  for (let propName in allProps) {
    const oldVal = vDomOld.props[propName];
    const newVal = vDomNew.props[propName];
    // del
    if (!newVal) {
      patches.push({
        type: propPatchTypes.REMOVE,
      });
    }
    // update
    else if (!oldVal || oldVal !== newVal) {
      patches.push({
        type: propPatchTypes.UPDATE,
        propName,
        value: newVal,
      });
    }
  }
  return patches;
};

_diffChildren = (vDomOld, vDomNew) => {
  const patches = [];

  // 新老子节点的每个都要检查
  const childLength = Math.max(
    vDomOld.children.length,
    vDomNew.children.length
  );

  for (let i = 0; i < childLength; i++) {
    patches.push(
      // 就算有 undefined 也无妨, diff 中会检查并创建他
      diff(vDomOld.children[i], vDomNew.children[i])
    );
  }

  return patches;
};
```

至此, 我们可以得到类似这样的 diff 树:

```js
{
  type,
  vdom,
  props: [
    {
        type,
        propName,
        value 
    },
    /* ... */
  ]
  children: [/* ... */]
}
```

### patch

将 diff 产生的 patchObj 映射到真实 dom 上, 按照 diff 对 dom 进行修改

```js
patch = (parent, patchObj, index = 0) => { 
  // parent 是一个真实 dom 节点
  // index 是为了从 parent 里取出自己
  // 如果到头了或者遇到不需要修改的节点就直接跳过
  if (!patchObj) {
    return;
  }

  // create
  if (patchObj.type === nodePatchTypes.CREATE) {
    return parent.appendChild(this.createElement(patchObj.vDom));
  }

  const element = parent.childNodes[index];

  // delete
  if (patchObj.type === nodePatchTypes.REMOVE) {
    return parent.removeChild(element);
  }

  // update
  else if (patchObj.type === nodePatchTypes.UPDATE) {
    const { props, children } = patchObj;

    _patchProps(element, props);

    children.forEach((obj, ind) => {
      patch(element, obj, ind);
    });
  }

  // replace
  else if (patchObj.type === nodePatchTypes.REPLACE) {
    return parent.replaceChild(
      createElement(patchObj.vDom),
      element
    );
  }
};

_patchProps = (element, props) => {
  if (!props) {
    return;
  }

  props.forEach((obj) => {
    // del
    if (obj.type === propPatchTypes.REMOVE) {
      element.removeAttribute(patchObj.propName);
    }
    // create / update
    else if (obj.type === propPatchTypes.UPDATE) {
      element.setAttribute(obj.propName, obj.value);
    }
  });
};
```

这样就实现了简单的 vdom 树!

[下篇文章](http://www.xiong35.cn/blog2.0/articles/blog/99)将讲解如何高效的复用已经创建好的 dom 元素

## 参考资料

- [你不知道的 Virtual DOM](https://segmentfault.com/a/1190000016129036)
- [React 源码剖析系列 － 不可思议的 react diff](https://zhuanlan.zhihu.com/p/20346379)
- [VirtualDOM与diff(Vue实现)](https://github.com/answershuto/learnVue/blob/master/docs/VirtualDOM%E4%B8%8Ediff(Vue%E5%AE%9E%E7%8E%B0).MarkDown)
- [vue源码-dom diff](https://echizen.github.io/tech/2019/03-25-vue-dom-diff)
