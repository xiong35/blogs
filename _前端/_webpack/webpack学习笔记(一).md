# webpack 学习笔记(简介)

> 关键词: webpack

## 核心概念

1. Entry: 打包的入口, 需要在这里引入 js, css 等
2. Output: 输出的位置及命名方式
3. Loader: **翻译**资源文件为 **js**
4. Plugins: 添加额外的功能, 如打包优化, 压缩文件等
5. Mode:
   1. development: 设置 process.env, 启动一系列方便代码本地调试的 plugin
   2. production: 设置 process.env, 启动一系列优化上线代码的 plugin

## 配置

> webpack.config.js  
> 只能使用 commonJS 的语法, 因为要在 node 环境运行

基本结构:

```js
const HtmlWebpackPlugin = require("html-webpack-plugin"); // 通过 npm 安装
const webpack = require("webpack"); // 用于访问内置插件

const { resolve } = require("path");

mudule.exports = {
  entry: "./src/index.js",
  output: {
    filename: "build.js",
    // __dirname: nodejs 变量, 代表当前文件目录绝对路径
    path: resolve(__dirname, "dist"),
  },

  // loader 配置
  module: {
    rules: [{ test: /\.txt$/, use: "raw-loader" }],
  },

  // plugin 配置
  plugins: [new HtmlWebpackPlugin({ template: "./src/index.html" })],

  resolve: {
    /*  */
  },

  // mode 配置, 默认为 dev
  mode: "development", // 'production'
};
```

### Entry

用法：`entry: string|Array<string>|{[entryChunkName: string]: string|Array<string>}`

#### 数组形式

会将多个文件合并到**第一个 js 文件**中, 最终只形成一个 js/bundle/chunk, 名称由 output 指定

> 一般不使用, 要用也是在 HMR 中让 html 热更新

#### 对象形式

多入口, 有几个文件就产生几个 chunk

示例(分离应用程序(app)和第三方库(vendor)入口)

```js
const config = {
  entry: {
    app: "./src/app.js",
    vendors: "./src/vendors.js",
  },
};
```

在 output 目录下产生 app 和 vendors 两个 js 文件

> 也可以使用对象+数组的语法

### Output

```js
const config = {
  output: {
    filename: "js/[name].js", // 如果Entry用了对对象形式, 需要有一个占位符
    path: "/home/public/assets", // 打包生成文件的目录
    publicPath: "/var/www/static", // 生成的html中link的src属性的前缀
    // 还可以写http地址(cdn加速时)
    chunkFilename: "js/[name]_chunk.js", // 非入口的chunk名称
    library: "[name]", // 整个代码块向外暴露的变量名(通常是造轮子的时候要用)
    libraryTarget: "window", // 将变量名添加到哪里
  },
};
```

### Module / Loader

一组链式的 loader 将按照**相反**的顺序执行。loader 链中的第一个 loader 返回值给下一个 loader。在最后一个 loader，返回 webpack 所预期的 JavaScript

```js
const config = {
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        include: [
          path.resolve(__dirname, 'app')
        ],
        exclude: [
          path.resolve(__dirname, 'app/demo-files')
        ],
        // 这里是匹配条件，每个选项都接收一个正则表达式或字符串
        // test 和 include 具有相同的作用，都是必须匹配选项
        // exclude 是必不匹配选项（优先于 test 和 include）

        loader: 'babel-loader',
        // 为了更清晰，`-loader` 后缀在 webpack 2 中不再是可选的

        options: {
          presets: ['es2015']
        },
        // loader 的可选项
      },
      {
        test: /\.css$/,
        enforce: "pre",     // 执行的优先级, pre|post, 默认中间执行
        use: [
          'style-loader',
          {
            loader: 'css-loader',
            options: {
              importLoaders: 1
            }
          },
          {
            loader: 'less-loader',
            options: {
              noIeCompat: true
            }
          }
        ]
      },
    ],
};
```

### Plugins

webpack 插件是一个具有 `apply` 属性的 JavaScript 对象。apply 属性会被 webpack compiler 调用，并且 `compiler` 对象可在整个编译生命周期访问

```js
const pluginName = "ConsoleLogOnBuildWebpackPlugin";

class ConsoleLogOnBuildWebpackPlugin {
  apply(compiler) {
    compiler.hooks.run.tap(pluginName, (compilation) => {
      console.log("webpack 构建过程开始！");
    });
  }
}
```

### resolve

```js

const config = {
  resolve: {      // （不适用于对 loader 解析）
    modules: [
      // 用于查找模块的目录, 如 node_modules
      // 优先级从上往下
      'node_modules',
      path.resolve(__dirname, 'app')
    ],

    extensions: ['.js', '.json', '.jsx', '.css'],
    // 可以省略的扩展名

    alias: {
      /* 模块别名相对于当前上下文导入 */
      Utilities: path.resolve(__dirname, 'src/utilities/'),
      // import Utility from 'Utilities/utility';
      $U: path.resolve(__dirname, 'src/utilities/'),
      // import Utility from '$U/utility';
      xyz$: path.resolve(__dirname, 'path/to/file.js'),
      // import Test1 from 'xyz'; // 精确匹配，所以 path/to/file.js 被解析和导入
      // import Test2 from 'xyz/file.js'; // 非精确匹配，触发普通解析
      { // 对象语法
        name: 'module',
        // 旧的请求
        alias: 'new-module',
        // 新的请求
        onlyModule: true  // 相当于$精确匹配
        // 如果为 true，只有 'module' 是别名
        // 如果为 false，'module/inner/path' 也是别名
      }
    }
  }
};
```

> 完整配置见: [官方文档](https://www.webpackjs.com/configuration/)
