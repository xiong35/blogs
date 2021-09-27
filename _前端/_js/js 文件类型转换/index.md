# js 文件类型转换

> 关键词: JavaScript, 工具记录

## 实现的转换一览

![转换关系](https://z3.ax1x.com/2021/04/28/gPj2eP.png)

## File -> DataUrl

```ts
async function file2DataUrl(file: File): Promise<string | ArrayBuffer> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(reader.result);
    reader.onerror = reject;
    reader.readAsDataURL(file);
  });
}
```

## File -> HTMLImageElement

```ts
async function file2Image(file: File): Promise<HTMLImageElement> {
  const image = new Image();
  const URL = window.URL || window.webkitURL;

  if (
    window.navigator &&
    /(?:iPad|iPhone|iPod).*?AppleWebKit/i.test(window.navigator.userAgent)
  ) {
    // 修复IOS上webkit内核浏览器抛出错误 `The operation is insecure` 问题
    image.crossOrigin = "anonymous";
  }

  image.alt = file.name;

  return new Promise(async (resolve, reject) => {
    image.onerror = reject;
    let url: string;
    if (URL) {
      url = URL.createObjectURL(file);
    } else {
      url = await (await file2DataUrl(file)).toString();
    }
    image.onload = () => {
      resolve(image);
      URL.revokeObjectURL(url);
    };
    image.src = url;
  });
}
```

## url -> HTMLImageElement

```ts
async function url2Image(url: string): Promise<HTMLImageElement> {
  return new Promise((resolve, reject) => {
    const image = new Image();
    image.onload = () => resolve(image);
    image.onerror = reject;
    image.src = url;
  });
}
```

## HTMLImageElement -> HTMLCanvasElement

```ts
function image2Canvas(
  image: HTMLImageElement,
  dWidth,
  dHeight
): HTMLCanvasElement {
  const canvas = document.createElement("canvas");
  const ctx = canvas.getContext("2d");
  canvas.width = image.naturalWidth;
  canvas.height = image.naturalHeight;

  ctx.save();
  ctx.drawImage(image, 0, 0, dWidth, dHeight);
  ctx.restore();

  return canvas;
}
```

## HTMLCanvasElement -> DataUrl

```ts
function canvas2DataUrl(
  canvas: HTMLCanvasElement,
  quality: number = 1,
  type: string = "image/jpeg"
): string {
  return canvas.toDataURL("image/jpeg", quality);
}
```

## DateUrl -> Blob

```ts
function dataUrl2Blob(dataUrl): Blob {
  const data = dataUrl.split(",")[1];
  const mimePattern = /^data:(.*?)(;base64)?,/;
  const mime = dataUrl.match(mimePattern)[1];
  const binStr = atob(data);
  const len = data.length;
  const arr = new Uint8Array(len);

  for (let i = 0; i < len; i++) {
    arr[i] = binStr.charCodeAt(i);
  }
  return new Blob([arr], { type: mime });
}
```

## Blob -> File

```ts
function blobToFile(theBlob: Blob, fileName: string = "file"): File {
  var b: any = theBlob;
  //A Blob() is almost a File() - it's just missing the two properties below which we will add
  b.lastModifiedDate = new Date();
  b.name = fileName;

  return <File>theBlob;
}
```

## HTMLCanvasElement -> Blob

```ts
async function canvas2Blob(
  canvas: HTMLCanvasElement,
  quality: number = 1,
  type: string = "image/jpeg"
): Promise<Blob> {
  if (!HTMLCanvasElement.prototype.toBlob) {
    Object.defineProperty(HTMLCanvasElement.prototype, "toBlob", {
      value: function (callback, type, quality) {
        let dataUrl = this.toDataURL(type, quality);
        callback(dataUrl2Blob(dataUrl));
      },
    });
  }
  return new Promise((resolve) => {
    canvas.toBlob(resolve, type, quality);
  });
}
```

## 参考

- [js-image-compressor](https://github.com/wuwhs/js-image-compressor/blob/master/src/index.js)
