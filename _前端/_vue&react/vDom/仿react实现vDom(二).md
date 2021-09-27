# 仿 react 实现 vDom(二)

> 关键词: JavaScript, 算法

> 本文假设你已经对 vdom (虚拟 dom 树)有一定了解, 并且读过[前文](http://www.xiong35.cn/blog2.0/articles/blog/98)

## key 的作用

想象这样的场景:

一个 ul 有一堆 li 作为子元素, 然后你向 li 的最前面插入了一个 li  
你期望能够直接插入新节点而不改变剩余节点, 但是按照上文的做法并不会实现这个效果

实际上会发生什么?

当你前序遍历(也就是上文中我们的遍历方式)并 diff 这些节点时, diff 算法会认为**每一个**节点的内容都改变了(变成了前一个节点的值), 他会修改每个节点的值, 并在最后插入一个节点  
这显然不是我们需要的!

为了避免不必要的修改, 我们为相似的节点添加一个 key 属性, 如果新旧子节点列表中有相同的 key, 就先把他们挪到合适的位置, 再递归的比较他们. 通过挪位置的操作可以有效的复用节点, 减少操作开销

## 算法思路

1. for 新子节点 in 新节点列表
   1. 如果在旧节点列表里找得到相同类型元素
      1. 将这个元素调整到合适的位置, 并递归的 diff 他们
      2. 标记那个旧节点为 undefined
   2. 如果找不到
      1. 标记要创建新节点
2. 将所有未被标记为 undefined 的旧子节点删除(因为可被复用的已经在 1.1.2 步中被标记过了)

此过程可以用 hash 表(map 对象)加速, 此外还可应用优化调整顺序的算法, 详见[React 源码剖析系列 － 不可思议的 react diff](https://zhuanlan.zhihu.com/p/20346379)

## 代码实现

```js
const nodePatchTypes = {
  CREATE: "create node",
  REMOVE: "remove node",
  REPLACE: "replace node",
  UPDATE: "update node",
  INSERT: "insert node",
};

const propPatchTypes = {
  REMOVE: "remove prop",
  UPDATE: "update prop",
};

class VDom {
  createElement = (vDom) => {
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
        .map(this.createElement)
        .forEach(element.appendChild.bind(element));
    }
    return element;
  };

  static toVDom = (tag, props, ...children) => {
    return {
      tag,
      props: props || {},
      children: [].concat.apply([], children) || [],
    };
  };

  diff = (vDomOld, vDomNew) => {
    // add
    if (!vDomOld) {
      return {
        type: nodePatchTypes.CREATE,
        vDom: vDomNew,
      };
    }

    // del
    if (!vDomNew) {
      return { type: nodePatchTypes.REMOVE };
    }

    // replace
    if (
      typeof vDomOld !== typeof vDomNew ||
      ((typeof vDomOld === "string" || typeof vDomOld === "number") &&
        vDomOld !== vDomNew) ||
      vDomOld.tag !== vDomNew.tag
    ) {
      return {
        type: nodePatchTypes.REPLACE,
        vDom: vDomNew,
      };
    }

    // update child
    if (vDomOld.tag) {
      const propsDiff = this._diffProps(vDomOld, vDomNew);
      const { children, moves } = this._diffChildren(vDomOld, vDomNew);

      if (propsDiff.length > 0 || children.some((patch) => !!patch)) {
        return {
          type: nodePatchTypes.UPDATE,
          props: propsDiff,
          moves,
          children,
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
    const patches = new Array(vDomNew.children.length);
    const moves = new Array(vDomOld.children.length);
    /* 
    node obj:
    {
      oldInd: <number>
      vDom: <vDom>
    }
    */
    const nodesWithKey = {};

    const nodesWithoutKey = [];
    let noKeyInd = 0;

    const oldChildren = vDomOld.children;

    const newChildren = vDomNew.children;

    let lastIndex = 0;

    // 将子元素分成有key和没key两组
    oldChildren.forEach((child, ind) => {
      const props = child.props;

      if (props !== undefined && props.key !== undefined) {
        nodesWithKey[props.key] = {
          oldInd: ind,
          vDom: child,
        };
      } else {
        nodesWithoutKey[noKeyInd++] = {
          oldInd: ind,
          vDom: child,
        };
      }
    });

    // 插入 / 更新新元素, 移动老元素
    newChildren.forEach((newChild, newInd) => {
      // 找能不能复用
      let oldObj;
      if (newChild && newChild.props && newChild.props.key) {
        oldObj = nodesWithKey[newChild.props.key];
        // 设置 key 被用过了
        nodesWithKey[newChild.props.key] = undefined;
      } else {
        // 尝试找到没有 key 的相同元素, 找到就复用, 找不到就插入
        oldObj = nodesWithoutKey.find((obj, ind) => {
          if (obj && this._sameVnodeType(obj.vDom, newChild)) {
            nodesWithoutKey[ind] = undefined;
            return true;
          }
        });
      }
      // 移动 / 插入 元素
      if (!oldObj) {
        // 如果对应的 key 没有旧元素可复用
        // 就在新元素的位置创建并 插入 元素
        patches[newInd] = {
          insert: true,
          rDom: this.createElement(newChild),
          at: newInd,
        };
      } else {
        if (oldObj.oldInd < lastIndex) {
          /* 当前节点在老集合中的位置与 lastIndex 进行比较，
           if (child.oldInd >= lastIndex)，
           说明老元素中, 他前面的节点都被处理过 / 将要被处理
           他自己只要顺位往前排就好了, 不会有人插到前面
           则不进行节点移动操作，否则执行该操作 */
          moves[oldObj.oldInd] = {
            type: nodePatchTypes.INSERT,
            from: oldObj.oldInd,
            at: newInd,
          };
        }
        lastIndex = Math.max(oldObj.oldInd, lastIndex);
        // 移动后如何更新新dom
        patches[newInd] = this.diff(oldObj.vDom, newChild);
      }
    });

    // 清理未被复用的元素
    for (let key in nodesWithKey) {
      let oldObj = nodesWithKey[key];
      if (oldObj) {
        moves[oldObj.oldInd] = {
          type: nodePatchTypes.REMOVE,
          from: oldObj.oldInd,
        };
      }
    }
    for (let ind = 0; ind < nodesWithKey.length; ind++) {
      let oldObj = nodesWithKey[ind];
      if (oldObj) {
        moves[oldObj.oldInd] = {
          type: nodePatchTypes.REMOVE,
          from: oldObj.oldInd,
        };
      }
    }

    return { children: patches, moves };
  };

  patch = (parent, patchObj, index = 0) => {
    if (!patchObj || !parent) {
      return;
    }

    // insert
    if (patchObj.insert) {
      let atNode = parent.childNodes[patchObj.at];
      parent.insertBefore(patchObj.rDom, atNode);
    }

    // create
    else if (patchObj.type === nodePatchTypes.CREATE) {
      return parent.appendChild(this.createElement(patchObj.vDom));
    }

    const siblings = parent.childNodes;
    const element = siblings[index];

    // delete
    if (patchObj.type === nodePatchTypes.REMOVE) {
      return parent.removeChild(element);
    }
    // replace
    else if (patchObj.type === nodePatchTypes.REPLACE) {
      return parent.replaceChild(this.createElement(patchObj.vDom), element);
    }

    // update
    else if (patchObj.type === nodePatchTypes.UPDATE) {
      const { props, children, moves } = patchObj;
      this._patchProps(element, props);

      // move
      if (moves) {
        const toRemove = [];

        moves.forEach((obj) => {
          if (obj) {
            if (obj.type === nodePatchTypes.INSERT) {
              children[obj.to] = children[obj.to] || {};

              children[obj.to].rDom = siblings[obj.from];
              children[obj.to].insert = true;
              children[obj.to].at = obj.at;
            }
            toRemove.push(siblings[obj.from]);
          }
        });

        toRemove.forEach((el) => {
          if (el) el.parentNode.removeChild(el);
        });
      }

      children.forEach((obj, ind) => {
        this.patch(element, obj, ind);
      });
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

  _sameVnodeType(a, b) {
    let aType = typeof a;
    let bType = typeof b;
    if (aType === "undefined" || bType === "undefined") {
      return false;
    }
    if (
      (aType === "string" || aType === "number") &&
      (bType === "string" || bType === "number")
    ) {
      return true;
    }
    return a.key === b.key && a.tag === b.tag;
  }
}
```

## 参考资料

- [你不知道的 Virtual DOM](https://segmentfault.com/a/1190000016129036)
- [React 源码剖析系列 － 不可思议的 react diff](https://zhuanlan.zhihu.com/p/20346379)
- [VirtualDOM 与 diff(Vue 实现)](<https://github.com/answershuto/learnVue/blob/master/docs/VirtualDOM%E4%B8%8Ediff(Vue%E5%AE%9E%E7%8E%B0).MarkDown>)
- [vue 源码-dom diff](https://echizen.github.io/tech/2019/03-25-vue-dom-diff)
