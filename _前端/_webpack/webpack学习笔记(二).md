
# webpack学习笔记(实操)

## 基本配置

```bash
npm init

npm i webpack webpack-cli -g # once

npm i webpack webpack-cli -D

# 下载 loaders...

webpack   # 执行打包
npx webpack-dev-server    # 启动dev server
```

```js
// webpack.config.js

const { resolve } = require('path');

const HtmlWebpackPlugin = require('html-webpack-plugin'); // 通过 npm 安装
const MiniCssEctractPlugin = require("mini-css-ectract-plugin");
const OptimizeCssAssetsWebpackPlugin = require("optimize-css-assets-webpack-plugin");

const DIST = resolve(__dirname, "dist");

mudule.exports = {
  entry: "./src/index.js",

  output: {
    filename: "/js/build.[contenthash:10].js",
    // __dirname: nodejs 变量, 代表当前文件目录绝对路径
    path: DIST
  },

  // loader 配置
  module: {
    rules: [
      {
        // 下载 style-loader, css-loader, [less-loader, less]
        test: /\.css$/,
        use: [
          // "style-loader", // 创建style标签, 将js里的css插入进行, 添加到head(不是src标签)
          MiniCssEctractPlugin.loader,  // 提取css成文件, 取代style-loader
          // 下载 postcss-loader, postcss-preset-env
          // 自动适配浏览器, 根据 package.json 中的browserslist
          {
            loader: "postcss-loader",
            options: {
              ident: "postcss",
              plugins: () => [
                require("postcss-preset-env")()
              ]
            }
          },
          "css-loader"    // 将css变成commonJS模块, 里面是样式字符串
        ],
      },
      {
        // 下载 url-loader, file-loader
        test: /\.(jpg|png|gif)$/,
        loader: "url-loader",
        options: {
          limit: 8 * 1024,   // base64编码url的大小限制
          name: "[hash:10].[ext]", // 设置hash名字的长度
          outputPath: "imgs"
        }
      },
      {
        // 下载 html-loader
        test: /\.html$/,  // 负责引入img, 从而被url-loader处理
        loader: "html-loader",
      },
      { // 其他资源, 字体, svg 等
        // 下载 file-loader
        exclude: /\.(css|js|jsx|html)$/,  // 打包 其他 资源
        loader: "file-loader",
        options: {
          name: "[hash:10].[ext]", // 设置hash名字的长度
          outputPath: "media"
        }
      },
      {
        // 下载 eslint-config-airbnb-base, eslint, eslint-plugin-import
        /* package.json 添加字段
            "eslintConfig": {
              "extends": "airbnb-base",
              "env": {
                "browser": true,
              }
            } */
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "eslint-loader",    // 只检查自己写的源代码
        options: {
          fix: true
        }
      },
      {
        // 下载 babel-loader, @babel/preset-env, @babel/core, @babel/polifill
        // 在js 中加入 `import "@babel/polifill"`
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "babel-loader",
        options: {
          presets: ["@babel/preset-env"],
          cacheDirectory: true
        }
      },
      {
        test: /\.jsx?$/,
        loaders: ["react-hot-loader/webpack", "babel-loader"],
        exclude: /node_modules/,
      },
    ]
  },

  plugins: [
    // 下载 html-webpack-plugin
    // 默认创建空html, 自动引入所有打包的资源
    new HtmlWebpackPlugin({
      template: './src/index.html',  // 指定模板, 会使用模板的结构
      minify: {
        collapseWhitespace: true,
        removeComments: true
      }
    }),
    new MiniCssEctractPlugin({
      filename: 'css/main.[contenthash:10].css'
    }),
    new OptimizeCssAssetsWebpackPlugin(), // 压缩css
  ],

  resolve: {
    extensions: [".js", ".jsx", ".css", "vue"],
  },

  // mode 配置, 默认为 dev
  mode: "development", // "production"

  // 自动编译 / 刷新
  // 在内存中打包, 而不产生实际文件
  // 下载 webpack-dev-server
  devServer: {
    contentBase: DIST,
    compress: true,
    port: 3000,
    open: true,
    hot: true,    // HMR
    clientLogLevel: "none",
    quiet: true,
    watchOptions: {
      ignore: /node_modules/
    },
    overlay: false,   // 出错时不要全屏提示
    proxy: {
      // 一旦dev服务器运行端口接收到对 /api/xxx 的请求, 就把请求转发到target
      "/api": {
        target: "http://real.api/bar",
        pathRewrite: {
          // 将 /api/foo 转发为 /foo
          "^/api": "",
        }
      }
    }
  },

  devtool: "source-map",
}
```
