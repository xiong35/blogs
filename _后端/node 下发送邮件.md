# node 下发送邮件

> 关键词: 后端杂记, Node.js

## 代码

详细见注释

```js
// 下载并引入 nodemailer
const nodemailer = require("nodemailer");

let transporter = nodemailer.createTransport({
  // 使用qq发送邮件, 支持列表：https://nodemailer.com/smtp/well-known/
  service: "qq",
  port: 465, // SMTP 端口
  secureConnection: false, // 使用了 SSL
  auth: {
    user: "xiong35@qq.com",
    pass: "xxx", // 在 qq 邮件中获得许可的 key
  },
});

let mailOpt = {
  from: "panda <xiong35@qq.com>", // 你的qq邮箱地址
  to: "xiong35@qq.com,xxxxx@qq.com", // 接受人,可以群发填写多个逗号分隔
  subject: "Hello",
  html: "<b>Hello world</b>", // html
};

module.exports = function sendMail({ subject, html }) {
  mailOpt.subject = subject;
  mailOpt.html = html;
  return new Promise((resolve, reject) => {
    transporter.sendMail(mailOpt, (error, info) => {
      if (error) {
        return reject(error);
      }
      resolve("邮件已发送成功, 邮件id: %s", info.messageId);
    });
  });
};
```
