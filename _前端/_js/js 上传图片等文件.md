# js 上传图片等文件

> 关键词: JavaScript, 工具记录

```js
async function upload(url, data) {
  let res = await request({
    url,
    data,
    method: "POST",
    headers: {
      "Content-Type": "multipart/form-data;",
    },
  });
}

function selectFile() {
  return new Promise((res, rej) => {
    const el = document.createElement("input");
    el.type = "file";
    el.accept = this.accept;
    el.multiple = false;
    el.addEventListener("change", (_) => {
      res(el.files[0]);
    });
    el.click();
  });
}

async function uploadFile() {
  let file = await this.selectFile();

  if (!file || !~this.accept.indexOf(file.type)) {
    return;
  }

  let formData = new FormData(); //创建form对象
  formData.append("file", file); //通过append向form对象添加数据

  let res = await upload("/img", formData);
}
```
