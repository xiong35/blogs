# sequelize 的使用

> 关键词: Node.js, 后端杂记

## 引入、设置 sequelize

```js
// 下载并引入
const { Sequelize, DataTypes } = require("sequelize");
// 设置连接的信息
const sequelize = new Sequelize("DB_NAME", "ACCOUNT", "PASSWORD", {
  host: "127.0.0.1",
  dialect: "mysql",
  define: {
    underscored: true,
    freezeTableName: false,
    charset: "utf8mb4",
    dialectOptions: {
      // 使 mysql 支持 emoji
      collate: "utf8_general_ci",
      charset: "utf8mb4",
    },
    timestamps: true,
  },
});

// 使 mysql 支持 emoji
sequelize.query("SET NAMES utf8mb4;");

module.exports = {
  sequelize,
  DataTypes,
  Sequelize,
};
```

## 定义模型

```js
const { DataTypes, sequelize, Sequelize } = require("./sequelize");
const { STRING, INTEGER, TEXT, BIGINT } = DataTypes;

// 创建模型, image 和 tag 有多对多关系
const ImageModel = sequelize.define("image", {
  id: { type: INTEGER, primaryKey: true, autoIncrement: true },
  path: STRING,
  datetime: BIGINT,
  brief: STRING,
  level: { type: INTEGER, defaultValue: 9 },
});

const TagModel = sequelize.define(
  "tag",
  {
    id: { type: INTEGER, primaryKey: true, autoIncrement: true },
    name: STRING,
  },
  { timestamps: false }
);

// 创建接邻表
const ImageTagModel = sequelize.define("image_tag", {}, { timestamps: false });

// 设置关系
ImageModel.belongsToMany(TagModel, {
  through: ImageTagModel,
});
TagModel.belongsToMany(ImageModel, {
  through: ImageTagModel,
});

ImageTagModel.sync({ alter: true });
ImageModel.sync({ alter: true });
TagModel.sync({ alter: true });

module.exports = { ImageModel, TagModel, ImageTagModel };
```

## 使用模型

```js
const { ImageModel, TagModel } = require("../models/image");

async function create({ tagNames, brief, file, level, datetime }) {
  let tags = await TagModel.findAll({
    where: {
      name: tagNames.split(","),
    },
  });

  const imageInfo = {
    brief,
    path: res.key,
    level,
    datetime: datetime || Date.now(),
  };
  const image = await ImageModel.create(imageInfo, {
    include: TagModel,
  });

  await image.setTags(tags);
  await image.reload();
  return image;
}
```
