# webpack 学习笔记(性能优化)

> 关键词: webpack

## HMR

简单做法: `devServer`中加入`hot: true`的选项

- css: 可以, style-loader 内部实现了热加载(所以开发环境还是用 style-loader 好)
- js: 默认没有 HMR
- html: 默认没有 HMR, 也不能热更新
  - 解决热更新的方法: `entry: ["./xx.js", "./xxx.html"]`

解决方案: 在 js 里加入这段话:

```js
if (mudule.hot) {
  // 如果开启了热加载
  module.hot.accept("./foo.js", () => {
    //监听foo.js的变化, 如果有变化就执行回调
    // 可以执行 foo 的关键代码, 用于更新模块
    inportantFuncFromFoo();
  });
}
```

## SourceMap

让错误通过 sourceMap, 从构建后的代码映射到源代码

在配置文件里加入`devtool: "[ops]source-map"`即可

`[ops]`如下:

- `inline-source-map`: 不额外生成 map 文件, 而是内联到构建出的代码里, 构建速度快一点
- `hidden-source-map`: 在外部生成 map 文件, 但是报错位置**不是源代码位置**, 可以隐藏源代码
- `eval-source-map`: 对每个模块单独生成内联的 map
- `cheap-source-map`: 和无参数类似, 但没有精确到列
- ...还有很多别的

最佳实践

- dev: `eval-source-map`
- prod: `nosource-source-map` / `source-map`

## 布尔规则

```js
module: {
  rules: [
    {},
    {},
    {}, //...
  ];
}
```

改为

```js
module: {
  rules: [
    (oneOf: [
      // 注意这里
      {},
      {},
      {} //...
    ]),
  ];
}
```

那么以下 loader 只会匹配一个, 避免了过多不必要的匹配

> 详见[官方文档](https://www.webpackjs.com/configuration/module/#rule-oneof)

## 缓存

### babel 缓存

在 loader 的 option 里添加`cacheDirectory: true`即可

### 浏览器缓存

指定输出文件带一个 hash 值, 这样就可以避免浏览器使用缓存了

- 普通 hash: 一个文件修改, 每个文件的缓存都失效
- chunkhash: 只要 chunk 没变, hash 就不变
- contenthash: 根据文件内容生成 hash

## TreeShaking

去除无用的代码, 按需引入

- 使用 ES6 模块化(import 等语法)
- 开启 production 环境

就会自动启动 TreeShaking

在 package.json 中设置`"sideEffect": ["*.css"]`可以防止某些文件被 shake 掉

## Code Split

基本方法: 使用 entry 的对象语法, 但是会重复下载引入的模块

进阶: `module.export`里加入

```js
optimization: {
  splitChunks: {
    chunks: "all",
    minSize: 30 * 1024,   // 分割chunk最小为30kb
    maxSize: 0            // 最大无限制
  },
  runtimeChunk: {
    // 将当前模块记录的别的模块的hash值单独打包, 避免因hash值变化而反复打包, 避免缓存失效
    name: (entryPoint) => `runtime-${entryPoint.name}`
  }
}
```

可实现将 node_modules 引入的模块打包到一起, 解决上述问题

终极方案: 除了**使用进阶方法**, 并且**不使用对象语法**之外, 将 js 调整为以下内容可以实现自定义内容的分割

```js
const fooPromise = import(/* webpackChunckName: 'foo' */ "./foo");
// 动态导入语法返回一个promise, onFulfilled 参数为模块本身
// 注释部分为此模块指定名字

fooPromise.then((foo) => {
  console.log(foo);
});
```

引入文件的懒加载: 在需要用时再用`import`函数即可

## PWA(渐进式网络开发应用)

让网页可以离线访问!!!

用法:

`npm i workbox-webpack-plugin -D`

```js
// webpack.config.js
const WorkboxWebpackPlugin = require("workbox-webpack-plugin");

module.exports = {
  /* ... */
  plugins: [
    /* ... */
    new WorkboxWebpackPlugi.GenerateSW({
      clientClaim: true,
      skipWaiting: true,
    }),
  ],
};
```

```js
// index.js
if ("serviceWorker" in navigator) {
  windows.addEventListener("load", () => {
    navigator.serviceWorker
      .register("/service-worker.js")
      .then(() => {
        console.log("Service worker started");
      })
      .catch(() => {
        /* ... */
      });
  });
}
```

## 多进程打包

> 一般给 babel 用

`npm i thread-loader -D`

将 babel 配置改为:

```js
{
  test: /\.js$/,
  exclude: /node_modules/,
  use: [
    {
      loader: "thread-loader",
      options: {
        workers: 2,
      }
    },
    {
      loader: "babel-loader",
      options: {
        presets: ["@babel/preset-env"],
        cacheDirectory: true
      }
    }
  ]
},
```

但是进程 启动/通信 有开销, 需要斟酌使用

## externals

对于外部包, 可以用这个选项避免 npm 帮你打包, 你可以转而使用 cdn 等

```js
// webpack.config.js
module.exports = {
  externals: {
    // 忽略库名: npm 包名
    jquery: "jQuery",
  },
};
```

## DLL

对第三方库们进行分块打包

`npm i add-assets-html-plugin -D`

```js
// webpack.dll.js
// 指定单独打包哪些库, 生成打包好的js和manifest文件, 只需要运行一次
// 使用 `webpack --config webpack.dll.js` 来指定使用这个配置文件
const webpack = require("webpack");

module.exports = {
  entry: {
    // 打包生成的[name]: [库名]
    jquery: ["jquery"],
  },

  output: {
    filename: "[name].js",
    path: "./dll/js/", // 打包到专门的dll目录下
    library: "[name]_[hash:10]", // 打包的库向外暴露(module.export)的名字
  },

  plugins: [
    // 生成映射文件, 打包生成build好了的第三方库
    new webpack.DllPlugin({
      name: "[name]_[hash:10]", // 映射库暴露的内容名称
      path: resolve(__dirname, "dll/manifest.json"),
    }),
  ],

  mode: "production",
};
```

```js
// webpack.config.js
const webpack = require("webpack");

const AddAssetsHtmlPlugin = require("add-assets-html-plugin");

module.exports = {
  entry: "./src/index.js",

  output: {
    filename: "build.js",
    path: "./dist/js/",
  },

  plugins: [
    // 使用映射文件, 不再让第三方库参与打包(仅此而已, 引入还需下一个插件)
    new webpack.DllReferencePlugin({
      manifest: resolve(__dirname, "dll/manifest.json"),
    }),
    // 将某个文件打包出去, 并在html中使用已经打包好的文件(需要单独指明引入谁)
    new AddAssetsHtmlPlugin({
      filePath: resolve(__dirname, "dll/jquery.js"),
    }),
  ],
};
```
