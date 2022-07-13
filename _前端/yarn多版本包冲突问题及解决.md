# yarn多版本包冲突问题及解决

## 问题描述

在编译项目时遇到这个报错：

```txt
semantic error TS2605 JSX element type 'Component<any, any, any> | ReactElement<any, any> | null' is not a constructor function for JSX elements.
  Type 'Component<any, any, any>' is not assignable to type 'Element | ElementClass | null'.
    Type 'Component<any, any, any>' is not assignable to type 'ElementClass'.
      The types returned by 'render()' are incompatible between these types.
        Type 'React.ReactNode' is not assignable to type 'import("xxx/node_modules/@types/react-transition-group/node_modules/@types/react/index").ReactNode'.
          Type '{}' is not assignable to type 'ReactNode'.
            Type '{}' is missing the following properties from type 'ReactPortal': key, children, type, props
```

## 问题分析

在网上研究一圈后发现问题的产生原因如下：

1. 使用的这个 @types/react-transition-group 包的 package.json 中对react版本的要求是: `"@types/react": "*"`
2. yarn 下载时将这个版本依赖解析成了 react 18.x 版本
3. react 17 和 react 18 中对`ReactFragment`的定义略有不同：

```ts
// react 17
type ReactFragment = {} | Iterable<ReactNode>;
type ReactNode = ReactChild | ReactFragment | ReactPortal | boolean | null | undefined;

// react 18
type ReactFragment = Iterable<ReactNode>;
type ReactNode = ReactChild | ReactFragment | ReactPortal | boolean | null | undefined;
```

> 参考[这个issue](https://github.com/redwoodjs/redwood/issues/5104)

4. 导致这个库和主代码的类型定义不兼容，从而使 ts 报错

## 解决的流程

1. 使用 `yarn why @types/react` 查询yarn对这个依赖的解析结果，发现它解析出了 react 18.x 版本
2. 在 package.json 中加入 `"resolution": { "@types/react": "^17.0.0" }` 的配置，使yarn对包版本的解析不会产生异议，参考[yarn的文档](https://classic.yarnpkg.com/lang/en/docs/selective-version-resolutions/)
3. 最后重新`yarn`安装依赖即可
