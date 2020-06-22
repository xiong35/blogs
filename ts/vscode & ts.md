
# vscode & ts

## 下载 ts 编译环境

> 首先你需要有 node 和 npm

`npm install -g typescript ts-node`

下载编译工具 tsc 和直接运行工具 ts-node

输入`tsc -v` 和 `ts-node -v`查看版本

## 下载 vscode 插件

推荐下载以下插件:

- prettier+
- code runnner
- typescript god
- tab nine

## 配置自动编译

在工作目录下输入 `tsc --init` 以生成配置文件

修改配置文件中的 outDir 为 "./js"

在工作目录下创建一个 package.json 文件, 输入以下内容:

```json
{
  "name": "ts",
  "version": "1.0.0",
  "description": "a ts demo",
  "author": "xiong35",
  "private": true,
  "scripts": {
    "dev": "tsc -p ./tsconfig.json --watch"
  }
}
```

在工作目录执行 `npm run dev`, 或者直接点击vscode文件目录最下方出现的 npm 脚本的 dev 指令, 开启保存自动编译功能

## hello ts

创建 index.ts 文件, 输入以下内容:

```ts
const hello: string = "Hello World!";
console.log(hello);
```

保存后即可在 ./js 文件夹下看到 index.js, 即为编译后的js文件

在目录里输入 `ts-node index.ts` 即可直接执行 ts 代码